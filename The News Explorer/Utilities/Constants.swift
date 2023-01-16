//
//  Constants.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 14/1/23.
//

import Foundation
struct Constants{
    static let categoryList = ["Business", "Entertainment", "General", "Health", "Science", "Sports","Technology"]
    
    static let categoryModelList: [CategoryModel] = [
        CategoryModel(categoryName: "All", categoryIcon: "globe.asia.australia.fill"),
        CategoryModel(categoryName: "Business", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Entertainment", categoryIcon: "film"),
        CategoryModel(categoryName: "General", categoryIcon: "newspaper"),
        CategoryModel(categoryName: "Health", categoryIcon: "heart"),
        CategoryModel(categoryName: "Science", categoryIcon: "book.closed"),
        CategoryModel(categoryName: "Sports", categoryIcon: "figure.basketball"),
        CategoryModel(categoryName: "Technology", categoryIcon: "antenna.radiowaves.left.and.right")
        
        /**
         Health: "heart" or "person.crop.circle"
         Science: "flask" or "book.closed"
         Sports: "basketball" or "person.running"
         Technology: "computer" or "antenna.radiowaves.left.and.right"

         */
    ]
    
    static let categoryCVCell = "cvcell"
    static let homeTableViewCell = "cell"
    static let detailseSegue = "detailsview"
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
