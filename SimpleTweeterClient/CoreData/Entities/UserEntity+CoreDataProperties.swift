//
//  UserEntity+CoreDataProperties.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 17.04.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var created_at: NSDate?
    @NSManaged public var followers_count: Int
    @NSManaged public var friends_count: Int
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var screen_name: String
}
