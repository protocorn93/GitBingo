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
        homeViewModel.buttonTitle.onNext(id.value)
        contributionsDotsRepository.fetch(id.value)
    }
    
    private func bind() {
        bindIDTextField()
    }
    
    private func bindIDTextField() {
        inputText.bind(to: id).disposed(by: disposeBag)
        inputText.map { !$0.isEmpty }.bind(to: doneButtonValidation).disposed(by: disposeBag)
    }
}
