//
//  Constants.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 14/1/23.
//

import Foundation
struct Constants{
    static let categoryList: [CategoryModel] = [
        CategoryModel(categoryName: "Business", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Entertainment", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "General", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Health", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Science", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Sports", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Technology", categoryIcon: "briefcase")
    ]
}
/**
 Business: "briefcase"
 Entertainment: "film" or "tv"
 General: "globe" or "newspaper"
 Health: "heart" or "person.crop.circle"
 Science: "flask" or "book.closed"
 Sports: "basketball" or "person.running"
 Technology: "computer" or "antenna.radiowaves.left.and.right"

 */
