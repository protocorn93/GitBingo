//
//  APIService.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import Kanna

struct APIService {
    //MARK: Properties
    static let shared = APIService()
    private let session = URLSession(configuration: .default)
    private init() {}
    
    //MARK: Methods
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) -> ()) {
        guard let url = URL(string: "https://github.com/users/\(id)/contributions") else {
            completion(nil, GitBingoError.pageNotFound)
            return
        }
        let task = self.session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, GitBingoError.networkError)
                return
            }
            
            guard let data = data, let rawHtml = String(data: data, encoding: .utf8) else { return }
            
            do {
                let dayElements = try self.parseHTML(from: rawHtml)
                
                var dots: [Dot] = []
                
                if let dayElements = dayElements {
                    dayElements.forEach { (day) in
                        guard let date = day["data-date"] else { return }
                        guard let color = day["fill"] else { return }
                        let dot = Dot(date: date, color: color)
                        dots.append(dot)
                    }
                    completion(Contribution(dots: dots), nil)
                }
            } catch let err as GitBingoError {
                completion(nil, err)
            } catch {
                completion(nil, GitBingoError.networkError)
            }
        }
        
        task.resume()
    }
    
    fileprivate func parseHTML(from rawHTML: String) throws -> XPathObject? {
        guard let doc = try? HTML(html: rawHTML, encoding: .utf8) else { return nil}
        
        if doc.body?.content == "Not Found" {
            throw GitBingoError.pageNotFound
        }
        
        return doc.css("g > .day")
    }
    
}
