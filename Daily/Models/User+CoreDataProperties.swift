//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vicente Cantu Garcia on 24/10/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var userName: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var moments: NSSet?

}

// MARK: Generated accessors for moments
extension User {

    @objc(addMomentsObject:)
    @NSManaged public func addToMoments(_ value: Moment)

    @objc(removeMomentsObject:)
    @NSManaged public func removeFromMoments(_ value: Moment)

    @objc(addMoments:)
    @NSManaged public func addToMoments(_ values: NSSet)

    @objc(removeMoments:)
    @NSManaged public func removeFromMoments(_ values: NSSet)

}
