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
        view.backgroundColor = .backgroundColor
        
        return view
    }()
    
    let memoToolbar: UIToolbar = {
        let view = UIToolbar()
        
        return view
    }()
    
    let memoButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(memoButtonClicked))
    
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        memoButton.image = UIImage(systemName: "square.and.pencil")
        memoButton.tintColor = .orange
        
        memoToolbar.setItems([flexibleSpace, memoButton], animated: true)
        
        [memoListTableView, memoToolbar].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        memoToolbar.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        memoListTableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(memoToolbar.snp.top)
        }
    }
    
    @objc func memoButtonClicked() {
        print(#function)
    }
}
