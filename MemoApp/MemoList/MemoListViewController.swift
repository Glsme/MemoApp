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
    
    var normalTasks: Results<UserMemo>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    
    var pinnedTasks: Results<UserMemoPinned>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        print("Realm is located at:", UserMemoRepository.shared.localRealm.configuration.fileURL!)
        self.setSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
    }
    
    func fetchRealm() {
        normalTasks = UserMemoRepository.shared.fetchUserMemo()
        pinnedTasks = UserMemoRepository.shared.fetchUserMemoPinned()
    }
    
    let memoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(memoButtonClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func configureUI() {
        normalTasks = UserMemoRepository.shared.localRealm.objects(UserMemo.self)
        pinnedTasks = UserMemoRepository.shared.localRealm.objects(UserMemoPinned.self)

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
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .systemFont(ofSize: 25, weight: .bold)
        
        if pinnedTasks.isEmpty {
            if normalTasks.isEmpty {
                header.text = "고정된 메모"
            } else {
                header.text = "메모"
            }
        } else {
            if section == 0 {
                header.text = "고정된 메모"
            } else if section == 1 {
                header.text = "메모"
            }
        }
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if pinnedTasks.isEmpty, normalTasks.isEmpty {
            return 0
        } else if !pinnedTasks.isEmpty, !normalTasks.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pinnedTasks.isEmpty {
            return normalTasks.count
        } else {
            if section == 0 {
                return pinnedTasks.count
            } else if section == 1 {
                return normalTasks.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if !normalTasks.isEmpty {
                print("!!!!!!!!!!", pinnedTasks.count, normalTasks.count)
                cell.titleLabel.text = normalTasks[indexPath.row].memoTitle
                cell.subtitleLabel.text = String(describing: normalTasks[indexPath.row].date)
            } else if !pinnedTasks.isEmpty {
                cell.titleLabel.text = pinnedTasks[indexPath.row].memoTitle
                cell.subtitleLabel.text = String(describing: pinnedTasks[indexPath.row].date)
            }
        } else {
            cell.titleLabel.text = normalTasks[indexPath.row].memoTitle
            cell.subtitleLabel.text = String(describing: normalTasks[indexPath.row].date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinned = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            UserMemoRepository.shared.updatePinned(self.normalTasks[indexPath.row])
            self.fetchRealm()
        }
        
        let image = normalTasks[indexPath.row].pin ? "pin.fill" : "pin.slash"
        pinned.image = UIImage(systemName: image)
        pinned.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [pinned])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            let task = self.normalTasks[indexPath.row]
            
            UserMemoRepository.shared.delete(task)
            self.fetchRealm()
        }
        
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        print(text)
    }
}
