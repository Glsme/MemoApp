//
//  UserMemoRepository.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/09/01.
//

import Foundation
import RealmSwift

class UserMemoRepository {
    
    static let shared = UserMemoRepository()
    
    private init() { }
    
    let localRealm = try! Realm()

    var primaryKey: ObjectId?
    
    func write(_ task: UserMemo) {
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func delete(_ task: UserMemo) {
        try! localRealm.write {
            localRealm.delete(task)
        }
    }
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func updatePinned(_ task: UserMemo) {
        try! localRealm.write {
            task.pin = !task.pin
        }
    }
    
    func updateMemo(_ task: UserMemo, memoTitle: String, memoContent: String, date: Date) {
        try! localRealm.write {
            task.memoTitle = memoTitle
            task.memoContent = memoContent
            task.date = Date()
        }
    }
}
