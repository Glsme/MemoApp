//
//  MemoListView.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit

class MemoListView: BaseView {
    
    let memoListTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        
    }
    
    override func setConstraints() {
        
    }
}
