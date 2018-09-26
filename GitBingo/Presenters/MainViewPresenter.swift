//
//  MainViewPresenter.swift
//  Gitergy
//
//  Created by 이동건 on 31/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

protocol GithubDotsRequestProtocol: class {
    func showProgressStatus(mode: RefreshMode?)
    func showSuccessProgressStatus()
    func showFailProgressStatus(with error: GitBingoError)
    func setUpGithubInputAlertButton(_ title: String)
}

class MainViewPresenter {
    //MARK: Properties
    private weak var vc: GithubDotsRequestProtocol?
    private var contribution: Contribution?
    var dotsCount: Int {
        return contribution?.count ?? 0
    }
    
    //MARK: Life Cycle
    init() {}
    
    //MARK: Methods
    func attachView(_ vc: GithubDotsRequestProtocol) {
        self.vc = vc
    }
    
    func detatchView() {
        self.vc = nil
    }
    
    func refresh(mode: RefreshMode) {
        guard let id = UserDefaults.standard.value(forKey: KeyIdentifier.id.value) as? String else { return }
        
        switch mode {
        case .pullToRefresh:
            vc?.showProgressStatus(mode: .pullToRefresh)
        case .tapToRefresh:
            vc?.showProgressStatus(mode: .tapToRefresh)
        }
        
        fetchDots(from: id)
    }
    
    func showError(with error: GitBingoError) {
        vc?.showFailProgressStatus(with: error)
    }
    
    func requestDots(from id: String) throws {
        if id.count == 0 {
            throw GitBingoError.idIsEmpty
        }
        vc?.showProgressStatus(mode: nil)
        fetchDots(from: id)
    }
    
    func requestDots() {
        guard let id = UserDefaults.standard.value(forKey: KeyIdentifier.id.value) as? String else {
            self.vc?.setUpGithubInputAlertButton("Hello, Who are you?")
            return
        }
        
        vc?.showProgressStatus(mode: nil)
        fetchDots(from: id)
    }
    
    func color(at item: Int) -> UIColor? {
        return contribution?.colors[item]
    }
    
    private func fetchDots(from id: String) {
        DispatchQueue.global().async {
            APIService.shared.fetchContributionDots(of: id) { (contributions, err) in
                if let err = err {
                    DispatchQueue.main.async {
                        self.vc?.showFailProgressStatus(with: err)
                    }
                    return
                }
                
                // Success case
                DispatchQueue.main.async {
                    self.contribution = contributions
                    self.vc?.showSuccessProgressStatus()
                    self.vc?.setUpGithubInputAlertButton("Welcome! \(id)👋")
                }
                UserDefaults.standard.set(id, forKey: KeyIdentifier.id.value)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(contributions), forKey: KeyIdentifier.contributions.value)
            }
        }
    }
}
