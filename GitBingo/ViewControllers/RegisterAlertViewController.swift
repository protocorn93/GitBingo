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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleRegister(_ sender: UIButton) {
        
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
}
