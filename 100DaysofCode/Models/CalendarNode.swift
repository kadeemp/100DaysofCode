//
//  CommitNode.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/27/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
struct CalendarNode {

    let date:Date
    let commitStatus:Bool
    let commitCount:Int
    
    init(date:Date, commitStatus:Bool, commitCount:Int) {
        self.date = date
        self.commitStatus = commitStatus
        self.commitCount = commitCount
    }
}
