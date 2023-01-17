//
//  CoreDataManager.swift
//  The News Explorer
//
//  Created by bjit on 17/1/23.
//

import Foundation

class CoreDataManager{
    //MARK: Add categories
    static func addCategories() {
        for ct in Constants.categoryList{
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let category = CDCategory(context: context)
            category.categoryName = ct
            do {
                try context.save()
                print("\(ct) created")
            } catch {
                print(error)
                print("Category already exist")
            }
        }
    }
    
}
