//
//  Alarm.swift
//  AlarmiOS35
//
//  Created by Todd Crandall on 7/27/20.
//  Copyright © 2020 Todd Crandall. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var timeLabel: Date
    var nameLabel: String
    var alarmSwitch: Bool
    var uuid: String
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timeLabel)
    }
    
    init(timeLabel: Date, nameLabel: String, alarmSwitch: Bool = true, uuid: String = UUID().uuidString) {
        self.timeLabel = timeLabel
        self.nameLabel = nameLabel
        self.alarmSwitch = alarmSwitch
        self.uuid = uuid
    }
}//End of Class

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}//End of Extension
