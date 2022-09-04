//
//  WalkThroughViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/05.
//

import UIKit

class WalkThroughViewController: BaseViewController {
    
    let mainView = WalkThorughView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    override func configureUI() {
        mainView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    @objc func okButtonClicked() {
        UserDefaults.standard.set(false, forKey: "first")
        dismiss(animated: true)
    }

}
