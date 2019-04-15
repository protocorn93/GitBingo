//
//  TodayViewPresenter.swift
//  GitBingo Widget
//
//  Created by 이동건 on 02/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol GitBingoWidgetProtocol: class {
    func startLoad()
    func endLoad()
    func hide(error: GitBingoError?)
    func initUI(with contributions: Contributions?, at time: String)
    func open(_ url: URL)
}

class TodayViewPresenter {
    // MARK: Properties
    private weak var vc: GitBingoWidgetProtocol?
    private var contributions: Contributions?
    private var service: APIServiceProtocol?

    // MARK: Life Cycle
    init(service: APIServiceProtocol) {
        self.service = service
    }

    func attachView(_ vc: GitBingoWidgetProtocol) {
        self.vc = vc
    }

    func detachView() {
        self.vc = nil
    }

    func colors(at indexPath: IndexPath) -> UIColor? {
        return contributions?.colors[indexPath.item]
    }

    func load() {
        guard let id = GroupUserDefaults.shared.load(of: .id) as? String else {
            vc?.hide(error: .idIsEmpty)
            return
        }

        if let reserverdNotificaitonTime = GroupUserDefaults.shared.load(of: .notification) as? String {
            fetch(of: id, at: reserverdNotificaitonTime)
            return
        }

        fetch(of: id, at: "➕")
    }

    func handleUserInteraction(type: AppURL) {
        guard let url = URL(string: "GitBingoHost://\(type.path)") else { return }
        vc?.open(url)
    }

    private func fetch(of id: String, at time: String) {
        vc?.startLoad()
        fetchContributions(of: id) { [weak self] (err) in
            if let err = err {
                self?.vc?.hide(error: err)
                self?.vc?.endLoad()
                return
            }
            self?.vc?.hide(error: nil)
            self?.vc?.initUI(with: self?.contributions, at: time)
            self?.vc?.endLoad()
        }
    }

    private func fetchContributions(of id: String, completion: @escaping (_ error: GitBingoError?) -> Void ) {
        service?.fetchContributionDots(of: id) { [weak self] (contributions, err) in
            if let err = err {
                completion(err)
                return
            }

            DispatchQueue.main.async {
                guard let dots = contributions?.dots else { return }
                let thisWeekContributions = Contributions(dots: dots.prefix(7).map {$0})
                self?.contributions = thisWeekContributions
                completion(nil)
            }
        }
    }
}
