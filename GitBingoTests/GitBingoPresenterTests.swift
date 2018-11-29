//
//  GitBingoPresenterTests.swift
//  GitBingoTests
//
//  Created by 이동건 on 29/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import XCTest

class GitBingoPresenterTests: XCTestCase {
    private var session: SessionManagerStub!
    private var apiService: APIServiceStub!
    private var mainView: MainViewStub!
    private var presenter: MainViewPresenter!
    
    func testPresenterAction_with_InvalidID() {
        givenASession()
        givenAAPIService()
        givenAMainView()
        givenAPresenter()
        
        whenPresenterRequest(with: "ㅋㅋㅋ")
        
        thenMainViewShowProgressStatus()
        thenMainViewShowFailProgress(with: .pageNotFound)
    }
    
    func testPresenterAction_with_ValidID() {
        givenASession()
        givenAAPIService()
        givenAMainView()
        givenAPresenter()
        
        whenPresenterRequest(with: "ehdrjsdlzzzz")
        
        thenMainViewShowProgressStatus()
        thenMainViewShowSuccessProgressStatus()
    }
    
    func testPresenterAction_with_NetworkError() {
        givenASession(with: .networkError)
        givenAAPIService()
        givenAMainView()
        givenAPresenter()
        
        whenPresenterRequest(with: "ehdrjsdlzzzz")
        
        thenMainViewShowProgressStatus()
        thenMainViewShowFailProgress(with: .networkError)
    }
    
    private func givenASession(with error: GitBingoError? = nil) {
        session = SessionManagerStub(error)
    }
    
    private func givenAAPIService() {
        apiService = APIServiceStub(session)
    }
    
    private func givenAMainView() {
        mainView = MainViewStub()
    }
    
    private func givenAPresenter() {
        presenter = MainViewPresenter(service: apiService)
        presenter.attachView(mainView)
    }
    
    private func whenPresenterRequest(with id: String) {
        presenter.request(from: id)
    }
    
    private func thenMainViewShowProgressStatus() {
        XCTAssertTrue(mainView.showProgressStatusDidCalled)
    }
    
    private func thenMainViewShowFailProgress(with error: GitBingoError) {
        XCTAssertNotNil(mainView.error)
        XCTAssertEqual(mainView.error!, error)
        XCTAssertTrue(mainView.showFailProgressStatusDidCalled)
    }
    
    private func thenMainViewShowSuccessProgressStatus() {
        XCTAssertNil(mainView.error)
        XCTAssertTrue(mainView.showSuccessProggressStatusDidCalled)
    }
}
