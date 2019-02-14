//
//  CommitManager.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/28/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation


class CommitManager {


    static func updateCommitStatus(completion: @escaping (Int,[CalendarNode]) -> ()) {
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
//        print(node1.date!)
        print(#function, todayAsDate)

        if node1.date != nil {
            if todayAsDate == node1.date! {
                if hasCommited == true {
                    return
                } else {
                    NetworkingProvider.checkCommitStatus { (status, streak, nodes) in
                        UserDefaults.standard.set(status, forKey: "hasCommited")
                        completion(streak, nodes)
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "hasCommited")
                NetworkingProvider.checkCommitStatus { (status, streak, nodes) in
                    UserDefaults.standard.set(status, forKey: "hasCommited")
                    completion(streak, nodes)
                }
            }
        } else {
            NetworkingProvider.checkCommitStatus { (status, streak, nodes) in
                UserDefaults.standard.set(status, forKey: "hasCommited")
                completion(streak, nodes)
            }
    }
    }
    
}
