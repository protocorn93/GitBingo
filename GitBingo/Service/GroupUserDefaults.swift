//
//  GroupUserDefaults.swift
//  GitBingo
//
//  Created by 이동건 on 27/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

protocol GitbingoStorage {
    func save<T>(_ data: T, of type: KeyIdentifier)
    func load<T>(of type: KeyIdentifier) -> T?
    func remove(of type: KeyIdentifier)
}

class UserProfileStorage: GitbingoStorage {
    private var userDefaults: UserDefaults?
    
    init(_ suiteName: String) {
        self.userDefaults = UserDefaults(suiteName: suiteName)
    }
    
    func save<T>(_ data: T, of type: KeyIdentifier) {
        print(data)
        userDefaults?.set(data, forKey: type.value)
    }
    
    func load<T>(of type: KeyIdentifier) -> T? {
        return userDefaults?.value(forKey: type.value) as? T
    }
    
    func remove(of type: KeyIdentifier) {
        userDefaults?.removeObject(forKey: type.value)
    }
}

class GroupUserDefaults {
    static let shared = GroupUserDefaults()
    private var groupUserDefaults = UserDefaults(suiteName: "group.Gitbingo")!
    private init() {}

    func save(_ data: String, of type: KeyIdentifier) {
        groupUserDefaults.set(data, forKey: type.value)
    }

    func load(of type: KeyIdentifier) -> Any? {
        return groupUserDefaults.value(forKey: type.value)
    }

    func remove(of type: KeyIdentifier) {
        groupUserDefaults.removeObject(forKey: type.value)
    }
}
