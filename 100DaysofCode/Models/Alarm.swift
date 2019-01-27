//
//  Alarm.swift
//  Alarm
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Palacios. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    var fireDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: fireDate)
    }
    
    init(name: String, enabled: Bool = true, fireDate: Date) {
        self.name = name
        self.enabled = enabled
        self.uuid = UUID().uuidString
        self.fireDate = fireDate
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
