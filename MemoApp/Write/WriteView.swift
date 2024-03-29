//
//  WriteView.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    let memoTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .backgroundColor
        view.font = .systemFont(ofSize: 16, weight: .medium)
        let spacing: CGFloat = 20
        view.textContainerInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .tableViewCellColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        self.addSubview(memoTextView)
    }
    
    override func setConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
