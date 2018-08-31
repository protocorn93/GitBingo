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
    func dismissProgressStatus()
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
    
    func requestDots() {
        vc?.showProgressStatus()
        APIService.shared.fetchContributionDots { (contributions) in
            self.contribution = contributions
            self.vc?.updateDots()
            self.vc?.dismissProgressStatus()
        }
    }
    
    func color(of indexPath: IndexPath) -> UIColor? {
        return contribution?.colors[indexPath.item]
    }
}
