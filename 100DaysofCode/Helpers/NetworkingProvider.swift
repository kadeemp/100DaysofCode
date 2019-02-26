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
typealias ReturnTodaysCommit = (Bool,Int, [CalendarNode]) -> ()


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
        var streak = 0
        guard let username = UserDefaults.standard.string(forKey: "username") else {return nodes}
        var todaysDate:Date!
        todaysDate = Date()
        let calendar = Calendar.current

        let todaysComponents = calendar.dateComponents([.day, .month, .year], from: todaysDate)
        let today = todaysComponents.day!
        let month = todaysComponents.month!
        let year = todaysComponents.year!


    let dateForatter = DateFormatter()
    dateForatter.dateFormat = "yyyy-MM-dd"

         Alamofire.request("https://github.com/\(username)").responseString { response in


        if let doc =  try? Kanna.HTML(html: response.result.value! , encoding: String.Encoding.utf8) {
            var commitList: [Int] = []
            var commitStatus = false

            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
                let commitCount = Int(day["data-count"]!)!
                let date = day["data-date"]!
                let  formattedDate = dateForatter.date(from: date)
               // let  convertedDate = dateFormatter.date(from: date)

                if commitCount == 0 {
                    commitStatus = false
                } else {
                    commitStatus = true
                }

                if day["data-date"]! == "\(year)-\(Int.doubleDigitConverter(number: month) )-\(Int.doubleDigitConverter(number: today))" {
                        print("Found the date!")
                        print(" Commit Count is \(Int(day["data-count"]!)!)")
                    //update hasCommited UserDefaults

                 //   CoreDataStack.saveNode(date: date2!, commitCount: commitCount, commitStatus: commitStatus)
                    break
                }
//                print("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")
//                print(" node date \(day["data-date"]!)")
//                print("---------")
//                print( "todays date \(year)-\(Int.doubleDigitConverter(number: month) )-\(Int.doubleDigitConverter(number: today))")
//                //CoreDataStack.saveNode(date: date2!, commitCount: commitCount, commitStatus: commitStatus)
//                print("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")
            }
            streak = Int.getStreak(commitList: commitList)



            }

    }
        return nodes
    }


    static func checkCommitStatus(completion: @escaping ReturnTodaysCommit ) {

        var nodes :[CalendarNode] = []
        var streak = 0
        guard let username = UserDefaults.standard.string(forKey: "username") else {return }
        var todaysDate:Date!
        todaysDate = Date()
        let calendar = Calendar.current

        let todaysComponents = calendar.dateComponents([.day, .month, .year], from: todaysDate)
        let today = todaysComponents.day!
        let month = todaysComponents.month!
        let year = todaysComponents.year!


        let dateForatter = DateFormatter()
        dateForatter.dateFormat = "yyyy-MM-dd"

        Alamofire.request("https://github.com/\(username)").responseString { response in


            if let doc =  try? Kanna.HTML(html: response.result.value! , encoding: String.Encoding.utf8) {
                var commitList: [Int] = []
                var commitStatus = false

                var states:[String:Int] = [:]
                for day in doc.css("rect[class^='day']") {
                    commitList += [Int(day["data-count"]!)!]
                    let commitCount = Int(day["data-count"]!)!
                    let date = day["data-date"]!

                    states[date] = commitCount
                    let  formattedDate = dateForatter.date(from: date)
                    // let  convertedDate = dateFormatter.date(from: date)

                    if commitCount == 0 {
                        commitStatus = false
                    } else {
                        commitStatus = true
                    }

                    if day["data-date"]! == "\(year)-\(Int.doubleDigitConverter(number: month) )-\(Int.doubleDigitConverter(number: today))" {
                        print("Found the date!")
                        print(" Commit Count is \(Int(day["data-count"]!)!)")
                        //update hasCommited UserDefaults
                        let node = CalendarNode(date: formattedDate!, commitStatus: commitStatus, commitCount: commitCount)
                        nodes.append(node)

                        //   CoreDataStack.saveNode(date: date2!, commitCount: commitCount, commitStatus: commitStatus)
                        break
                    }
                    let node = CalendarNode(date: formattedDate!, commitStatus: commitStatus, commitCount: commitCount)
                    nodes.append(node)
                }
                commitStatus = nodes[nodes.count - 1].commitStatus
                streak = Int.getStreak(commitList: commitList)
                UserDefaults.standard.set(commitStatus, forKey: DefaultStrings.hasCommited)
                UserDefaults.standard.set(streak, forKey: DefaultStrings.latestStreak)
               // print(states)
                completion(commitStatus, streak, nodes)



            }

        }

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

            streak = Int.getStreak(commitList: commitList)
    }
        return streak
}

}
