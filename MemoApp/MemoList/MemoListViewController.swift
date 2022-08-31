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
        
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
