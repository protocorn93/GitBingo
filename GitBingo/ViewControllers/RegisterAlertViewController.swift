//
//  RegisterAlertViewController.swift
//  GitBingo
//
//  Created by 이동건 on 02/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import UserNotifications

class RegisterAlertViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker! {
        didSet{
            timePicker.date = Date()
            formattingTime(from: timePicker)
        }
    }
    
    private var time: String = ""
    private let center = UNUserNotificationCenter.current()
    private var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleRegister(_ sender: UIButton) {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                if let _ = UserDefaults.standard.value(forKey: KeyIdentifier.notification.value) as? String {
                    UIAlertController.showAskUpdateScheduledNotificationAlert(on: self, at: self.time, registerCompletion: { (_) in
                        self.generateNotification()
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
                UIAlertController.showRegisterNotificationAlert(on: self, at: self.time, registerCompletion: { (_) in
                    self.generateNotification()
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                UIAlertController.showCheckNotificationSettingsAlert(on: self)
            }
        }
    }
    
    @IBAction func valueDidChanged(_ sender: UIDatePicker) {
        formattingTime(from: sender)
    }
    
    fileprivate func formattingTime(from datePicker: UIDatePicker) {
        let time = formatter.string(from: datePicker.date)
        self.time = time
    }
    
    fileprivate func pasreTime(from time: String) -> (hour: Int, minute: Int)? {
        let times = self.time.split(separator: ":").map {String($0)}
        guard let hour = Int(times[0]) else { return nil }
        guard let minute = Int(times[1]) else { return nil }
        return (hour, minute)
     }
    
    fileprivate func generateNotification() {
        guard let times = pasreTime(from: time) else { return }
        let content = UNMutableNotificationContent()
        content.title = "Wait!"
        content.body = "Did You Commit?🤔"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let userCalendar = Calendar.current
        var components = userCalendar.dateComponents([.hour, .minute], from: Date())
        
        components.hour = times.hour
        components.minute = times.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "GitBingo", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if ((error) != nil){
                print("Error \(String(describing: error))")
            }
            
            UserDefaults.standard.setValue(self.time, forKey: KeyIdentifier.notification.value)
        }
    }
}
