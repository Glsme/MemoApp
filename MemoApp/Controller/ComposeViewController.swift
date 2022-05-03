//
//  ComposeViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/05/03.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력해주세요")
            return
        }
        
        let newMemo = Memo(content: memo)
        Memo.memoList.append(newMemo)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDisInsert, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension ComposeViewController {
    static let newMemoDisInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
