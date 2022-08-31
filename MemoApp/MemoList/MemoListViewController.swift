//
//  MemoListViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit

class MemoListViewController: BaseViewController {
    
    let mainView = MemoListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
    }
    
    override func configureUI() {
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
