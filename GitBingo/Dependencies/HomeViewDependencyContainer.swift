//
//  HomeViewDependencyContainer.swift
//  GitBingo
//
//  Created by 이동건 on 18/07/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import Foundation

class HomeViewDependencyContainer {
    private let receiver: Receiver = ContributionReceiver()
    
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
