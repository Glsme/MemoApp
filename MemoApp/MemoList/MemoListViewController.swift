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
    
    var memoListFiltered: [UserMemo] = []
    var memoList: [UserMemo] = []
    var memoListPinned: [UserMemo] = []
    
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
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
        self.navigationItem.title = changeNumberFormat(for: tasks.count) + "개의 메모"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        checkFirstRunningApp()
    }
    
    func checkFirstRunningApp() {
        if !UserDefaults.standard.bool(forKey: "first") {
            let vc = WalkThroughViewController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    func fetchRealm() {
        tasks = UserMemoRepository.shared.fetch()
    }
    
    let memoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(memoButtonClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func configureUI() {
        tasks = UserMemoRepository.shared.localRealm.objects(UserMemo.self)
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationItem.title = changeNumberFormat(for: tasks.count) + "개의 메모"
        
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
        memoButton.tintColor = .orange
        mainView.memoToolbar.setItems([flexibleSpace, memoButton], animated: true)
        mainView.memoListTableView.keyboardDismissMode = .onDrag
    }
    
    @objc func memoButtonClicked() {
        print(#function)
        let vc = WriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSearchController() {
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
            
            newDateFormatter.dateFormat = "yyyy-MM-dd-e"
            let day = newDateFormatter.string(from: currentDate)
//            print("!!!!!!!!", day)
            let today = day.components(separatedBy: "-")
            
            guard let interval = Double(today[3]) else { return "" }
            let startDay = Date(timeIntervalSinceNow: -(86400 * (interval - 1)))
            let week = newDateFormatter.string(from: startDay)
            let weekArray = week.components(separatedBy: "-").map { Int($0)! }
            
            let dateComponents = DateComponents(year: weekArray[0], month: weekArray[1], day: weekArray[2])
            let startDate = Calendar.current.date(from: dateComponents)!
            let offsetComps = Calendar.current.dateComponents([.day], from: startDate, to: date)
            
            guard let day = offsetComps.day else { return "" }
//            print(day, "만큼 차이난다")
            
            if day >= 0 {
                newDateFormatter.dateFormat = "eeee"
                return newDateFormatter.string(from: date)
            } else {
                newDateFormatter.dateFormat = "yyyy.MM.dd a:hh:mm"
                return newDateFormatter.string(from: date)
            }
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
        
        if isFiltering {
            header.text = "\(memoListFiltered.count)개 찾음"
        } else {
            if section == 0 {
                if !memoListPinned.isEmpty {
                    header.text = "고정된 메모"
                } else {
                    header.text = "메모"
                }
            } else if section == 1 {
                header.text = "메모"
            }
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        memoList = tasks.filter { $0.pin == false }
        memoListPinned = tasks.filter { $0.pin == true }
//        print("!!!!!!!\(memoListPinned.count), \(memoList.count)")
        
        if isFiltering {
            return 1
        } else {
            if memoListPinned.isEmpty, memoList.isEmpty {
                return 0
            } else if !memoListPinned.isEmpty, !memoList.isEmpty {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return memoListFiltered.count
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if isFiltering {
            let memoContent = memoListFiltered[indexPath.row].memoContent.components(separatedBy: "\n").reduce(" ") { $0 + " " + $1 }
            
            cell.titleLabel.text = memoListFiltered[indexPath.row].memoTitle
            cell.subtitleLabel.text = changeDateFormat(date: memoListFiltered[indexPath.row].date) + memoContent
            
            let searchText = searchController.searchBar.text!
            let titleLabel = NSMutableAttributedString(string: cell.titleLabel.text!)
            let subtitleLabel = NSMutableAttributedString(string: cell.subtitleLabel.text!)
            
            titleLabel.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.titleLabel.text! as NSString).range(of: searchText))
            subtitleLabel.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.subtitleLabel.text! as NSString).range(of: searchText))
            
            cell.titleLabel.attributedText = titleLabel
            cell.subtitleLabel.attributedText = subtitleLabel
            
        } else {
            cell.titleLabel.textColor = UIColor.textColor
            cell.subtitleLabel.textColor = UIColor.textColor
            
            if indexPath.section == 0  {
                if !memoListPinned.isEmpty {
                    let memoContent = memoListPinned[indexPath.row].memoContent.components(separatedBy: "\n").reduce(" ") { $0 + " " + $1 }
                    cell.titleLabel.text = memoListPinned[indexPath.row].memoTitle
                    cell.subtitleLabel.text = changeDateFormat(date: memoListPinned[indexPath.row].date) + memoContent
                } else {
                    let memoContent = memoList[indexPath.row].memoContent.components(separatedBy: "\n").reduce(" ") { $0 + " " + $1 }
                    cell.titleLabel.text = memoList[indexPath.row].memoTitle
                    cell.subtitleLabel.text = changeDateFormat(date: memoList[indexPath.row].date) + memoContent
                }
            } else {
                let memoContent = memoList[indexPath.row].memoContent.components(separatedBy: "\n").reduce(" ") { $0 + " " + $1 }
                cell.titleLabel.text = memoList[indexPath.row].memoTitle
                cell.subtitleLabel.text = changeDateFormat(date: memoList[indexPath.row].date) + memoContent
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var low = UserMemo(memoTitle: "", memoContent: "", date: Date(), regDate: Date(), pin: false)
        
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
            
            let image = low.pin ? "pin.slash.fill" : "pin.fill"
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
            
            let image = low.pin ? "pin.slash.fill" : "pin.fill"
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
        
        if isFiltering {
            UserMemoRepository.shared.primaryKey = memoListFiltered[indexPath.row].objectId
            vc.mainView.memoTextView.text = memoListFiltered[indexPath.row].memoTitle + "\n" + memoListFiltered[indexPath.row].memoContent
        } else {
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
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        memoListFiltered = tasks.filter { $0.memoTitle.contains(text) || $0.memoContent.contains(text) }
        
        mainView.memoListTableView.reloadData()
    }
}
