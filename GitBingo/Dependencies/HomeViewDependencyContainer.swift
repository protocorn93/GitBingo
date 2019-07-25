//
//  HomeViewDependencyContainer.swift
//  GitBingo
//
//  Created by 이동건 on 18/07/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import Foundation
import RxSwift

class GitbingoAppDependencyContainer {
    private let userProfileStorage: GitbingoStorage
    
    init(_ suiteName: String) {
        self.userProfileStorage = UserProfileStorage(suiteName)
    }
    
    private func generateReceiver() -> Receiver {
        return ContributionReceiver()
    }
    
    func generateHomeViewController() -> HomeViewController? {
        return HomeViewController.instantiate(with: generateHomeViewDependencyContainer())
    }
    
    func generateHomeViewDependencyContainer() -> HomeViewDependencyContainer {
        return HomeViewDependencyContainer(receiver: generateReceiver(), userProfileStorage)
    }
}

class HomeViewDependencyContainer {
    private let receiver: Receiver
    private let storage: GitbingoStorage
    private let disposeBag = DisposeBag()
    
    init(receiver: Receiver, _ storage: GitbingoStorage) {
        self.receiver = receiver
        self.storage = storage
        bind()
    }
    
    private func bind() {
        receiver.githubID.skip(1).subscribe(onNext: { [weak self] in self?.storage.save($0, of: .id) }).disposed(by: disposeBag)
    }
    
    func generateHomeViewModel() -> HomeViewModelType {
        return HomeViewModel(receiver: receiver)
    }
    
    func generateIDInputViewModel() -> IDInputViewModelType {
        return IDInputViewModel(contributionsDotsRepository: generateContributionDotsRepository(), receiver: receiver)
    }
    
    private func generateContributionDotsRepository() -> ContributionDotsRepository {
        return GitBingoContributionDotsRepository(parser: Parser(), session: URLSession(configuration: .default))
    }
}
