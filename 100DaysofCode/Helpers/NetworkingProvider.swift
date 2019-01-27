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
//import Core Data

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


    static func parseStreakFromHTML(html: String) -> Int {
        var streak = 0


        if let doc =  try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            print(html)
            var commitList: [Int] = []


            for day in doc.css("rect[class^='day']") {
                commitList += [Int(day["data-count"]!)!]
            }
            print(commitList)
            if commitList[ commitList.count - 1] == 0 {
                UserDefaults.standard.set(false, forKey: "hasCommited")
            } else  {
                UserDefaults.standard.set(true, forKey: "hasCommited")
            }
         //   commitList.remove(at: commitList.count - 1)
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
