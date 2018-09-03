//
//  RegisterViewPresenter.swift
//  GitBingo
//
//  Created by 이동건 on 03/09/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import UserNotifications

protocol RegisterNotificationProtocol {
    func showRegisterAlert(_ hasScheduledNotification: Bool, with time: String)
    func showUnAuthorizedAlert()
    func showRegisterFailedAlert()
    func updateDescriptionLabel(with text: String)
}

class RegisterViewPresenter {
    //MARK: Properties
    private var vc: RegisterNotificationProtocol?
    private let center = UNUserNotificationCenter.current()
    private var time: String
    private var hasScheduledNotification: Bool = {
        guard let _ = UserDefaults.standard.value(forKey: KeyIdentifier.notification.value) else { return false }
        return true
    }()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    //MARK: Life Cycle
    init() {
        self.time = dateFormatter.string(from: Date())
    }
    
    //MARK: Methods
    func attachView(_ vc: RegisterNotificationProtocol?) {
        self.vc = vc
    }
    
    func detatchView() {
        self.vc = nil
    }
    
    func setupTime(with date: Date) {
        self.time = dateFormatter.string(from: date)
    }
    
    func showAlert() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.vc?.showRegisterAlert(self.hasScheduledNotification, with: self.time)
            }else {
                self.vc?.showUnAuthorizedAlert()
            }
        }
    }
    
    func updateScheduledNotificationDescription() {
        if let time = UserDefaults.standard.value(forKey: KeyIdentifier.notification.value) as? String {
            vc?.updateDescriptionLabel(with: "Scheduled at \(time)")
            return
        }
        
        vc?.updateDescriptionLabel(with: "No Scheduled Notification so far")
    }
    
    func generateNotification() {
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
                self.vc?.showRegisterFailedAlert()
            }
            
            UserDefaults.standard.setValue(self.time, forKey: KeyIdentifier.notification.value)
        }
    }
    
    private func pasreTime(from time: String) -> (hour: Int, minute: Int)? {
        let times = self.time.split(separator: ":").map {String($0)}
        guard let hour = Int(times[0]) else { return nil }
        guard let minute = Int(times[1]) else { return nil }
        return (hour, minute)
    }
}