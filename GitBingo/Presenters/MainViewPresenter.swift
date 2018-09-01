//
//  MainViewPresenter.swift
//  Gitergy
//
//  Created by 이동건 on 31/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

protocol GithubDotsRequestProtocol: class {
    func showProgressStatus()
    func showSuccessProgressStatus(with id: String)
    func showFailProgressStatus(with error: GitBingoError)
    func updateDots()
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
    
    func requestDots(of id: String) {
        vc?.showProgressStatus()
        APIService.shared.fetchContributionDots(of: id) { (contributions, err) in
            if let err = err {
                self.vc?.showFailProgressStatus(with: err)
                return
            }
            
            self.contribution = contributions
            self.vc?.updateDots()
            self.vc?.showSuccessProgressStatus(with: id)
        }
    }
    
    func color(of indexPath: IndexPath) -> UIColor? {
        return contribution?.colors[indexPath.item]
    }
}
