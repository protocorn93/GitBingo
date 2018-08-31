//
//  ViewController.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var presenter: MainViewPresenter = MainViewPresenter()
    var contribution: Contribution?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPresenter()
    }
    
    fileprivate func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func setupPresenter(){
        presenter.attachView(self)
        presenter.requestDots()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.dotsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dotcell", for: indexPath)
        cell.backgroundColor = presenter.color(of: indexPath)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = self.view.frame.width / 7
        return CGSize(width: widht, height: widht)
    }
}

extension ViewController: GithubDotsRequestProtocol {
    func showProgressStatus() {
        SVProgressHUD.show()
    }
    
    func dismissProgressStatus() {
        SVProgressHUD.showSuccess(withStatus: "success")
    }
    
    func updateDots() {
        self.collectionView.reloadData()
    }
}

