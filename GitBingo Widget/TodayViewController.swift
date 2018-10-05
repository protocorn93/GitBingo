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
    
    private var presenter: TodayViewPresenter = TodayViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetCollectionView.delegate = self
        widgetCollectionView.dataSource = self
        setupPresenter()
    }
    
    private func setupPresenter() {
        presenter.attachView(self)
        presenter.load()
    }
    
    @IBAction func reload(_ sender: UIButton) {
        presenter.load()
    }
    
    private func load() {
        presenter.load()
    }
    
    @objc func handleRegisterNotificaiton(_ gesture: UITapGestureRecognizer) {
        handleUserInteraction(type: .notificaiton)
    }
        
    @IBAction func handleRegisterID(_ sender: UIButton) {
        handleUserInteraction(type: .authentication)
    }
    
    private func handleUserInteraction(type: AppURL) {
        guard let url = URL(string: "GitBingoHost://\(type.path)") else { return }
        extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widgetcell", for: indexPath)
        cell.backgroundColor = presenter.colors(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
}

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

extension TodayViewController: GitBingoWidgetProtocol {
    
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
    
    func initUI(with contributions: Contribution, at time: String) {
        todayCommitLabel.text = "\(contributions.today)"
        weekTotalLabel.text = "\(contributions.total)"
        notificationTimeLabel.text = time
    }
}
