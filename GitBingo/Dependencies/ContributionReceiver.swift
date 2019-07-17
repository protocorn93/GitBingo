//
//  ContributionReceiver.swift
//  GitBingo
//
//  Created by 이동건 on 18/07/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import RxSwift
import RxDataSources

typealias Receiver = GithubIdReceiver & SectionModelsReceiver

class ContributionReceiver: Receiver {
    var githubID: BehaviorSubject<String> = BehaviorSubject(value: "아이디를 입력해주세요.")
    var sectionModels: PublishSubject<[SectionModel<String, ContributionGrade>]> = PublishSubject()
}
