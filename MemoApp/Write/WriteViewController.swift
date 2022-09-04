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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "메모"
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
        guard let title = mainView.memoTextView.text, !mainView.memoTextView.text!.isEmpty else {
            showAlert(message: "메모를 입력해주세요")
            return
        }
        
        if let primaryKey = UserMemoRepository.shared.primaryKey {
            
            
//            let result = UserMemoRepository.shared.localRealm.objects(UserMemo.self).filter { $0.objectId == primaryKey }
//            print(result)
            
            for task in UserMemoRepository.shared.localRealm.objects(UserMemo.self) {
                if task.objectId == primaryKey {
                    UserMemoRepository.shared.updateMemo(task, memoTitle: title, memoContent: nil, date: Date())
                    UserMemoRepository.shared.primaryKey = nil
                    break
                }
            }
            
        } else {
            let task = UserMemo(memoTitle: title, memoContent: nil, date: Date(), pin: false)
            UserMemoRepository.shared.write(task)
        }
        
        print("End Function")
        self.navigationController?.popViewController(animated: true)
    }
    
}
