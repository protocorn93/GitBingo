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
    case networkError
    case idIsEmpty
    case failToRegisterNotification
    
    var description: String {
        switch self {
        case .pageNotFound:
            return "Invaild ID".localized
        case .unexpected:
            return "Unexpected Error".localized
        case .networkError:
            return "Network Error".localized
        case .idIsEmpty:
            return "Please Input Your Github ID".localized
        case .failToRegisterNotification:
            return "Registering Notification Failed\nPlease try later".localized
        }
    }
}
