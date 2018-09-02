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
            parseTime(from: timePicker)
        }
    }
    
    private var hour: Int!
    private var minute: Int!
    private var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleRegister(_ sender: UIButton) {
        var alert: UIAlertController?
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                alert = self.generateAlert(title: "Register", message: "Do you really want notification at\n\(self.hour ?? 0) : \(self.minute ?? 0) daily?", hasOK: true, hasCancel: true)
                self.present(alert!, animated: true, completion: nil)
            }else {
                alert = self.generateAlert(title: "Not Authorized", message: "Please check Notifications Configuration in Settings", hasOK: true, hasCancel: false)
                self.present(alert!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func valueDidChanged(_ sender: UIDatePicker) {
        parseTime(from: sender)
    }
    
    fileprivate func parseTime(from datePicker: UIDatePicker) {
        let times = formatter.string(from: datePicker.date).split(separator: ":").map {String($0)}
        guard let hour = Int(times[0]) else { return }
        guard let minute = Int(times[1]) else { return }
        
        self.hour = hour
        self.minute = minute
    }
    
    fileprivate func generateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Wait!"
        content.body = "Did You Commit?🤔"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let userCalendar = Calendar.current
        var components = userCalendar.dateComponents([.hour, .minute], from: Date())
        
        components.hour = hour
        components.minute = minute
        
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
