//
//  Contributions.swift
//  Gitergy
//
//  Created by 이동건 on 24/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

class Contribution {
    var dots: [Dot]
    
    var count: Int {
        return dots.count
    }
    
    var colors: [UIColor?] {
        let colors: [UIColor?] = dots.map {$0.grade?.color}
        
        return colors.reversed()
    }
    
    init(dots:[Dot]) {
        var dots = dots
        
        var thisWeekContributions: [Dot] = []
        let thisWeekContributedDate = dots.count % 7
        let notYetDot = 7 - thisWeekContributedDate
        
        for _ in 0..<thisWeekContributedDate {
            thisWeekContributions.append(dots.removeLast())
        }
        
        for _ in (0..<notYetDot) {
            dots.append(Dot())
        }
        
        for _ in 0..<thisWeekContributedDate {
            dots.append(thisWeekContributions.removeFirst())
        }
        
        self.dots = dots
    }
}
