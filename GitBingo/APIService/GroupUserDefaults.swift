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
    
    func save<T: Codable>(_ data: T, of type: KeyIdentifier) {
        switch type {
        case .contributions:
            guard let encoded = try? PropertyListEncoder().encode(data) else { return }
            groupUserDefaults.set(encoded, forKey: type.value)
        default:
            groupUserDefaults.set(data, forKey: type.value)
        }
    }
    
    func load(of type: KeyIdentifier) -> Any? {
        switch type {
        case .contributions:
            if let data = groupUserDefaults.object(forKey: type.value) as? Data {
                return try? PropertyListDecoder().decode(Contribution.self, from: data)
            }
        default:
            return groupUserDefaults.value(forKey: type.value)
        }
        return nil
    }
    
    func remove(of type: KeyIdentifier) {
        groupUserDefaults.removeObject(forKey: type.value)
    }
}
