//
//  AppURL.swift
//  GitBingo
//
//  Created by 이동건 on 27/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

enum AppURL {
    case authentication
    case notificaiton
    
    var path: String {
        switch self {
        case .authentication:
            return "authentication"
        case .notificaiton:
            return "notification"
        }
    }
}
