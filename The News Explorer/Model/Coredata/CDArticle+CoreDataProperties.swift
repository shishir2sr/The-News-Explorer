//
//  CDArticle+CoreDataProperties.swift
//  The News Explorer
//
//  Created by bjit on 17/1/23.
//
//

import Foundation
import CoreData


extension CDArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArticle> {
        return NSFetchRequest<CDArticle>(entityName: "CDArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var newsUrl: String?
    @NSManaged public var publishedDate: Date?
    @NSManaged public var seourceName: String?
    @NSManaged public var title: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var category: CDCategory?

}

extension CDArticle : Identifiable {

}
