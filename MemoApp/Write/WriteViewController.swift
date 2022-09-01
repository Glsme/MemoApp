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
}
