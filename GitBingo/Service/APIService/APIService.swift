//
//  APIService.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol APIServiceProtocol: class {
    func fetchContributionDots(of id: String, completion: @escaping (Contributions?, GitBingoError?) -> Void)
}

protocol ContributionDotsRepository {
    func fetch(_ id: String) -> Observable<Contributions>
}

class GitBingoContributionDotsRepository: ContributionDotsRepository {
    private let session: SessionManagerProtocol
    private let parser: HTMLParsingProtocol
    
    init(parser: HTMLParsingProtocol, session: SessionManagerProtocol) {
        self.parser = parser
        self.session = session
    }
    
    func fetch(_ id: String) -> Observable<Contributions> {
        let url = URL(string: "https://github.com/users/\(id)/contributions")!
        return URLSession.shared.rx.response(request: URLRequest(url: url)).map { response, data in
            print(response.statusCode)
            if 200..<300 ~= response.statusCode {
                guard let contributions = self.parser.parse(from: data) else { throw GitBingoError.pageNotFound }
                return contributions
            }
            throw GitBingoError.pageNotFound
        }
    }
}

class APIService: APIServiceProtocol {
    // MARK: Properties
    private let session: SessionManagerProtocol
    private let parser: HTMLParsingProtocol

    init(parser: HTMLParsingProtocol, session: SessionManagerProtocol) {
        self.parser = parser
        self.session = session
    }

    // MARK: Methods
    func fetchContributionDots(of id: String, completion: @escaping (Contributions?, GitBingoError?) -> Void) {
        guard let url = URL(string: "https://github.com/users/\(id)/contributions") else {
            completion(nil, .pageNotFound)
            return
        }
        let task = self.session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                completion(nil, .networkError)
                return
            }

            if let contributions = self.parser.parse(from: data) {
                completion(contributions, nil)
            } else {
                completion(nil, .pageNotFound)
            }
        }

        task.resume()
    }
}
