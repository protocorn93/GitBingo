//
//  HTMLParsingProtocol.swift
//  GitBingo
//
//  Created by 이동건 on 29/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

protocol HTMLParsingProtocol: class {
    func parse(from data: Data?) -> Contribution?
}
