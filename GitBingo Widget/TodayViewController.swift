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
        
    @IBOutlet weak var todayCommitLabel: UILabel!
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var widgetCollectionView: UICollectionView!
    
    private var contributions: Contribution?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetCollectionView.delegate = self
        widgetCollectionView.dataSource = self
        load()
    }
    
    private func load() {
        if let groupUserDefaults = UserDefaults(suiteName: "group.Gitbingo"), let data = groupUserDefaults.object(forKey: KeyIdentifier.contributions.value) as? Data {
            guard let contributions = try? PropertyListDecoder().decode(Contribution.self, from: data) else {
                print("No contributions")
                return
            }
            self.contributions = contributions
            self.widgetCollectionView.reloadData()
        }
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
