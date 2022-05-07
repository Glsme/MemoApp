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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
    }
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            isModalInPresentation = original != edited
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집된 메모를 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.saveButton(action)
        }
        alert.addAction(okAction)
        
        let cancerAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.closeButton(action)
        }
        alert.addAction(cancerAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
    static let newMemoDisInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let MemoDidChange = Notification.Name(rawValue: "MemoDidChange")
}
