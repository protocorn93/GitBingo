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

struct HomeViewModel {
    private var parser: HTMLParsingProtocol
    private var session: SessionManagerProtocol
    
    private (set) var sectionModels: PublishSubject<[SectionModel<String, ContributionGrade>]> = PublishSubject()
    private (set) var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private var contributionsDotsRepository: ContributionDotsRepository
    private var disposeBag = DisposeBag()
    
    init(parser: HTMLParsingProtocol, session: SessionManagerProtocol) {
        self.parser = parser
        self.session = session
        self.contributionsDotsRepository = GitBingoContributionDotsRepository(parser: parser, session: session)
        
        bindSectionModels()
    }
    
    func fetch(id: String) {
        isLoading.onNext(true)
        contributionsDotsRepository.fetch(id)
    }
    
    private func bindSectionModels() {
        contributionsDotsRepository.contributions
            .map { [SectionModel<String, ContributionGrade>(model: "This Week", items: $0.grades.prefix(7).map { $0 }),
                    SectionModel<String, ContributionGrade>(model: "Last Weeks", items: $0.grades.suffix(from: 7).map { $0 })] }
            .subscribe(onNext: {
                self.sectionModels.onNext($0)
                self.isLoading.onNext(false)
            }, onError: {
                self.isLoading.onError($0)
            })
            .disposed(by: disposeBag)
    }
}
