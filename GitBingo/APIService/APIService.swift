//
//  APIService.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

protocol APIServiceProtocol: class {
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) ->())
}

class APIService: APIServiceProtocol {
    //MARK: Properties
    private let session = URLSession(configuration: .default)
    private let parser: HTMLParsingProtocol
    
    init(parser: HTMLParsingProtocol) {
        self.parser = parser
    }
    
    //MARK: Methods
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) -> ()) {
        guard let url = URL(string: "https://github.com/users/\(id)/contributions") else {
            completion(nil, .pageNotFound)
            return
        }
        let task = self.session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, .networkError)
                return
            }
            
            if let contribution = self.parser.parse(from: data) {
                completion(contribution, nil)
            }else {
                completion(nil, .pageNotFound)
            }
        }
        
        task.resume()
    }
}
