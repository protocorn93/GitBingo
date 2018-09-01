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
            return "존재하지 않는 아이디입니다."
        case .unexpected:
            return "예상치 못한 오류가 발생하였습니다."
        case .idIsEmpty:
            return "아이디를 입력해주세요."
        }
    }
}