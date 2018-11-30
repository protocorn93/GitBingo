//
//  APIServiceStub.swift
//  GitBingoTests
//
//  Created by 이동건 on 29/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import XCTest

class APIServiceStub: APIServiceProtocol {
    private var session: SessionManagerProtocol
    var error: GitBingoError?
    var contributions: Contribution?

    init(_ session: SessionManagerProtocol) {
        self.session = session
    }

    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) -> Void) {
        guard let url = URL(string: "https://github.com/users/\(id)/contributions") else {
            self.error = .pageNotFound
            completion(nil, .pageNotFound)
            XCTestExpectation(description: "Fail").fulfill()
            return
        }

        let task = session.dataTask(with: url) { (_, _, error) in
            if let error = error {
                self.error = error as? GitBingoError
                completion(nil, self.error)
                return
            }

            self.contributions = Contribution(dots: [])
            completion(self.contributions, nil)
        }
    }
}
