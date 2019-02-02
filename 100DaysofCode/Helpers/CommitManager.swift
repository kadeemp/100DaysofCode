//
//  CommitManager.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/28/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import SwiftDate

class CommitManager {


    static func checkCommitStatus() {
        var nodes:[CommitNode] = []
        var currentDay:Date!

        let calendar = Calendar.current
        currentDay = Date()

         nodes = CoreDataStack.returnSavedNodes()
        let lastNode = nodes[nodes.count - 1]
        let todaysComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
        let lastCommitComponents = calendar.dateComponents([.year,.day,.month], from: lastNode.date!)


        let thisYear = todaysComponents.year!
        let thisMonth = todaysComponents.month!
        let today = todaysComponents.day!

        

//        print(currentDay.compare(.isToday))
//
//        print(lastCommitDate)
//        print(currentDay)
//        print(today)
      //  NetworkingProvider.updateMissingNodes(dateOffset: 2)

//        if today == lastCommitDate {
//
//        } else {
//            let dateOffset = lastCommitDate - today
//         //   NetworkingProvider.updateMissingNodes(dateOffset: 2)
//        }

    }
    
}
