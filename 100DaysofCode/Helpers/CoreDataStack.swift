//
//  CoreDataStack.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/28/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    // MARK: - Core Data stack
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "100DaysofCode")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    static func saveNode(date:Date, commitCount:Int, commitStatus:Bool ) {
        var entity = NSEntityDescription.entity(forEntityName: "CommitNode", in: CoreDataStack.persistentContainer.viewContext)
        let nodeObject = NSManagedObject(entity: entity!, insertInto: CoreDataStack.persistentContainer.viewContext)

        nodeObject.setValue(date, forKey: CommitNodeKeys.date)
        nodeObject.setValue(commitCount, forKey: CommitNodeKeys.commitCount)
        nodeObject.setValue(commitStatus, forKey: CommitNodeKeys.commitStatus)
        print("Saved Node Detais: \n date:\(date) commitCount:\(commitCount) commitStatus: \(commitStatus)")
        CoreDataStack.saveContext()
    }
    static func saveNodes( nodes:[CommitNode]) {
        var entity = NSEntityDescription.entity(forEntityName: "CommitNode", in: CoreDataStack.persistentContainer.viewContext)
        let nodeObject = NSManagedObject(entity: entity!, insertInto: CoreDataStack.persistentContainer.viewContext)
        for node in nodes {
            nodeObject.setValue(node.date, forKey: CommitNodeKeys.date)
            nodeObject.setValue(node.commitCount, forKey: CommitNodeKeys.commitCount)
            nodeObject.setValue(node.commitStatus, forKey: CommitNodeKeys.commitStatus)
        }
        CoreDataStack.saveContext()
    }

    static func saveStreak(streak:Int) {
        getUser(completion: { returnedUser in
            returnedUser?.setValue(streak, forKey: UserKeys.streak)
        })
        CoreDataStack.saveContext()
    }
    

    static func getUser(completion: @escaping (User?) -> ())  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: EntityKeys.User)

        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                completion(result[0])
            }
        }
        catch {
            print(#function, "Could not get users")
        }
    }
    static func getUserProfilePhoto(completion: @escaping (UIImage) -> ())  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: EntityKeys.User)

        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                if let data = result[0].profilePhoto {
                    let image = UIImage(data: data)!
                    completion(image)
                }

            }
        }
        catch {
            print(#function, "Could not get users")
        }
    }
    static func getStreak(completion: @escaping (Int) -> ())  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: EntityKeys.User)

        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let streak = result[0].streak
                completion(Int(streak))
            }
        }
        catch {
            print(#function, "Could not get streak")
        }
    }
    static func getUsername(completion: @escaping (String) -> ())  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: EntityKeys.User)

        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                if let username = result[0].username {
                    completion(username)
                }

            }
        }
        catch {
            print(#function, "Could not get streak")
        }
    }
    
    static func returnNodeByDate( _ date:Date) -> CommitNode? {

        let context = self.persistentContainer.viewContext
        var node: CommitNode? = nil
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityKeys.CommitNode)
        let datePredicate = NSPredicate(format: "%K = %@", "date", date as CVarArg)
        print("given date: \(date)")
        request.predicate = datePredicate

        do {
            let  result = try  context.fetch(request) as! [CommitNode]
            if result.count != 0 {
                node = result[0]
                if let node = node {
                    print(node)
                }
            } else {
                print(#function, "failed to load todays node")
                //TODO:- handle error
            }
            // print(f[0])
        }
        catch {
            print(error.localizedDescription)
        }
        return node
    }
    static func returnSavedNodes() -> [CommitNode] {
        var nodes:[CommitNode] = []
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityKeys.CommitNode)
        do {
            let results = try context.fetch(request) as! [CommitNode]
            nodes = results
        } catch {
            print(error.localizedDescription)
        }
        return nodes
    }

    // MARK: - Core Data Deleting support
    static func deleteSavedNodes() {
        var nodes:[CommitNode] = []
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityKeys.CommitNode)
        do {
            let results = try context.fetch(request) as! [CommitNode]
            nodes = results
            for node in nodes {
                print(node)
                context.delete(node)
            }
            CoreDataStack.saveContext()

        } catch {
            print(error.localizedDescription)
        }
    }
    static func deleteNode(node:CommitNode) {
        let context = self.persistentContainer.viewContext
        context.delete(node)
        CoreDataStack.saveContext()

    }

    static func deleteSavedUsers() {
        var users:[User] = []
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityKeys.User)
        do {
            let results = try context.fetch(request) as! [User]
            users = results
            for user in users {
                print(user)
                context.delete(user)
            }
            CoreDataStack.saveContext()

        } catch {
            print(error.localizedDescription)
        }
    }
}
