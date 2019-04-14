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
struct VCIdentifiers {

    static let LOGIN = "LOGIN"
    static let Home = "Home"
    static let Settings = "Settings"
    static let Test = "Test"
    static let PostVC = "PostVC"
    static let SIGNUP = "SIGNUP"
    static let SIGNINWEBVIEW = "SIGNINWEBVIEW"
    static let MainTabBar = "MainTabBar"
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

 struct SegueIdentifiers {
    static let toLoginConfirmation = "ToConfirmation"
    static let toAddAlarmVC = "addAlarm"
    static let toMainVC = "toMain"
    static let loginToMain = "LOGINTOMAIN"
    static let signupToMain = "SIGNUPTOMAIN"
    static let toSIGNUP = "toSIGNUP"
    static let SignUpToMain = "SignUpToMain"
    static let SettingsToLogin = "SettingsToLogin"
    static let LoginToSignup = "LoginToSignup"
}
struct FirebaseUserKeys {
    static let email = "email"
    static let firstName = "firstName"
    static let fullName = "fullName"
    static let provider = "provider"
    static let streak = "streak"
    static let username = "username"
}

struct URLIDs {

    static let githubSearchURL = URL(string: "https://api.github.com/search/users?q=")
    static let githubTokenRequest = URL(string:"https://github.com/login/oauth/authorize?client_id=\(APIConstants.client_id)")
}
