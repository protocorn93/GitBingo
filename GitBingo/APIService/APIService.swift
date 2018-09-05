//
//  APIService.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import SVProgressHUD

struct APIService {
    //MARK: Properties
    static let shared = APIService()
    private init() {}
    
    //MARK: Methods
    func fetchContributionDots(of id: String, completion: @escaping (Contribution?, GitBingoError?) -> ()) {
        let url = "https://github.com/users/\(id)/contributions"
        
        DispatchQueue.global().async {
            Alamofire.request(url).responseString { (response) in
                
                switch response.result {
                case .success:
                    do {
                        let dayElements = try self.parseHTML(from: response)
                        
                        var dots:[Dot] = []
                        
                        if let dayElements = dayElements {
                            dayElements.forEach { (day) in
                                guard let date = day["data-date"] else { return }
                                guard let color = day["fill"] else { return }
                                let dot = Dot(date: date, color: color)
                                dots.append(dot)
                            }
                            
                            DispatchQueue.main.async {
                                completion(Contribution(dots: dots), nil)
                            }
                        }
                    } catch let err as GitBingoError {
                        completion(nil, err)
                    } catch {
                        completion(nil, GitBingoError.networkError)
                    }
                case .failure:
                    completion(nil, GitBingoError.pageNotFound)
                }
            }
        }
    }
    
    fileprivate func parseHTML(from response: DataResponse<String>) throws -> XPathObject? {
        guard let html = response.result.value else { return nil }
        guard let doc = try? HTML(html: html, encoding: .utf8) else { return nil}
        
        if doc.body?.content == "Not Found" {
            throw GitBingoError.pageNotFound
        }
        
        return doc.css("g > .day")
    }
}
