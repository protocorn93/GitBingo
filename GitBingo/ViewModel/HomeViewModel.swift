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
    var buttonTitle: BehaviorSubject<String> { get }
    var sectionModels: PublishSubject<[SectionModel<String, ContributionGrade>]> { get }
}

class HomeViewModel: HomeViewModelType {
    private (set) var sectionModels: PublishSubject<[SectionModel<String, ContributionGrade>]> = PublishSubject()
    private (set) var buttonTitle: BehaviorSubject<String> = BehaviorSubject(value: "아이디를 입력해주세요.")
    private var disposeBag = DisposeBag()
    
    init() { }
}
