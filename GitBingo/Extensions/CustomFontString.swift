//
//  CustomFontString.swift
//  GitBingo
//
//  Created by 이동건 on 02/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

extension String {
    var customFont: NSMutableAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Apple Color Emoji", size: 17) ?? .systemFont(ofSize: 10)
        ]
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}
