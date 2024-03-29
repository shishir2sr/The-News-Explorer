//
//  BookmarkedArticle+CoreDataProperties.swift
//  The News Explorer
//
//  Created by bjit on 19/1/23.
//
//

import Foundation
import CoreData


extension BookmarkedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedArticle> {
        return NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var newsUrl: String?
    @NSManaged public var publishedDate: Date?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?

}

extension BookmarkedArticle : Identifiable {

}
