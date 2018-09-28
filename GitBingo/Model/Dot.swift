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
    private (set) var count: Int?
    var isToday: Bool = false
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
    
    init(date: String, color: String, count: Int) {
        self.date = date
        self.rawColor = color
        self.count = count
    }
}
