//
//  Dot.swift
//  Gitergy
//
//  Created by 이동건 on 24/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

class Dot: Codable {
    //MARK: Properties
    private var date: String?
    private var rawColor: String?
    var grade: ContributionGrade? {
        guard let color = rawColor else { return .notYet }
        
        return ContributionGrade(rawValue: color)
    }
    var dateForOrder: Date? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        if let date = formatter.date(from: date) {
            return date
        }
        
        return nil 
    }
    
    //MARK: Life Cycle
    init(){}
    
    init(date: String, color: String) {
        self.date = date
        self.rawColor = color
    }
}
