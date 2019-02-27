//
//  Constants.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/28/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation

struct Constants {
    //MARK:- Core data constants
    
    static let commitStatus = "commitStatus"
    static let date = "date"
    static let commitCount = "commitCount"

}

struct DefaultStrings {
    static let hasCommited = "hasCommited"
    static let latestStreak = "latestSteak"
    static let username = "username"
    static let lastCommitDate = "lastCommitDate"
}
struct NotificationName {
    static let internetErrorNote = NSNotification.Name("No Internet")
    static let loadDefaults = NSNotification.Name("loadDefaults")
}
struct UserKeys {
    static let streak = "streak"
    static let username = "username"
    static let profilePhoto = "profilePhoto"
    static let firstName = "firstName"
    static let lastName = "lastName"
}
struct CommitNodeKeys {
    static let date = "date"
    static let commitStatus = "commitStatus"
    static let commitCount = "commitCount"
}

struct EntityKeys {
    static let User = "User"
    static let CommitNode = "CommitNode"
}
