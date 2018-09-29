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
    
    
    @IBOutlet weak var githubRegisterButton: UIButton!
    @IBOutlet weak var todayCommitLabel: UILabel!
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel! {
        didSet {
            notificationTimeLabel.isUserInteractionEnabled = true
            notificationTimeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRegisterNotificaiton)))
        }
    }
    
    private var contributions: Contribution?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetCollectionView.delegate = self
        widgetCollectionView.dataSource = self
        load()
    }
    
    private func load() {
        if let id = GroupUserDefaults.shared.load(of: .id) as? String {
            fetchContributions(of: id) {
                self.initiateUI(isAuthenticated: true)
            }
        }else {
            initiateUI(isAuthenticated: false)
            return
        }
        
        if let contributions = GroupUserDefaults.shared.load(of: .contributions) as? Contribution {
            self.contributions = contributions
            todayCommitLabel.text = "\(contributions.today)"
            weekTotalLabel.text = "\(contributions.total)"
            self.widgetCollectionView.reloadData()
        }
        
        if let reserverdNotificaitonTime = GroupUserDefaults.shared.load(of: .notification) as? String {
            self.notificationTimeLabel.text = reserverdNotificaitonTime
        }else {
            self.notificationTimeLabel.text = "➕"
        }
    }
    
    private func initiateUI(isAuthenticated: Bool) {
        githubRegisterButton.isHidden = isAuthenticated
        labelStackView.isHidden = !isAuthenticated
        widgetCollectionView.isHidden = !isAuthenticated
        
        todayCommitLabel.text = "\(contributions?.today ?? 0)"
        weekTotalLabel.text = "\(contributions?.total ?? 0)"
        widgetCollectionView.reloadData()
    }
    
    private func fetchContributions(of id: String, completion: @escaping ()->() ) {
        APIService.shared.fetchContributionDots(of: id) { (contributions, err) in
            DispatchQueue.main.async {
                guard let dots = contributions?.dots else { return }
                let thisWeekContributions = Contribution(dots: dots.prefix(7).map{$0})
                self.contributions = thisWeekContributions
                completion()
            }
        }
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
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.widgetCollectionView.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widgetcell", for: indexPath)
        cell.backgroundColor = contributions?.colors[indexPath.item]
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
