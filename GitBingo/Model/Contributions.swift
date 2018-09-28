//
//  Contributions.swift
//  Gitergy
//
//  Created by 이동건 on 24/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

class Contribution: Codable {
    //MARK: Properties
    var dots: [Dot]
    var count: Int {
        return dots.count
    }
    var colors: [UIColor?] {
        let colors: [UIColor?] = dots.map {$0.grade?.color}
        
        return colors
    }
    var total: Int {
        var total: Int = 0
        dots.forEach {
            total += $0.count ?? 0
        }
        return total
    }
    var today: Int {
        let today = dots.filter {$0.isToday == true}
        return today.count
    }
    
    //MARK: Life Cycle
    init(dots:[Dot]) {
        var dots = dots
        
        let thisWeekContributedDate = dots.count % 7
        let notYetDot = 7 - thisWeekContributedDate
        
        if notYetDot != 7 {
            for _ in (0..<notYetDot) {
                dots.append(Dot())
            }
        }
        
        var groupedDots: [[Dot]] = []
        var week: [Dot] = []
        
        for (index, dot) in dots.enumerated() {
            week.append(dot)
            if (index + 1) % 7 == 0 {
                groupedDots.append(week)
                week.removeAll()
            }
        }
        
        groupedDots = groupedDots.reversed()
        
        self.dots = groupedDots.flatMap {$0}
    }
}
