//
//  Constants.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 14/1/23.
//

import Foundation
struct Constants{
    static let categoryList = ["Business", "Entertainment", "General", "Health", "Science", "Sports","Technology"]
    static let categoryCVCell = "cvcell"
    static let homeTableViewCell = "cell"
    static let detailseSegue = "detailsview"
    static let placeholderImage = "placeholder"
    static let webkitSegue = "webkit"
    static let segueBookmarkToDtails = "bookmartToDetails"
    static let bookmarkCVCell = "bcategorycollectionviewcell"
    
    static let apikey = ["4396288b402d4d2f92d9e4982980678e",
                         "e7f8e02bc02d4ef2a0c3e53a09c9e3b5",
                        "e002407d8d544c5bafa878ce1367aec3",
                         "861dc77bcf9a48b1b92ca4197c11c7f3"]
    
    
    static let categoryModelList: [CategoryModel] = [
        CategoryModel(categoryName: "All", categoryIcon: "globe.asia.australia.fill"),
        CategoryModel(categoryName: "Business", categoryIcon: "briefcase"),
        CategoryModel(categoryName: "Entertainment", categoryIcon: "film"),
        CategoryModel(categoryName: "General", categoryIcon: "newspaper"),
        CategoryModel(categoryName: "Health", categoryIcon: "heart"),
        CategoryModel(categoryName: "Science", categoryIcon: "book.closed"),
        CategoryModel(categoryName: "Sports", categoryIcon: "figure.basketball"),
        CategoryModel(categoryName: "Technology", categoryIcon: "antenna.radiowaves.left.and.right")
        
        
    ]
    
    
}

