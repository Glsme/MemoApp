//
//  MemoListViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    let mainView = MemoListView()
    
    var filterMemoList: [Results<UserMemo>] = []
    var memoList: [UserMemo] = []
    var memoListPinned: [UserMemo] = []
    
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Realm is located at:", UserMemoRepository.shared.localRealm.configuration.fileURL!)
        self.setSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
        self.navigationController?.navigationBar.topItem?.title = changeNumberFormat(for: tasks.count) + "개의 메모"
    }
    
    func fetchRealm() {
        tasks = UserMemoRepository.shared.fetch()
    }
    
    let memoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(memoButtonClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func configureUI() {
        tasks = UserMemoRepository.shared.localRealm.objects(UserMemo.self)
        
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
        memoButton.tintColor = .orange
        mainView.memoToolbar.setItems([flexibleSpace, memoButton], animated: true)
    }
    
    @objc func memoButtonClicked() {
        print(#function)
        let vc = WriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색할 메모를 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func changeDateFormat(date: Date) -> String {
        let currentDate = Date()
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale = Locale(identifier: "ko-KR")
        newDateFormatter.timeZone = TimeZone(identifier: "KST")
        
        if formatter.string(from: currentDate) == formatter.string(from: date) {
            newDateFormatter.dateFormat = "a:hh:mm"
            return newDateFormatter.string(from: date)
        } else {
            newDateFormatter.dateFormat = "yyyy.MM.dd a:hh:mm"
            return newDateFormatter.string(from: date)
        }
    }
    
    func changeNumberFormat(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number)!
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .systemFont(ofSize: 25, weight: .bold)
        
        if section == 0 {
            if !memoListPinned.isEmpty {
                header.text = "고정된 메모"
            } else {
                header.text = "메모"
            }
        } else if section == 1 {
            header.text = "메모"
        }
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        memoList = tasks.filter { $0.pin == false }
        memoListPinned = tasks.filter { $0.pin == true }
        print("!!!!!!!\(memoListPinned.count), \(memoList.count)")
        
        if memoListPinned.isEmpty, memoList.isEmpty {
            return 0
        } else if !memoListPinned.isEmpty, !memoList.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if !memoListPinned.isEmpty {
                return memoListPinned.count
            } else {
                return memoList.count
            }
        } else {
            return memoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0  {
            if !memoListPinned.isEmpty {
                cell.titleLabel.text = memoListPinned[indexPath.row].memoTitle
                cell.subtitleLabel.text = changeDateFormat(date: memoListPinned[indexPath.row].date) + " " + memoListPinned[indexPath.row].memoContent
            } else {
                cell.titleLabel.text = memoList[indexPath.row].memoTitle
                cell.subtitleLabel.text = changeDateFormat(date: memoList[indexPath.row].date) + " " + memoList[indexPath.row].memoContent
            }
        } else {
            cell.titleLabel.text = memoList[indexPath.row].memoTitle
            cell.subtitleLabel.text = changeDateFormat(date: memoList[indexPath.row].date) + " " + memoList[indexPath.row].memoContent
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var low = UserMemo(memoTitle: "", memoContent: "", date: Date(), pin: false)
        
        switch indexPath.section {
        case 0:
            if !memoListPinned.isEmpty {
                low = memoListPinned[indexPath.row]
            } else {
                low = memoList[indexPath.row]
            }
            
            let pinned = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                UserMemoRepository.shared.updatePinned(low)
                self.fetchRealm()
            }
            
            let image = tasks[indexPath.row].pin ? "pin.slash.fill" : "pin.fill"
            pinned.image = UIImage(systemName: image)
            pinned.backgroundColor = .orange
            
            return UISwipeActionsConfiguration(actions: [pinned])
        case 1:
            low = memoList[indexPath.row]
            
            let pinned = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                if self.memoListPinned.count >= 5 {
                    self.showAlert(message: "고정할 수 있는 최대 메모 개수는 5개입니다.")
                    
                } else {
                    UserMemoRepository.shared.updatePinned(low)
                    self.fetchRealm()
                }
            }
            
            let image = tasks[indexPath.row].pin ? "pin.slash.fill" : "pin.fill"
            pinned.image = UIImage(systemName: image)
            pinned.backgroundColor = .orange
            
            return UISwipeActionsConfiguration(actions: [pinned])
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let task = self.tasks[indexPath.row]
            self.showDeleteMemoAlert(task)
        }
        
        let image = UIImage(systemName: "trash.fill")
        delete.image = image
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func showDeleteMemoAlert(_ task: UserMemo) {
        let alert = UIAlertController(title: "주의", message: "메모를 정말 삭제하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            UserMemoRepository.shared.delete(task)
            self.fetchRealm()
            
            self.navigationController?.navigationBar.topItem?.title = self.changeNumberFormat(for: self.tasks.count) + "개의 메모"
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        
        if indexPath.section == 0 {
            if !memoListPinned.isEmpty {
                UserMemoRepository.shared.primaryKey = memoListPinned[indexPath.row].objectId
                vc.mainView.memoTextView.text = memoListPinned[indexPath.row].memoTitle + "\n" + memoListPinned[indexPath.row].memoContent
            } else {
                UserMemoRepository.shared.primaryKey = memoList[indexPath.row].objectId
                vc.mainView.memoTextView.text = memoList[indexPath.row].memoTitle + "\n" + memoList[indexPath.row].memoContent
            }
        } else {
            UserMemoRepository.shared.primaryKey = memoList[indexPath.row].objectId
            vc.mainView.memoTextView.text = memoList[indexPath.row].memoTitle + "\n" + memoList[indexPath.row].memoContent
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        print(text)
    }
}
