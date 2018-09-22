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
}
