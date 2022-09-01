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
}
