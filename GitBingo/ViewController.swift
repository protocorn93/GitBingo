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

    @IBOutlet weak var githubInputAlertButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var refreshControl = UIRefreshControl()
    private var presenter: MainViewPresenter = MainViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPresenter()
        setupRefreshControl()
    }
    
    fileprivate func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func setupPresenter() {
        presenter.attachView(self)
        presenter.requestDots()
    }
    
    fileprivate func generateInputAlert() {
        let alert = UIAlertController(title: "Github ID", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input your Github ID"
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            guard let id = alert.textFields?[0].text else { return }
            self.presenter.requestDots(from: id)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        refreshControl.beginRefreshing()
        do {
            try presenter.refresh()
        } catch {
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        presenter.requestDots()
    }
    
    @IBAction func handleShowGithubInputAlert(_ sender: Any) {
        generateInputAlert()
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
    
    func setUpGithubInputAlertButton(_ title: String) {
        githubInputAlertButton.setTitle(title, for: .normal)
    }
    
    func showProgressStatus() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SVProgressHUD.show()
    }
    
    func showSuccessProgressStatus() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.showSuccess(withStatus: "Success")
        refreshControl.endRefreshing()
    }
    
    func updateDots() {
        self.collectionView.reloadData()
    }
    
    func showFailProgressStatus(with error: GitBingoError) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.showError(withStatus: error.description)
    }
}

