//
//  RegisterAlertViewController.swift
//  GitBingo
//
//  Created by 이동건 on 02/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

class RegisterAlertViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var scheduledNotificationIndicator: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker! {
        didSet{
            timePicker.date = Date()
        }
    }
    
    //MARK: Properties
    private var presenter: RegisterViewPresenter = RegisterViewPresenter()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.updateScheduledNotificationIndicator()
    }
    
    deinit {
        presenter.detatchView()
    }
    
    //MARK: Actions
    @IBAction func handleRegister(_ sender: UIButton) {
        presenter.showAlert()
    }
    
    @IBAction func valueDidChanged(_ sender: UIDatePicker) {
        presenter.setupTime(with: sender.date)
    }
    
    @IBAction func handleRemoveNotification(_ sender: UIBarButtonItem) {
        presenter.removeNotification()
    }
    
    @IBAction func handleDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- RegisterNotificationProtocol
extension RegisterAlertViewController: RegisterNotificationProtocol {
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(alertState: GitBingoAlertState) {
        let alert = alertState.alert
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateDescriptionLabel(with text: String) {
        self.scheduledNotificationIndicator.text = text
    }
}

