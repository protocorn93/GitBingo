//
//  ContributionsMapper.swift
//  GitBingo
//
//  Created by 이동건 on 29/07/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import Foundation
import RxDataSources

protocol ContributionsMapper: class {
    associatedtype Source
    associatedtype Target
    
    init()
    func mapping(from contributions: Source) -> [Target]
}

class ContributionsSectionModelMapper: ContributionsMapper {
    required init() { }
    func mapping(from contributions: Contributions) -> [SectionModel<String, ContributionGrade>] {
        return [SectionModel<String, ContributionGrade>(model: "This Week", items: contributions.grades.prefix(7).map { $0 }),
                SectionModel<String, ContributionGrade>(model: "Last Weeks", items: contributions.grades.suffix(from: 7).map { $0 })]
    }
}
