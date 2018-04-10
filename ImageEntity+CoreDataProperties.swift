//
//  ImageEntity+CoreDataProperties.swift
//  
//
//  Created by Darya Markova on 09.04.2018.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var url: String?
    @NSManaged public var tweet: TweetEntity?
}
