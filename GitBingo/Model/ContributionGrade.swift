//
//  ContributionGrade.swift
//  Gitergy
//
//  Created by 이동건 on 24/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

enum ContributionGrade: String {
    case notYet = "#ffffff"
    case none = "#ebedf0"
    case less = "#c6e48b"
    case normal = "#7bc96f"
    case hard = "#239a3b"
    case extreme = "#196127"

    var color: UIColor {
        switch self {
        case .notYet:
            return UIColor(hex: 0xffffff)
        case .none:
            return UIColor(hex: 0xebedf0)
        case .less:
            return UIColor(hex: 0xc6e48b)
        case .normal:
            return UIColor(hex: 0x7bc96f)
        case .hard:
            return UIColor(hex: 0x239a3b)
        case .extreme:
            return UIColor(hex: 0x196127)
        }
    }
}
