//
//  MemoAlert.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/05/03.
//

import UIKit

extension UIViewController {
    func alert (title: String = "Notice", message: String) {
        let alert = UIAlertController(title: title, message: "test 1", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
