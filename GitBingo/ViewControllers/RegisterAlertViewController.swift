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
        presenter.updateScheduledNotificationDescription()
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
}

//MARK:- RegisterNotificationProtocol
extension RegisterAlertViewController: RegisterNotificationProtocol {
    
    func showRegisterAlert(_ hasScheduledNotification: Bool, with time: String) {
        if hasScheduledNotification {
            UIAlertController.showAlertForRegister(on: self, title: "🤓", message: "Scheduled Notification Existed.\nDo you want to UPDATE it to \(time)?") { (_) in
                self.presenter.generateNotification()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        UIAlertController.showAlertForRegister(on: self, title: "Register", message: "Do you want to get Notification at\n\(time) daily?") { (_) in
            self.presenter.generateNotification()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showUnAuthorizedAlert() {
        UIAlertController.showAlert(on: self, title: "Not Authorized", message: "Please check Notifications Configuration in Settings")
    }
    
    func showRegisterFailedAlert() {
        UIAlertController.showAlert(on: self, title: "Error", message: GitBingoError.failToRegisterNotification.description)
    }
    
    func updateDescriptionLabel(with text: String) {
        self.scheduledNotificationIndicator.text = text
    }
}

