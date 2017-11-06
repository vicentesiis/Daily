//
//  Moment+CoreDataProperties.swift
//  
//
//  Created by Vicente Cantu Garcia on 26/10/17.
//
//

import Foundation
import CoreData


extension Moment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Moment> {
        return NSFetchRequest<Moment>(entityName: "Moment")
    }

    @NSManaged public var text: String?
    @NSManaged public var image: NSData?
    @NSManaged public var date: NSDate?
    @NSManaged public var user: User?

}
