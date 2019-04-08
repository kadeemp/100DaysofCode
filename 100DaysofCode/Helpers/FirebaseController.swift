//
//  FirebaseController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/4/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import Firebase



let DB_BASE = Database.database().reference()

class FirebaseController {

    static let instance = FirebaseController()

    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_STREAKS = DB_BASE.child("streaks")

    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }

    var REF_USERS:DatabaseReference {
        return _REF_USERS
    }

    var REF_STREAKS:DatabaseReference {
        return _REF_STREAKS
    }
    func createDBUser(uid:String, userData:Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }

    func updateStreak(streak:Int) {
        // Auth.auth().sign
        REF_STREAKS.child(String(Auth.auth().currentUser!.uid)).updateChildValues(["streak" : streak])
    }

    func registerUser(firstName:String, lastName:String, username:String, completion: @escaping (_ status:Bool,_ error:Error?) -> ()) {

            guard let user = Auth.auth().currentUser else {
                print("user not signed in")
                return }
            let userData = ["provider":user.providerID , "email":user.email!, "firstName": firstName, "fullName": user.displayName, "username":username, "streak": 0  ] as [String : Any]
            self.updateStreak(streak: 0)
            FirebaseController.instance.createDBUser(uid: user.uid, userData: userData)
            completion(true, nil)

    }

    func loginUser(withEmail email:String, andPassword password:String, completion: @escaping (_ status:Bool,_ error:Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    func searchEmails(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()

        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as? String

                if ((email?.contains(query))!||((email?.capitalized.contains(query)))!) == true  {
                    emailArray.append(email!)
                }
            }
            handler(emailArray)
        }
    }
    func isDuplicateEmail(_ emailString:String) -> Bool {
        var result:Bool = false

        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as? String
                print(emailString, "\n" , email! , "\n", "-------------_")

                if email?.capitalized == emailString.capitalized  {
                    result = true

                }
            }
        }
        return result
    }
}


