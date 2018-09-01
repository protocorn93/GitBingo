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
    private var vc: GithubDotsRequestProtocol?
    private var contribution: Contribution?
    
    var dotsCount: Int {
        return contribution?.count ?? 0
    }
    
    func attachView(_ vc: GithubDotsRequestProtocol) {
        self.vc = vc
    }
    
    func detatchView() {
        self.vc = nil
    }
    
    func refresh(mode: RefreshMode) {
        guard let id = UserDefaults.standard.value(forKey: "id") as? String else { return }
        
        switch mode {
        case .pullToRefresh:
            vc?.showProgressStatus(mode: .pullToRefresh)
        case .tapToRefresh:
            vc?.showProgressStatus(mode: .tapToRefresh)
        }
        
        fetchDots(from: id)
    }
    
    func requestDots() {
        guard let id = UserDefaults.standard.value(forKey: "id") as? String else {
            self.vc?.setUpGithubInputAlertButton("Hello, Who are you?")
            return
        }
        
        vc?.showProgressStatus(mode: nil)
        fetchDots(from: id)
    }
    
    private func fetchDots(from id: String) {
        APIService.shared.fetchContributionDots(of: id) { (contributions, err) in
            if let err = err {
                self.vc?.showFailProgressStatus(with: err)
                UserDefaults.standard.removeObject(forKey: "id")
                return
            }
            
            // Success case
            self.contribution = contributions
            self.vc?.showSuccessProgressStatus()
            self.vc?.setUpGithubInputAlertButton("Welcome, \(id)")
        }
    }
    
    func color(of indexPath: IndexPath) -> UIColor? {
        return contribution?.colors[indexPath.item]
    }
}
