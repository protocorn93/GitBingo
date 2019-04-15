//
//  MainViewPresenter.swift
//  Gitergy
//
//  Created by 이동건 on 31/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

protocol DotsUpdateableDelegate: class {
    func showProgressStatus(mode: RefreshMode?)
    func showSuccessProgressStatus()
    func showFailProgressStatus(with error: GitBingoError)
    func setUpGithubInputAlertButton(_ title: String)
}

class MainViewPresenter {
    // MARK: Properties
    private weak var vc: DotsUpdateableDelegate?
    private var contributions: Contributions?
    private var service: APIServiceProtocol
    var dotsCount: Int {
        return contributions?.count ?? 0
    }
    private var id: String? {
        return GroupUserDefaults.shared.load(of: .id) as? String
    }
    private var greeting: String {
        guard let id = self.id else { return "Hello, Who are you?" }
        return "Welcome! \(id)👋"
    }

    // MARK: Life Cycle
    init(service: APIServiceProtocol) {
        self.service = service
    }

    func attachView(_ vc: DotsUpdateableDelegate) {
        self.vc = vc
    }

    func detatchView() {
        self.vc = nil
    }

    func refresh(mode: RefreshMode) {
        guard let id = self.id else { return }
        request(from: id, mode: mode)
    }

    func request(from id: String? = nil, mode: RefreshMode? = nil) {
        if let id = id ?? self.id {
            self.vc?.showProgressStatus(mode: mode)
            service.fetchContributionDots(of: id) { (contributions, err) in
                if let err = err {
                    self.vc?.showFailProgressStatus(with: err)
                    return
                }

                self.contributions = contributions
                self.vc?.showSuccessProgressStatus()
                self.vc?.setUpGithubInputAlertButton(self.greeting)

                GroupUserDefaults.shared.save(id, of: .id)
            }
            return
        }
        vc?.setUpGithubInputAlertButton(greeting)
    }

    func color(at item: Int) -> UIColor? {
        return contributions?.colors[item]
    }
}
