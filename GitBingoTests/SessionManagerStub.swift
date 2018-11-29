//
//  SessionManagerStub.swift
//  GitBingoTests
//
//  Created by 이동건 on 29/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

class SessionManagerStub: SessionManagerProtocol {
    private var error: GitBingoError? // 테스트를 위한 에러
    
    init(_ error: GitBingoError? = nil) {
        self.error = error
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, error) // Call Synchronous
        return URLSessionDataTask()
    }
}
