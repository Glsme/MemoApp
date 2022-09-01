//
//  RealmModel.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import Foundation
import RealmSwift

class UserMemo: Object {
    @Persisted var memoTitle: String
    @Persisted var memoContent: String?
    @Persisted var date = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoContent: String?, date: Date) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.date = date
    }
}
