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
    private var contributions: Contribution?
    private var id: String? {
        return GroupUserDefaults.shared.load(of: .id) as? String
    }
    private var greeting: String {
        guard let id = self.id else { return "Hello, Who are you?" }
        return "Welcome! \(id)👋"
    }
    var dotsCount: Int {
        return contributions?.count ?? 0
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
        guard let id = self.id else { return }
        requestDots(from: id, mode: mode)
    }
    
    func requestDots(from id: String, mode: RefreshMode? = nil) {
        vc?.showProgressStatus(mode: mode)
        fetchDots(from: id)
    }
    
    func requestDots() {
        guard let id = self.id else {
            self.vc?.setUpGithubInputAlertButton(greeting)
            return
        }
        requestDots(from: id)
    }
    
    func color(at item: Int) -> UIColor? {
        return contributions?.colors[item]
    }
    
    private func fetchDots(from id: String) {
        DispatchQueue.global().async {
            APIService.shared.fetchContributionDots(of: id) { (contributions, err) in
                if let err = err {
                    DispatchQueue.main.async { [weak self] in
                        self?.vc?.showFailProgressStatus(with: err)
                    }
                    return
                }
                
                // Success case
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.contributions = contributions
                    self.vc?.showSuccessProgressStatus()
                    self.vc?.setUpGithubInputAlertButton(self.greeting)
                }
                GroupUserDefaults.shared.save(id, of: .id)
            }
        }
    }
}
