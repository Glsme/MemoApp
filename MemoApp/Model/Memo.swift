//
//  Memo.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/05/01.
//

import Foundation

class Memo {
    var content: String
    var date: Date
    
    init(content: String) {
        self.content = content
        self.date = Date()
    }
    
    static var memoList: [Memo] = [
        Memo.init(content: "Test 1")
    ]
}
