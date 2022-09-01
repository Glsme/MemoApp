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
    
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = UserMemoRepository.shared.localRealm.objects(UserMemo.self)
        print("Realm is located at:", UserMemoRepository.shared.localRealm.configuration.fileURL!)    // Realm file directory
    }
    
    let memoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(memoButtonClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func configureUI() {
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
        memoButton.tintColor = .orange
        mainView.memoToolbar.setItems([flexibleSpace, memoButton], animated: true)
    }
    
    @objc func memoButtonClicked() {
        print(#function)
        let vc = WriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
