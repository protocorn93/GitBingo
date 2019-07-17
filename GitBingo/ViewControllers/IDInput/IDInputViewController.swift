//
//  IDInputViewController.swift
//  GitBingo
//
//  Created by 이동건 on 27/06/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class IDInputViewController: UIViewController {
    enum AlertViewState {
        case show
        case hide
        
        var anchorConstant: CGFloat {
            switch self {
            case .show:
                return 144
            case .hide:
                return -250
            }
        }
    }
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var alertViewTopAnchor: NSLayoutConstraint!
    
    private var idInputViewModel: IDInputViewModelType?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAlertView(.show)
    }
    
    private func setupViews() {
        setupErrorMessageLabel()
        setupAlertView()
        setupCancelButton()
        setupDoneButton()
    }
    
    private func setupErrorMessageLabel() {
        errorMessageLabel.layer.cornerRadius = 7
        errorMessageLabel.layer.masksToBounds = true
        errorMessageLabel.isHidden = true
    }
    
    private func setupAlertView() {
        alertView.layer.cornerRadius = 20
    }
    
    private func setupCancelButton() {
        cancelButton.setTitleColor(ContributionGrade.hardGreen.color, for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    private func setupDoneButton() {
        doneButton.setTitleColor(ContributionGrade.noneGreen.color, for: .disabled)
        doneButton.setTitleColor(ContributionGrade.extremeGreen.color, for: .normal)
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }
    
    private func bind() {
        bindViewAttributes()
    }
    
    private func bindViewAttributes() {
        guard let idInputViewModel = idInputViewModel else { return }
        
        idTextField.rx.text.orEmpty
            .bind(to: idInputViewModel.inputText)
            .disposed(by: disposeBag)
        
        idInputViewModel.doneButtonValidation
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        idInputViewModel.responseStatus.observeOn(MainScheduler.instance)
            .subscribe(onNext: { status in
                switch status {
                case .success:
                    self.handleDismiss()
                case .failed(let error):
                    self.showError(error)
                    self.animateAlertView(.show)
                }
            }).disposed(by: disposeBag)
        
        idInputViewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {
                $0 ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    private func showError(_ error: Error) {
        guard let error = error as? GitBingoError else { return }
        errorMessageLabel.text = error.description
        self.errorMessageLabel.isHidden = false
    }
    
    private func handleDismiss() {
        animateAlertView(.hide, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc func handleCancel() {
        handleDismiss()
    }
    
    @objc func handleDone() {
        animateAlertView(.hide)
        errorMessageLabel.isHidden = true
        idInputViewModel?.fetch()
    }
    
    private func animateAlertView(_ state: AlertViewState, completion: (() -> Void)? = nil ) {
        alertViewTopAnchor.constant = state.anchorConstant
        state == .show ? idTextField.becomeFirstResponder() : idTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}

extension IDInputViewController: Storyboarded {
    static func instantiate(with viewModel: IDInputViewModelType) -> IDInputViewController? {
        let idInputViewController = IDInputViewController.instantiate()
        idInputViewController?.idInputViewModel = viewModel
        return idInputViewController
    }
}
