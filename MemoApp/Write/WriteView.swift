//
//  WriteView.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    let memoTextField: UITextView = {
        let view = UITextView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        self.addSubview(memoTextField)
    }
    
    override func setConstraints() {
        memoTextField.snp.makeConstraints { make in
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
    
}
