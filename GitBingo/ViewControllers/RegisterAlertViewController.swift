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
        var alert: UIAlertController?
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                alert = self.generateAlert(title: "Register", message: "Do you really want get notification at\n\(self.time) daily?", hasOK: true, hasCancel: true)
                self.present(alert!, animated: true, completion: nil)
            }else {
                alert = self.generateAlert(title: "Not Authorized", message: "Please check Notifications Configuration in Settings", hasOK: true, hasCancel: false)
                self.present(alert!, animated: true, completion: nil)
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
        }
    }
    
    fileprivate func generateAlert(title: String?, message: String?, hasOK: Bool, hasCancel: Bool) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if hasCancel {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.generateNotification()
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        }else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
        }
        
        return alert
    }
}
