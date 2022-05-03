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
//        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
