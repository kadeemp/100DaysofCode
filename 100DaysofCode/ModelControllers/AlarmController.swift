//
//  AlarmController.swift
//  Alarm
//
//  Created by Jared Warren on 10/8/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Check in To update your streak"
        content.sound = UNNotificationSound.default
        

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)

       let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        print("the scheduled uuid is  \(alarm.uuid)")
       center.add(request) { (_) in
            print("Notification was scheduled")
        }
        
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    func removeAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}

class AlarmController: AlarmScheduler {
    
    static var shared = AlarmController()
    var allAlarms: [Alarm] = []
    init(){
        loadFromPersistentStorage()
    }
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(name: name, enabled: enabled, fireDate: fireDate)
        print("newAlarm uid = \(newAlarm.uuid)")
        allAlarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistentStorage()
        return
    }
    
    func deleteAlarm(alarmBeingDeleted: Alarm) {
        guard let index = allAlarms.firstIndex(of: alarmBeingDeleted) else { return }
        allAlarms.remove(at: index)
        cancelUserNotifications(for: alarmBeingDeleted)
        saveToPersistentStorage()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    func toggleEnabledByIndex(index:Int) {
        let alarm = allAlarms[index]
        print("toggled alarm uid is \(alarm.uuid)")
        switch alarm.enabled {
        case true:
            print("disabled")
            cancelUserNotifications(for: alarm)
            allAlarms[index].enabled = false
        case false:
            print("enabled")
            scheduleUserNotifications(for: alarm)
            allAlarms[index].enabled = true
        }
        saveToPersistentStorage()
    }
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "alarm.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        
        let enconder = JSONEncoder()
        do {
            let data = try enconder.encode(AlarmController.shared.allAlarms)
            try data.write(to: fileURL())
        } catch {
            print("error encoding")
            
        }
        
    }
    
    func loadFromPersistentStorage() {
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.allAlarms = alarms
        } catch {
            print("error decoding")
        }
    }
}
