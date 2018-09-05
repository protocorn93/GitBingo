//
//  LocalizedString.swift
//  GitBingo
//
//  Created by 이동건 on 05/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: "\(self)", comment: "")
    }
    
    func localized(with value: String) -> String {
        let format = NSLocalizedString(self, tableName: "Localizable", value: "\(self)", comment: "")
        return String.localizedStringWithFormat(format, value)
    }
}
