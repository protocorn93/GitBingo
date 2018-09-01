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
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
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
            UserDefaults.standard.set(id, forKey: "id")
            self.presenter.requestDots()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        presenter.refresh(mode: .pullToRefresh)
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        presenter.refresh(mode: .tapToRefresh)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : presenter.dotsCount - 7
//        return presenter.dotsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dotcell", for: indexPath)
        let index = indexPath.section == 0 ? indexPath.item : indexPath.item + 6
        cell.backgroundColor = presenter.color(at: index)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reusableIdentifier, for: indexPath) as! SectionHeaderView
            view.weekLabel.text = indexPath.section == 0 ? "This Week" : "Last Weeks"
            return view
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooterView.reusableIdentifier, for: indexPath) as! SectionFooterView
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 20)
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
    
    func showProgressStatus(mode: RefreshMode?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let mode = mode {
            switch mode {
            case .pullToRefresh:
                refreshControl.beginRefreshing()
            case .tapToRefresh:
                SVProgressHUD.show()
            }
            
            return
        }
        SVProgressHUD.show()
    }
    
    func showSuccessProgressStatus() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.showSuccess(withStatus: "Success")
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func showFailProgressStatus(with error: GitBingoError) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.showError(withStatus: error.description)
    }
}

