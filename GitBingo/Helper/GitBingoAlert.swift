//
//  GitBingoAlert.swift
//  GitBingo
//
//  Created by 이동건 on 22/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

enum GitBingoAlert {
    case register(Bool, String)
    case unauthorized
    case registerFailed
    case removeNotification(((UIAlertAction)->())?)
    
    func getAlert(_ completion: @escaping (UIAlertAction)->Void) -> UIAlertController {
        switch self {
        case .register(let hasScheduledNotification, let time):
            if hasScheduledNotification {
                return UIAlertController.getAlert(title: "🤓", message: "Scheduled Notification Existed.\nDo you want to UPDATE it to %@?".localized(with: time), with: completion)
            }
            
            return UIAlertController.getAlert(title: "Register".localized, message: "Do you want to GET Notification at\n%@ daily?".localized(with: time), with: completion)
        case .unauthorized:
            return UIAlertController.getAlert(title: "Not Authorized".localized, message: "CHECK Notifications Configuration in Settings".localized)
        case .registerFailed:
            return UIAlertController.getAlert(title: "Error".localized, message: GitBingoError.failToRegisterNotification.description)
        case .removeNotification(let handler):
            return UIAlertController.getAlert(title: "Remove".localized, message: "Do you really want to REMOVE Scheduled Notification?".localized, with: handler)
        }
    }
}
