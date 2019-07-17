//
//  SectionModelsReceiver.swift
//  GitBingo
//
//  Created by 이동건 on 18/07/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import RxSwift
import RxDataSources

protocol SectionModelsReceiver {
    var sectionModels: PublishSubject<[SectionModel<String, ContributionGrade>]> { get }
}
