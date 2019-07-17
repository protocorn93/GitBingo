//
//  IDInputViewModel.swift
//  GitBingo
//
//  Created by 이동건 on 29/06/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum ResponseStatus {
    case success
    case failed(Error)
}

protocol IDInputViewModelType {
    var inputText: BehaviorSubject<String> { get }
    var isLoading: PublishSubject<Bool> { get }
    var responseStatus: PublishSubject<ResponseStatus> { get }
    var doneButtonValidation: BehaviorSubject<Bool> { get }
    func fetch()
}

class IDInputViewModel: IDInputViewModelType {
    var inputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var responseStatus: PublishSubject<ResponseStatus> = PublishSubject()
    var doneButtonValidation: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private var homeViewModel: HomeViewModelType
    private var contributionsDotsRepository: ContributionDotsRepository
    private var id: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var disposeBag = DisposeBag()
    
    init(contributionsDotsRepository: ContributionDotsRepository, homeViewModel: HomeViewModelType) {
        self.homeViewModel = homeViewModel
        self.contributionsDotsRepository = contributionsDotsRepository
        bind()
    }
    
    func fetch() {
        isLoading.onNext(true)
        let input = id.value
        contributionsDotsRepository
            .fetch(input)
            .map(mapping)
            .subscribe(onNext: { sectionModels in
                self.isLoading.onNext(false)
                self.responseStatus.onNext(.success)
                self.homeViewModel.sectionModels.onNext(sectionModels)
            }, onError: { error in
                self.isLoading.onNext(false)
                self.responseStatus.onNext(.failed(error))
            })
            .disposed(by: disposeBag)
    }
   
    private func mapping(from contributions: Contributions) -> [SectionModel<String, ContributionGrade>] {
        return [SectionModel<String, ContributionGrade>(model: "This Week", items: contributions.grades.prefix(7).map { $0 }),
                SectionModel<String, ContributionGrade>(model: "Last Weeks", items: contributions.grades.suffix(from: 7).map { $0 })]
    }
    
    private func bind() {
        bindIDTextField()
    }
    
    private func bindIDTextField() {
        inputText.bind(to: id).disposed(by: disposeBag)
        inputText.map { !$0.isEmpty }.bind(to: doneButtonValidation).disposed(by: disposeBag)
    }
}
