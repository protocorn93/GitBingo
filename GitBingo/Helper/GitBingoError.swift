//
//  GitergyError.swift
//  Gitergy
//
//  Created by 이동건 on 01/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

enum GitBingoError: Error {
    case pageNotFound
    case unexpected
    case idIsEmpty
    
    var description: String {
        switch self {
        case .pageNotFound:
            return "Invaild ID"
        case .unexpected:
            return "Unexpected Error"
        case .idIsEmpty:
            return "Please Input Your Github ID"
        }
    }
}
