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

class IDInputViewModel<M: ContributionsMapper>: IDInputViewModelType where M.Source == Contributions, M.Target == SectionModel<String, ContributionGrade> {
    var inputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var responseStatus: PublishSubject<ResponseStatus> = PublishSubject()
    var doneButtonValidation: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private var contributionsDotsRepository: ContributionDotsRepository
    private var receiver: Receiver
    private var mapper: M
    private var id: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var disposeBag = DisposeBag()
    
    init(contributionsDotsRepository: ContributionDotsRepository, receiver: Receiver, mapper: M) {
        self.contributionsDotsRepository = contributionsDotsRepository
        self.receiver = receiver
        self.mapper = mapper
        bind()
    }
    
    func fetch() {
        isLoading.onNext(true)
        let input = id.value
        contributionsDotsRepository
            .fetch(input)
            .map { self.mapper.mapping(from: $0)}
            .subscribe(onNext: { sectionModels in
                self.isLoading.onNext(false)
                self.responseStatus.onNext(.success)
                self.receiver.githubID.onNext(input)
                self.receiver.sectionModels.onNext(sectionModels)
            }, onError: { error in
                self.isLoading.onNext(false)
                self.responseStatus.onNext(.failed(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        bindIDTextField()
    }
    
    private func bindIDTextField() {
        inputText.bind(to: id).disposed(by: disposeBag)
        inputText.map { !$0.isEmpty }.bind(to: doneButtonValidation).disposed(by: disposeBag)
    }
}
