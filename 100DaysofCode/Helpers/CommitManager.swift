//
//  CommitManager.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/28/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation


class CommitManager {

    static func updateHasCommited() -> Bool? {
        var currentDay = Date()
        UserDefaults.standard.set(true, forKey: "hasCommited")

        let calendar = Calendar.current
        var hasCommited = UserDefaults.standard.bool(forKey: "hasCommited")


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"

        let todaysComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
        let thisYear = todaysComponents.year!
        let thisMonth = todaysComponents.month!
        let today = todaysComponents.day!

        guard let todayAsDate = dateFormatter.date(from: "\(thisYear)-\(thisMonth)-\(today)") else { return  false}
        print(todayAsDate, #function )

        let todaysNode = CoreDataStack.returnNodeByDate(todayAsDate)
        if todaysNode != nil {
            print(todaysNode?.date!)
            //print(" node date\(todaysNode.date!) \n todays date \( todayAsDate)")
        }
        return false
    }

    static func updateCommitStatus(completion: @escaping (Int,[CommitNode]) -> ()) {

        NetworkingProvider.returnCommitData { (status, streak, nodes) in
            UserDefaults.standard.set(status, forKey: "hasCommited")
            completion(streak, nodes)
        }
    }
}
