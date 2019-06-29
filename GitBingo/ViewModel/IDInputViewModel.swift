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

protocol IDInputViewModelType {
    var inputText: BehaviorSubject<String> { get }
    var isLoading: PublishSubject<Bool> { get }
    var doneButtonValidation: BehaviorSubject<Bool> { get }
    func fetch()
}

class IDInputViewModel: IDInputViewModelType {
    
    var inputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    var isLoading: PublishSubject<Bool> = PublishSubject()
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
        homeViewModel.buttonTitle.onNext(id.value)
        contributionsDotsRepository.fetch(id.value)
    }
    
    private func bind() {
        bindIDTextField()
        bindSectionModels()
    }
    
    private func bindIDTextField() {
        inputText.bind(to: id).disposed(by: disposeBag)
        inputText.map { !$0.isEmpty }.bind(to: doneButtonValidation).disposed(by: disposeBag)
    }
    
    private func bindSectionModels() {
        contributionsDotsRepository.contributions
            .map { [SectionModel<String, ContributionGrade>(model: "This Week", items: $0.grades.prefix(7).map { $0 }),
                    SectionModel<String, ContributionGrade>(model: "Last Weeks", items: $0.grades.suffix(from: 7).map { $0 })] }
            .subscribe(onNext: {
                self.homeViewModel.sectionModels.onNext($0)
                self.isLoading.onNext(false)
            }, onError: {
                self.isLoading.onError($0)
            })
            .disposed(by: disposeBag)
    }
}
