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
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var widgetCollectionView: UICollectionView!
    
    
    @IBOutlet weak var githubRegisterButton: UIButton!
    @IBOutlet weak var todayCommitLabel: UILabel!
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    private var contributions: Contribution?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetCollectionView.delegate = self
        widgetCollectionView.dataSource = self
        load()
    }
    
    private func load() {
        if let id = GroupUserDefaults.shared.load(of: .id) as? String {
            githubRegisterButton.setTitle("Welcome! \(id)👋", for: .normal)
            initiateUI(isAuthenticated: true)
        }else {
            initiateUI(isAuthenticated: false)
            return
        }
        
        if let contributions = GroupUserDefaults.shared.load(of: .contributions) as? Contribution {
            self.contributions = contributions
            self.widgetCollectionView.reloadData()
        }
        
        if let reserverdNotificaitonTime = GroupUserDefaults.shared.load(of: .notification) as? String {
            self.notificationTimeLabel.text = reserverdNotificaitonTime
        }else {
            self.notificationTimeLabel.text = "Register"
        }
    }
    
    private func initiateUI(isAuthenticated: Bool) {
        githubRegisterButton.isHidden = isAuthenticated
        daysStackView.isHidden = !isAuthenticated
        labelStackView.isHidden = !isAuthenticated
        widgetCollectionView.isHidden = !isAuthenticated
    }
        
    @IBAction func handleRegisterID(_ sender: UIButton) {
        guard let url = URL(string: "GitBingoHost://") else { return }
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
