//
//  AlarmController.swift
//  AlarmiOS35
//
//  Created by Todd Crandall on 7/27/20.
//  Copyright © 2020 Todd Crandall. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    //MARK: - Shared Instance
    static let sharedInstance = AlarmController()
    
    //MARK: - Properties
    //Source of Truth
    var alarms: [Alarm] = []
    
//    let identifier = "alarmNotification"
    
//    var mockAlarms: [Alarm] = {
//        let alarm1 = Alarm(timeLabel: Date(), nameLabel: "Wake Up")
//        let alarm2 = Alarm(timeLabel: Date(), nameLabel: "Go to bed")
//        return [alarm1, alarm2]
//    }()
    
    func toggleIsOn(for alarm: Alarm) {
        alarm.alarmSwitch.toggle()
        if alarm.alarmSwitch {
            scheduleUserNotifications(from: alarm)
        } else {
            cancelUserNotification(from: alarm)
        }
    }
    
    //MARK: - CRUD
    //create
    func create(alarmWithTimeLabel timeLabel: Date, alarmWithNameLabel nameLabel: String, alarmWithAlarmSwitch alarmSwitch: Bool) {
        let alarm = Alarm(timeLabel: timeLabel, nameLabel: nameLabel, alarmSwitch: alarmSwitch)
        alarms.append(alarm)
        scheduleUserNotifications(from: alarm)
        saveToPersistentStore()
    }
    //update
    func update(alarm: Alarm, timeLabel: Date, nameLabel: String, alarmSwitch: Bool) {
        cancelUserNotification(from: alarm)
        alarm.timeLabel = timeLabel
        alarm.nameLabel = nameLabel
        alarm.alarmSwitch = alarmSwitch
        scheduleUserNotifications(from: alarm)
        saveToPersistentStore()
    }
    //remove
    func remove(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        self.cancelUserNotification(from: alarm)
        alarms.remove(at: index)
        saveToPersistentStore()
    }

//MARK: - Persistence
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let filename = "alarms.json"
        let fullURL = documentDirectory.appendingPathComponent(filename)
        return fullURL
    }
    
    func saveToPersistentStore() {
        
        do {
            let data = try JSONEncoder().encode(alarms)
            print(data)
            print(String(data: data, encoding: .utf8)!)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving alarm \(error)")
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try JSONDecoder().decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch let error {
            print("Error loading data from disk \(error)")
            print("\(#file)\(#line)")
        }
    }
}

protocol AlarmScheduler: class {
//    func scheduleUserNotifications(from alarm: Alarm)
//    func cancelUserNotifications(from alarm: Alarm)
}
extension AlarmScheduler {
    func scheduleUserNotifications(from alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.title = "Your alarm is going off!!"
        content.subtitle = "You should probably turn it off..."
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let DateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.timeLabel)
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error scheduling local user notifications \(error.localizedDescription)")
            }
        }
    }
    func cancelUserNotification(from alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
