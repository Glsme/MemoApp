//
//  MemoListView.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit
import SnapKit

class MemoListView: BaseView {
    
    let memoListTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .black
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        [memoListTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        memoListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
