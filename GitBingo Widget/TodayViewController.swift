//
//  TodayViewController.swift
//  GitBingo Widget
//
//  Created by 이동건 on 26/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: Outlets
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!

    // To Be Hidden
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var widgetCollectionView: UICollectionView!

    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var githubRegisterButton: UIButton!
    @IBOutlet weak var todayCommitLabel: UILabel!
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel! {
        didSet {
            notificationTimeLabel.isUserInteractionEnabled = true
            notificationTimeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRegisterNotificaiton)))
        }
    }

    // MARK: Presenter
    private var presenter: TodayViewPresenter = TodayViewPresenter(service: APIService(parser: Parser()))

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetCollectionView.delegate = self
        widgetCollectionView.dataSource = self
        localization()
        setupPresenter()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    // MARK: Setup
    private func setupPresenter() {
        presenter.attachView(self)
        presenter.load()
    }

    private func localization() {
        todayLabel.text = todayLabel.text?.localized
        weekLabel.text = weekLabel.text?.localized
        notificationLabel.text = notificationLabel.text?.localized
    }

    // MARK: Fetch
    @IBAction func reload(_ sender: UIButton) {
        presenter.load()
    }

    private func load() {
        presenter.load()
    }

    // MARK: Action
    @objc func handleRegisterNotificaiton(_ gesture: UITapGestureRecognizer) {
        presenter.handleUserInteraction(type: .notificaiton)
    }

    @IBAction func handleRegisterID(_ sender: UIButton) {
        presenter.handleUserInteraction(type: .authentication)
    }

}

// MARK: - UICollectionViewDataSource
extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reusableIdentifier, for: indexPath)
        cell.backgroundColor = presenter.colors(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - GitBingoWidgetProtocol
extension TodayViewController: GitBingoWidgetProtocol {
    func hide(error: GitBingoError?) {
        var hasError = false
        if let error = error {
            githubRegisterButton.isHidden = false
            switch error {
            case .idIsEmpty:
                githubRegisterButton.setTitle("Tap to register Github ID", for: .normal)
                githubRegisterButton.isUserInteractionEnabled = true
            default:
                githubRegisterButton.setTitle(error.description, for: .normal)
                githubRegisterButton.isUserInteractionEnabled = false
            }
            hasError = true
        }

        githubRegisterButton.isHidden = !hasError
        labelStackView.isHidden = hasError
        widgetCollectionView.isHidden = hasError
        reloadButton.isHidden = hasError
    }

    func startLoad() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func endLoad() {
        activityIndicator.stopAnimating()
        widgetCollectionView.reloadData()
    }

    func hide(isAuthenticated: Bool) {
        githubRegisterButton.isHidden = isAuthenticated
        labelStackView.isHidden = !isAuthenticated
        widgetCollectionView.isHidden = !isAuthenticated
        reloadButton.isHidden = !isAuthenticated
    }

    func initUI(with contributions: Contributions?, at time: String) {
        guard let contributions = contributions else { return }
        todayCommitLabel.text = "\(contributions.today)"
        weekTotalLabel.text = "\(contributions.total)"
        notificationTimeLabel.text = time
    }

    func open(_ url: URL) {
        extensionContext?.open(url, completionHandler: nil)
    }
}
