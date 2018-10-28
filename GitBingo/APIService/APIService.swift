//
//  APIService.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import Kanna

protocol APIServiceProtocol: class {
    init(parser: HTMLParsingProtocol)
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) ->())
}

protocol HTMLParsingProtocol: class {
    func parse(from data: Data?) -> Contribution?
}

class Parser: HTMLParsingProtocol {
    func parse(from data: Data?) -> Contribution? {
        guard let data = data, let rawHTML = String(data: data, encoding: .utf8) else { return nil }
        guard let doc = try? HTML(html: rawHTML, encoding: .utf8) else { return nil }
        if doc.body?.content == "Not Found" { return nil }
        
        let dayElements = doc.css("g > .day")
        
        var dots: [Dot] = []
        
        dayElements.forEach { (day) in
            guard let date = day["data-date"] else { return }
            guard let color = day["fill"] else { return }
            guard let dataCount = day["data-count"], let count = Int(dataCount) else { return }
            let dot = Dot(date: date, color: color, count: count)
            dots.append(dot)
        }
        dots.last?.isToday = true
        return Contribution(dots: dots)
    }
}

class APIService: APIServiceProtocol {
    //MARK: Properties
    private let session = URLSession(configuration: .default)
    private let parser: HTMLParsingProtocol
    
    required init(parser: HTMLParsingProtocol) {
        self.parser = parser
    }
    
    //MARK: Methods
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) -> ()) {
        if id.isEmpty {
            completion(nil, .idIsEmpty)
            return
        }
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
