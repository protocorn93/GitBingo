//
//  HomeViewModel.swift
//  GitBingo
//
//  Created by 이동건 on 26/06/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

protocol HomeViewModelType {
    var buttonTitle: Observable<String> { get }
    var sections: Observable<[SectionModel<String, ContributionGrade>]> { get }
}

class HomeViewModel: HomeViewModelType {
    private var receiver: Receiver
    var buttonTitle: Observable<String> { return receiver.githubID.asObservable() }
    var sections: Observable<[SectionModel<String, ContributionGrade>]> { return receiver.sectionModels.asObservable() }
    
    init(receiver: Receiver) {
        self.receiver = receiver
    }
}
