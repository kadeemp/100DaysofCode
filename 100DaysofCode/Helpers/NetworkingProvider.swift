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
    


    static func returnNodesFromHTML(html: String) -> [CommitNode] {

        var nodes :[CommitNode] = []
        guard let username = UserDefaults.standard.string(forKey: "username") else {return nodes}
        var entity = NSEntityDescription.entity(forEntityName: "CommitNode", in: CoreDataStack.persistentContainer.viewContext)

         Alamofire.request("https://github.com/\(username)").responseString { response in


        if let doc =  try? Kanna.HTML(html: response.result.value! , encoding: String.Encoding.utf8) {
            var commitList: [Int] = []
            var commitStatus = false


            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
                var commitCount = Int(day["data-count"]!)!
                var date = day["data-date"]!

                if commitCount == 0 {
                    commitStatus = false
                } else {
                    commitStatus = true
                }
                let dateForatter = DateFormatter()
                dateForatter.dateFormat = "yyyy-MM-dd"
                var  date2 = dateForatter.date(from: date)
                let node = CommitNode(context: CoreDataStack.persistentContainer.viewContext)
                
                node.setValue(date2!, forKey: "date")
                node.setValue(commitCount, forKey: "commitCount")
                node.setValue(commitStatus, forKey: "commitStatus")

                nodes.append(node)

            }
            }

    }
        return nodes
    }
    static func parseStreakFromHTML(html: String) -> Int {
        var streak = 0
        if let doc =  try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            var commitList: [Int] = []
            var commitStatus = false

            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
                  var date = day["data-date"]!
                print(date)
            }
            if commitList[ commitList.count - 1] == 0 {
                UserDefaults.standard.set(false, forKey: "hasCommited")
            } else  {
                UserDefaults.standard.set(true, forKey: "hasCommited")
            }
            commitList = commitList.reversed()

            if ((commitList[0] == 0) && (commitList[1] != 0)) {
                commitList.remove(at: 0)

            }

            for day in commitList {
                if day != 0 {
                    streak += 1
                } else {
                    break
                }
            }
        }
        return streak
    }
}
