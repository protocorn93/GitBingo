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
    static let shared = APIService()
    private init() {}
    
    func fetchContributionDots(completion: @escaping (Contribution) -> ()) {
        let user = "ehdrjsdlzzzz"
        let url = "https://github.com/users/\(user)/contributions"
        
        DispatchQueue.global().async {
            Alamofire.request(url).responseString { (response) in
                
                guard let dayElements = self.parseHTML(from: response) else { return }
                
                var dots:[Dot] = []
                
                dayElements.forEach { (day) in
                    guard let date = day["data-date"] else { return }
                    guard let color = day["fill"] else { return }
                    let dot = Dot(date: date, color: color)
                    dots.append(dot)
                }
                
                DispatchQueue.main.async {
                    completion(Contribution(dots: dots))
                }
            }
        }
    }
    
    fileprivate func parseHTML(from response: DataResponse<String>) -> XPathObject? {
        guard let html = response.result.value else { return nil }
        guard let doc = try? HTML(html: html, encoding: .utf8) else { return nil}
        
//        guard let contributionsInLastYearElement = doc.at_css("body > div > div > h2") else { return nil }
//        guard let contributionsInLastYear = contributionsInLastYearElement.content else { return nil }
        
//        print(contributionsInLastYear)
        
        return doc.css(".day")
    }
}
