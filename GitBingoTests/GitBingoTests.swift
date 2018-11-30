//
//  GitBingoTests.swift
//  GitBingoTests
//
//  Created by 이동건 on 17/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import XCTest

class GitBingoTests: XCTestCase {
    private var session: SessionManagerStub!
    private var apiService: APIServiceStub!

    func testApiService_with_InvalidID() {
        givenASession()
        givenAAPIService()

        whenAPIServiceFetch(with: "ㅋㅋ")

        thenFailed(with: .pageNotFound)
    }

    func testApiService_with_validID() {
        givenASession()
        givenAAPIService()

        whenAPIServiceFetch(with: "ehdrjsdlzzzz")

        thenSuccess()
    }

    func testApiService_with_networkError() {
        givenASession(with: .networkError)
        givenAAPIService()

        whenAPIServiceFetch(with: "ehdrjsdlzzzz")

        thenFailed(with: .networkError)
    }

    private func givenASession(with error: GitBingoError? = nil) {
        session = SessionManagerStub(error)
    }

    private func givenAAPIService() {
        apiService = APIServiceStub(session)
    }

    private func whenAPIServiceFetch(with id: String) {
        apiService.fetchContributionDots(of: id) { (_, _) in }
    }

    private func thenFailed(with error: GitBingoError) {
        XCTAssertNotNil(apiService.error)
        XCTAssertNil(apiService.contributions)
        XCTAssertEqual(apiService.error!, error)
    }

    private func thenSuccess() {
        XCTAssertNil(apiService.error)
        XCTAssertNotNil(apiService.contributions)
    }
}
