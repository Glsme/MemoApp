//
//  ComposeViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/05/03.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력해주세요")
            return
        }
        
        if let target = editTarget {
            target.content = memo
            NotificationCenter.default.post(name: ComposeViewController.MemoDidChange, object: nil)
        } else {
        
        let newMemo = Memo(content: memo)
        Memo.memoList.append(newMemo)
        NotificationCenter.default.post(name: ComposeViewController.newMemoDisInsert, object: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationItem.title = "새로운 메모"
            memoTextView.text = ""
        }
//        memoTextView.delegate = self
    }
}

extension ComposeViewController {
    static let newMemoDisInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let MemoDidChange = Notification.Name(rawValue: "MemoDidChange")
}
