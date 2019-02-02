//
//  NetworkingProvider.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import CoreData

class NetworkingProvider {

typealias ReturnCommitNode = (CommitNode) -> ()
typealias ReturnTodaysCommit = (CalendarNode) -> ()


    static func validateUsername(_ username:String, completion: @escaping (Int) -> ()) {
        Alamofire.request("https://github.com/\(username)").responseString { (response) in
            completion((response.response?.statusCode)!)
        }
    }
    static func getCurrentStreakFor(username: String, completion: @escaping (Int) -> Void) {
        Alamofire.request("https://github.com/\(username)").responseString { response in
            completion(self.parseStreakFromHTML(html: response.result.value!))    }
    }
    static func getProfilePictureFor(username: String, completion: @escaping (String) -> Void) {
        Alamofire.request("https://github.com/\(username)").responseString { response in
            completion(self.parseProfilePictureURLFromHTML(html: response.result.value!))    }
    }

    static func parseProfilePictureURLFromHTML(html: String) -> String {
        var profilePictureURL = ""
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for picture in doc.css("img[class^='avatar width-full rounded-2']") {
                if let url = picture["src"] {
                    profilePictureURL = String(url)
                }
            }
        }
        return profilePictureURL
    }
    


    static func returnNodesFromHTML() -> [CommitNode] {

        var nodes :[CommitNode] = []
        guard let username = UserDefaults.standard.string(forKey: "username") else {return nodes}
        var entity = NSEntityDescription.entity(forEntityName: "CommitNode", in: CoreDataStack.persistentContainer.viewContext)
        var todaysDate:Date!
        todaysDate = Date()
        let calendar = Calendar.current

        let todaysComponents = calendar.dateComponents([.day, .month, .year], from: todaysDate)
        let today = todaysComponents.day!
        let month = todaysComponents.month!
        let year = todaysComponents.year!


         Alamofire.request("https://github.com/\(username)").responseString { response in


        if let doc =  try? Kanna.HTML(html: response.result.value! , encoding: String.Encoding.utf8) {
            var commitList: [Int] = []
            var commitStatus = false


            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
                var commitCount = Int(day["data-count"]!)!
                var date = day["data-date"]!

                if month >= 10 {
                    if day["data-date"]! == "\(year)-\(month )-\(today)" {
                        print("Found the date!")
                    }
                } else {
                    if day["data-date"]! == "\(year)-0\(month )-\(today)" {
                        print("Found the date!")
                          print(" Commit Count is \(Int(day["data-count"]!)!)")
                    }
                }

                if commitCount == 0 {
                    commitStatus = false
                } else {
                    commitStatus = true
                }
                let dateForatter = DateFormatter()
                dateForatter.dateFormat = "yyyy-MM-dd"
                var  date2 = dateForatter.date(from: date)
                //print(date2!)
                let nodeObject = NSManagedObject(entity: entity!, insertInto: CoreDataStack.persistentContainer.viewContext)
            
                
                nodeObject.setValue(date2!, forKey: "date")
                nodeObject.setValue(commitCount, forKey: "commitCount")
                nodeObject.setValue(commitStatus, forKey: "commitStatus")
//print(nodeObject)
                CoreDataStack.saveContext()

            }
            }

    }
        return nodes
    }


    static func checkCommitStatus(completion: @escaping ReturnTodaysCommit ) {
        var nodes :[CommitNode] = []
        guard let username = UserDefaults.standard.string(forKey: "username") else {return }

        var todaysDate:Date!
        todaysDate = Date()
        let calendar = Calendar.current

        let todaysComponents = calendar.dateComponents([.day, .month, .year], from: todaysDate)
        let today = todaysComponents.day!
        let month = todaysComponents.month!
        let year = todaysComponents.year!
         let dateFormatter = DateFormatter()


        Alamofire.request("https://github.com/\(username)").responseString { response in


            if let doc =  try? Kanna.HTML(html: response.result.value! , encoding: String.Encoding.utf8) {
                var commitList: [Int] = []
                var commitStatus = false


                for day in doc.css("rect[class^='day']") {
                    commitList += [Int(day["data-count"]!)!]
                    let commitCount = Int(day["data-count"]!)!
                    let date = day["data-date"]!

                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let  convertedDate = dateFormatter.date(from: date)


                    if month >= 10 {
                        if day["data-date"]! == "\(year)-\(month )-\(today)" {
                            print("Found the date!")
                        }
                    } else {
                        if day["data-date"]! == "\(year)-0\(month )-\(today)" {
                            print("Found the date!")
                            print(" Commit Count is \(Int(day["data-count"]!)!)")
                            if commitCount == 0 {
                                completion(CalendarNode(date: convertedDate!, commitStatus: commitStatus, commitCount: commitCount))
                            } else if commitCount != 0 {
                                commitStatus = true

                                completion(CalendarNode(date: convertedDate!, commitStatus: commitStatus, commitCount: commitCount))
                                CoreDataStack.saveNode(date: convertedDate!, commitCount: commitCount, commitStatus: commitStatus)
                            }
                        }
                    }
                }
            }
        }
    }

    static func getStreak(commitList:[Int]) -> Int {
        var commits = commitList
        var streak = 0

        if commitList[ commitList.count - 1] == 0 {
            UserDefaults.standard.set(false, forKey: "hasCommited")
        } else  {
            UserDefaults.standard.set(true, forKey: "hasCommited")
        }
        commits = commitList.reversed()

        if ((commits[0] == 0) && (commits[1] != 0)) {
            commits.remove(at: 0)

        }

        for day in commits {
            if day != 0 {
                streak += 1
            } else {
                break
            }
        }


        return streak
    }


    static func parseStreakFromHTML(html: String) -> Int {
        var streak = 0
        if let doc =  try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            var commitList: [Int] = []
            var commitStatus = false

            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
            }
            print(" commit list \(commitList)")
            commitList.remove(at: commitList.count - 1)

            streak = NetworkingProvider.getStreak(commitList: commitList)
    }
        return streak
}

}
