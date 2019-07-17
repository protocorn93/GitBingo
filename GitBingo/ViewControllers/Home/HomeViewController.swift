//
//  ViewController.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SVProgressHUD

class HomeViewController: UIViewController {
    // MARK: Typealias
    typealias CellConfiguration = (CollectionViewSectionedDataSource<DotsSectionModel>, UICollectionView, IndexPath, ContributionGrade) -> UICollectionViewCell
    typealias SupplementaryViewConfiguration = ((CollectionViewSectionedDataSource<HomeViewController.DotsSectionModel>, UICollectionView, String, IndexPath) -> UICollectionReusableView)?
    typealias DotsSectionModel = SectionModel<String, ContributionGrade>
    typealias DotsDataSources = RxCollectionViewSectionedReloadDataSource<DotsSectionModel>
    
    // MARK: Outlets
    @IBOutlet weak var githubInputAlertButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Properties
    private var refreshControl = UIRefreshControl()
    private var homeViewDependencyContainer = HomeViewDependencyContainer()
    private lazy var homeViewModel: HomeViewModelType = homeViewDependencyContainer.generateHomeViewModel()
    private var disposeBag = DisposeBag()
    
    private lazy var cellConfiguration: CellConfiguration = { (dataSource, collectionView, indexPath, grade) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reusableIdentifier, for: indexPath)
        cell.backgroundColor = grade.color
        return cell
    }
    
    private lazy var supplementaryViewConfiguration: SupplementaryViewConfiguration = { (dataSource, collectionView, kind, indexPath) in
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reusableIdentifier, for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        view.weekLabel.text = dataSource.sectionModels[indexPath.section].model
        return view
    }
    
    private var dotsDataSource: DotsDataSources {
        let dataSource = DotsDataSources(configureCell: cellConfiguration)
        dataSource.configureSupplementaryView = supplementaryViewConfiguration
        return dataSource
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    // MARK: Setup Views
    private func setupViews() {
        setupNaviagtionBar()
        setupCollectionView()
        setupRefreshControl()
    }
    
    fileprivate func setupNaviagtionBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    fileprivate func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
    }
    
    fileprivate func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func bind() {
        bindButtonTitle()
        bindCollectionView()
    }
    
    private func bindButtonTitle() {
        homeViewModel.buttonTitle
            .bind(to: githubInputAlertButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        homeViewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dotsDataSource))
            .disposed(by: disposeBag)
    }

    // MARK: Actions
    @objc func refresh() {
        
    }

    @IBAction func handleRefresh(_ sender: Any) {
        
    }

    @IBAction func handleShowGithubInputAlert(_ sender: Any) {
        guard let idInputViewController = IDInputViewController.instantiate(with: homeViewDependencyContainer.generateIDInputViewModel()) else { return }
        idInputViewController.modalPresentationStyle = .overCurrentContext
        present(idInputViewController, animated: false, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = self.view.frame.width / 7
        return CGSize(width: widht, height: widht)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
}
