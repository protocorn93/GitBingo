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
            textField.placeholder = "Input your Github ID".localized
        }
        
        alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: { (_) in
            guard let id = alert.textFields?[0].text else { return }
            do {
                try presenter.requestDots(from: id)
            }catch let err as GitBingoError {
                presenter.showError(with: err)
            }catch {
                presenter.showError(with: .unexpected)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(on vc: UIViewController, title: String, message: String, with completion: ((UIAlertAction)->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
