//
//  GroupUserDefaults.swift
//  GitBingo
//
//  Created by 이동건 on 27/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

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
