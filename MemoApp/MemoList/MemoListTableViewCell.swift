//
//  MemoListTableViewCell.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit
import SnapKit

class MemoListTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .light)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        [titleLabel, subtitleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
        subtitleLabel.snp.makeConstraints { make in
            make.leadingMargin.equalTo(10)
            make.bottomMargin.equalTo(-2)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.9)
            make.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(subtitleLabel.snp.leading)
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-5)
            make.width.equalTo(subtitleLabel.snp.width)
            make.height.equalTo(20)
        }
    }
}
