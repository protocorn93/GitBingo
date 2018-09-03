//
//  CustomAlert.swift
//  GitBingo
//
//  Created by 이동건 on 03/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

extension UIAlertController {
    func setupCustomFont() {
        if let title = self.title {
            self.setValue(title.customFont, forKey: "attributedTitle")
        }
        
        if let message = self.message {
            self.setValue(message.customFont, forKey: "attributedMessage")
        }
    }
    
    static func showGithubIDInputAlert(on vc: UIViewController, with presenter: MainViewPresenter) {
        let alert = UIAlertController(title: "Github ID", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input your Github ID"
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            guard let id = alert.textFields?[0].text else { return }
            presenter.requestDots(from: id)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showCheckNotificationSettingsAlert(on vc: UIViewController) {
        let alert = UIAlertController(title: "Not Authorized", message: "Please check Notifications Configuration in Settings", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showRegisterNotificaitonFailedAlert(on vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: GitBingoError.failToRegisterNotification.description, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showRegisterNotificationAlert(on vc: UIViewController, at time: String, registerCompletion: ((UIAlertAction)->())?) {
        let alert = UIAlertController(title: "Register", message: "Do you want to get Notification at\n\(time) daily?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: registerCompletion))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showAskUpdateScheduledNotificationAlert(on vc: UIViewController, at time: String, registerCompletion: ((UIAlertAction)->())?) {
        
        let alert = UIAlertController(title: "🤓", message: "Scheduled Notification Existed.\nDo you want to UPDATE it to \(time)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: registerCompletion))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
