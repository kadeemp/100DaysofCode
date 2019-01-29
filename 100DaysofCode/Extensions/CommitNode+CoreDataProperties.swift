//
//  CommitNode+CoreDataProperties.swift
//  
//
//  Created by Kadeem Palacios on 1/28/19.
//
//

import Foundation
import CoreData


extension CommitNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommitNode> {
        return NSFetchRequest<CommitNode>(entityName: "CommitNode")
    }

    @NSManaged public var commitCount: Int32
    @NSManaged public var commitStatus: Bool
    @NSManaged public var date: NSDate?

}
