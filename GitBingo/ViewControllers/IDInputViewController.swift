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

class IDInputViewController: UIViewController {
    enum AlertViewState {
        case show
        case hide
        
        var anchorConstant: CGFloat {
            switch self {
            case .show:
                return 144
            case .hide:
                return -220
            }
        }
    }
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var alertViewTopAnchor: NSLayoutConstraint!
    
    private (set) var id = PublishSubject<String>()
    private var doneButtonIsValid = BehaviorSubject<Bool>(value: false)
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
        setupAlertView()
        setupCancelButton()
        setupDoneButton()
    }
    
    private func setupAlertView() {
        alertView.layer.cornerRadius = 20
    }
    
    private func setupCancelButton() {
        cancelButton.setTitleColor(ContributionGrade.hardGreen.color, for: .normal)
    }
    
    private func setupDoneButton() {
        doneButton.setTitleColor(ContributionGrade.noneGreen.color, for: .disabled)
        doneButton.setTitleColor(ContributionGrade.extremeGreen.color, for: .normal)
    }
    
    private func bind() {
        bindViewAttributes()
        bindActions()
    }
    
    private func bindViewAttributes() {
        idTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: doneButtonIsValid)
            .disposed(by: disposeBag)
        
        doneButtonIsValid
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.animateAlertView(.hide, completion: {
                    self?.dismiss(animated: false, completion: nil)
                })
            })
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.animateAlertView(.hide, completion: {
                    self?.id.onNext(self?.idTextField.text ?? "")
                    self?.dismiss(animated: false, completion: nil)
                })
            })
            .disposed(by: disposeBag)
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

extension IDInputViewController: Storyboarded { }
