//
//  ViewController.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var githubInputAlertButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Properties
    private var refreshControl = UIRefreshControl()
    private var presenter: MainViewPresenter = MainViewPresenter(service: APIService(parser: Parser(),
                                                                                     session: URLSession(configuration: .default)))

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviagtionBar()
        setupCollectionView()
        setupPresenter()
        setupRefreshControl()
    }

    // MARK: Setups
    fileprivate func setupNaviagtionBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
    }

    fileprivate func setupPresenter() {
        presenter.attachView(self)
        presenter.request()
    }

    fileprivate func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    // MARK: Actions
    @objc func refresh() {
        presenter.refresh(mode: .pullToRefresh)
    }

    @IBAction func handleRefresh(_ sender: Any) {
        presenter.refresh(mode: .tapToRefresh)
    }

    @IBAction func handleShowGithubInputAlert(_ sender: Any) {
        let alert = UIAlertController.getTextFieldAlert { [weak self] (id) in
            self?.presenter.request(from: id)
        }
        alert.textFields?.first?.addTarget(alert, action: #selector(UIAlertController.handleEdtingChanged(_:)), for: .editingChanged)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : presenter.dotsCount - 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reusableIdentifier, for: indexPath)
        let index = indexPath.section == 0 ? indexPath.item : indexPath.item + 7
        cell.backgroundColor = presenter.color(at: index)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reusableIdentifier, for: indexPath) as? SectionHeaderView else {
                return UICollectionReusableView()
            }
            view.weekLabel.text = indexPath.section == 0 ? "This Week" : "Last Weeks"
            return view
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooterView.reusableIdentifier, for: indexPath) as? SectionFooterView else {
            return UICollectionReusableView()
        }
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 20)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = self.view.frame.width / 7
        return CGSize(width: widht, height: widht)
    }
}

// MARK: - GithubDotsRequestProtocol
extension HomeViewController: DotsUpdateableDelegate {

    func setUpGithubInputAlertButton(_ title: String) {
        DispatchQueue.main.async {
            self.githubInputAlertButton.setTitle(title, for: .normal)
        }
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
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            SVProgressHUD.showSuccess(withStatus: "Success")
            SVProgressHUD.dismiss(withDelay: 1)

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }

    func showFailProgressStatus(with error: GitBingoError) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            SVProgressHUD.showError(withStatus: error.description)
            SVProgressHUD.dismiss(withDelay: 1)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}
