//
//  WriteViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import UIKit

class WriteViewController: BaseViewController {
    
    let mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureUI() {
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked)),
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        ]
        mainView.memoTextView.becomeFirstResponder()
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func saveButtonClicked() {
        
    }
    
    
}
