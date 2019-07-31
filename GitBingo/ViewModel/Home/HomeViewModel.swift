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
import RxCocoa

typealias ContributionsSectionModel = [SectionModel<String, ContributionGrade>]

protocol HomeViewModelType {
    var title: Driver<String> { get }
    var sections: Driver<ContributionsSectionModel> { get }
}

class HomeViewModel: HomeViewModelType {
    private var receiver: Receiver
    var title: Driver<String> { return receiver.githubID.asDriver(onErrorJustReturn: "") } 
    var sections: Driver<ContributionsSectionModel> { return receiver.sectionModels.asDriver(onErrorJustReturn: [])}
    
    init(receiver: Receiver) {
        self.receiver = receiver
    }
}
