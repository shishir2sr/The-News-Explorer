//
//  CDCategory+CoreDataProperties.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 15/1/23.
//
//

import Foundation
import CoreData


extension CDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var articles: NSSet?

}

// MARK: Generated accessors for articles
extension CDCategory {

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: CDArticle)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: CDArticle)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSSet)

}

extension CDCategory : Identifiable {

}
