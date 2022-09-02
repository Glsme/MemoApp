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
    
    func fetchUserMemo() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "date", ascending: false)
    }
}
