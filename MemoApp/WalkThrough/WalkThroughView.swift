//
//  WalkThroughView.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/05.
//

import UIKit
import SnapKit

class WalkThorughView: BaseView {
    
    let popUpView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .tableViewCellColor
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .textColor
        view.numberOfLines = 0
        view.text = """
        처음 오셨군요!
        환영합니다 :)
        
        당신만의 메모를 작성하고
        관리해보세요!
        """
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        return view
    }()
    
    let okButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.setTitle("확인", for: .normal)
        view.setTitleColor(UIColor.textColor, for: .normal)
        view.backgroundColor = .orange
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        popUpView.addSubview(descriptionLabel)
        popUpView.addSubview(okButton)
        self.addSubview(popUpView)
    }
    
    override func setConstraints() {
        popUpView.snp.makeConstraints { make in
            make.width.height.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.65)
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popUpView)
            make.topMargin.equalTo(20)
            make.width.equalTo(popUpView).multipliedBy(0.8)
        }
        
        okButton.snp.makeConstraints { make in
            make.centerX.equalTo(popUpView)
            make.bottomMargin.equalTo(-20)
            make.width.equalTo(descriptionLabel.snp.width)
            make.height.equalTo(popUpView).multipliedBy(0.2)
        }
    }
}
