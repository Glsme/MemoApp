//
//  WriteViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import UIKit

class WriteViewController: BaseViewController {
    
    let mainView = WriteView()
    
    let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: #selector(saveData))
    let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: #selector(shareButtonClicked))
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.topItem?.title = "메모"
    }
    
    override func configureUI() {
        mainView.memoTextView.delegate = self
        self.navigationController?.navigationBar.tintColor = .orange
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("메모", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [leftBarButton]
        
        if UserMemoRepository.shared.primaryKey == nil {
            self.navigationItem.rightBarButtonItems = [saveButton, shareButton]
            mainView.memoTextView.becomeFirstResponder()
        }
    }
    
    @objc func shareButtonClicked() {
        let activityViewController = UIActivityViewController(activityItems: ["활동 선택하기"], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true)
    }
    
    @objc func saveData() {
        editMemo()
        self.navigationController?.popViewController(animated: true)
    }
    
    func editMemo() {
        var memoTitle: String = ""
        var memoContent: String = ""
        
        // 메모 편집
        if let primaryKey = UserMemoRepository.shared.primaryKey {
            
            var task = UserMemo(memoTitle: "", memoContent: "", date: Date(), regDate: Date(), pin: false)
            
            let result = UserMemoRepository.shared.localRealm.objects(UserMemo.self).filter { $0.objectId == primaryKey }.first
            print(result)
            
            for item in UserMemoRepository.shared.localRealm.objects(UserMemo.self) {
                if item.objectId == primaryKey {
                    task = item
                    break
                }
            }
            
            if let title = mainView.memoTextView.text, !mainView.memoTextView.text!.isEmpty {
                if title.contains("\n") {
                    var text = title.components(separatedBy: "\n")
                    memoTitle = text[0]
                    text.removeFirst()
//                    memoContent = text.reduce("") { $0 + "\n" + $1 }
                    for item in text {
                        memoContent += item + "\n"
                    }
                } else {
                    memoTitle = title
                }
                
                UserMemoRepository.shared.updateMemo(task, memoTitle: memoTitle, memoContent: memoContent, date: Date())
            } else {
                print("delete Data")
                UserMemoRepository.shared.delete(task)
            }
            
            UserMemoRepository.shared.primaryKey = nil
        }
        else {
            // 새 메모 작성
            if let title = mainView.memoTextView.text, !mainView.memoTextView.text!.isEmpty {
                if title.contains("\n") {
                    var text = title.components(separatedBy: "\n")
                    memoTitle = text[0]
                    text.removeFirst()

                    for item in text {
                        memoContent += item + "\n"
                    }
                } else {
                    memoTitle = title
                }
                
                let task = UserMemo(memoTitle: memoTitle, memoContent: memoContent, date: Date(), regDate: Date(), pin: false)
                UserMemoRepository.shared.write(task)
            }
        }
    }
}

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
}
