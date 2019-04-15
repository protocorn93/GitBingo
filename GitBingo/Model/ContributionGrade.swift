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
    case noneGreen = "#ebedf0"
    case lessGreen = "#c6e48b"
    case normalGreen = "#7bc96f"
    case hardGreen = "#239a3b"
    case extremeGreen = "#196127"
    
    case lessHalloween = "#feec59"
    case normalHalloween = "#fec42e"
    case hardHalloween = "#fc9526"
    case extremeHalloween = "#03011b"

    var color: UIColor {
        switch self {
        case .notYet:
            return UIColor(hex: 0xffffff)
        case .noneGreen:
            return UIColor(hex: 0xebedf0)
        case .lessGreen:
            return UIColor(hex: 0xc6e48b)
        case .normalGreen:
            return UIColor(hex: 0x7bc96f)
        case .hardGreen:
            return UIColor(hex: 0x239a3b)
        case .extremeGreen:
            return UIColor(hex: 0x196127)
        case .lessHalloween:
            return UIColor(hex: 0xfeec59)
        case .normalHalloween:
            return UIColor(hex: 0xfec42e)
        case .hardHalloween:
            return UIColor(hex: 0xfc9526)
        case .extremeHalloween:
            return UIColor(hex: 0x03011b)
        }
    }
}
