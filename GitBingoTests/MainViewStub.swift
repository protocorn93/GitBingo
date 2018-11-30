//
//  MainViewStub.swift
//  GitBingoTests
//
//  Created by 이동건 on 29/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

class MainViewStub: DotsUpdateableDelegate {
    var showProgressStatusDidCalled: Bool = false
    var showSuccessProggressStatusDidCalled: Bool = false
    var showFailProgressStatusDidCalled: Bool = false
    var setUpGithubInputAlertButtonDidCalled: Bool = false

    var error: GitBingoError?

    func showProgressStatus(mode: RefreshMode?) {
        showProgressStatusDidCalled = true
    }

    func showSuccessProgressStatus() {
        showSuccessProggressStatusDidCalled = true
    }

    func showFailProgressStatus(with error: GitBingoError) {
        self.error = error
        showFailProgressStatusDidCalled = true
    }

    func setUpGithubInputAlertButton(_ title: String) {
        setUpGithubInputAlertButtonDidCalled = true
    }
}
