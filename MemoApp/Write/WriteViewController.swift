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
        editMemo()
        self.navigationController?.popViewController(animated: true)
    }
    
    func editMemo() {
        // 메모 편집
        if let primaryKey = UserMemoRepository.shared.primaryKey {
            var task = UserMemo(memoTitle: "", memoContent: "", date: Date(), pin: false)
            
//            let result = UserMemoRepository.shared.localRealm.objects(UserMemo.self).filter { $0.objectId == primaryKey }
//            print(result)

            for item in UserMemoRepository.shared.localRealm.objects(UserMemo.self) {
                if item.objectId == primaryKey {
                    task = item
                    break
                }
            }
            
            if let title = mainView.memoTextView.text, !mainView.memoTextView.text!.isEmpty {
                print("@@@@@@@", title)
                UserMemoRepository.shared.updateMemo(task, memoTitle: title, memoContent: "", date: Date())
            } else {
                print("delete Data")
                UserMemoRepository.shared.delete(task)
            }
    
            UserMemoRepository.shared.primaryKey = nil
        }
        else {
            // 새 메모 작성
            if let title = mainView.memoTextView.text, !mainView.memoTextView.text!.isEmpty {
                var memoTitle: String = ""
                var memoContent: String = ""
                
                if title.contains("\n") {
                    var text = title.components(separatedBy: "\n")
                    memoTitle = text[0]
                    text.removeFirst()
                    memoContent = text.reduce("") { $0 + " " + $1 }
                } else {
                    memoTitle = title
                }
                let task = UserMemo(memoTitle: memoTitle, memoContent: memoContent, date: Date(), pin: false)
                UserMemoRepository.shared.write(task)
            }
        }
    }
}
