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


    static func updateCommitStatus() {
        var currentDay = Date()

        let calendar = Calendar.current
        var hasCommited = UserDefaults.standard.bool(forKey: "hasCommited")


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"

        let todaysComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
        let thisYear = todaysComponents.year!
        let thisMonth = todaysComponents.month!
        let today = todaysComponents.day!

        guard let todayAsDate = dateFormatter.date(from: "\(thisYear)-\(thisMonth)-\(today)") else { return }

        let node1 = CoreDataStack.returnNodeByDate(todayAsDate)
        print(node1.date!)
        print(todayAsDate)

        if node1 != nil {
            if todayAsDate == node1.date! {
                if hasCommited == true {
                    return
                } else {

                }

            }
        }



        //print(lastCommitAsDate!)

        

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
