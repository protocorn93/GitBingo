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
    
    func showWarningAlert(alertState: GitBingoAlert) {
        let alert: UIAlertController
        switch alertState {
        case .register(let hasScheduledNotification, let time):
            if hasScheduledNotification {
                alert = UIAlertController.getAlert(title: "🤓", message: "Scheduled Notification Existed.\nDo you want to UPDATE it to %@?".localized(with: time)) { (_) in
                    self.presenter.generateNotification()
                    self.dismiss(animated: true, completion: nil)
                }
                
                break
            }
            
            alert = UIAlertController.getAlert(title: "Register".localized, message: "Do you want to GET Notification at\n%@ daily?".localized(with: time)) { (_) in
                self.presenter.generateNotification()
                self.dismiss(animated: true, completion: nil)
            }
        case .unauthorized:
            alert = UIAlertController.getAlert(title: "Not Authorized".localized, message: "CHECK Notifications Configuration in Settings".localized)
        case .registerFailed:
            alert = UIAlertController.getAlert(title: "Error".localized, message: GitBingoError.failToRegisterNotification.description)
        case .removeNotification(let completion):
            alert = UIAlertController.getAlert(title: "Remove".localized, message: "Do you really want to REMOVE Scheduled Notification?".localized, with: completion)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateDescriptionLabel(with text: String) {
        self.scheduledNotificationIndicator.text = text
    }
}

