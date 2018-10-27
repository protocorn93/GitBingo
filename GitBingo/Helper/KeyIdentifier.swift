//
//  KeyIdentifier.swift
//  GitBingo
//
//  Created by 이동건 on 03/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

enum KeyIdentifier {
    case id
    case notification
    
    var value: String {
        switch self {
        case .id:
            return "id"
        case .notification:
            return "notification"
        }
    }
}
