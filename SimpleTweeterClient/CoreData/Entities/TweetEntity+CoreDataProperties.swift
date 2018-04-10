//
//  TweetEntity+CoreDataProperties.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 09.04.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//
//

import Foundation
import CoreData


extension TweetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetEntity> {
        return NSFetchRequest<TweetEntity>(entityName: "TweetEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var favourite_count: Int32
    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension TweetEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
