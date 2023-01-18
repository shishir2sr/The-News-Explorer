//
//  CoreDataManager.swift
//  The News Explorer
//
//  Created by bjit on 17/1/23.
//

import Foundation
import CoreData

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
    
    
    // MARK: Clear articles
    func clearArticles() {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    
    
    
    //MARK: create Article
    static func createArticleEntityFrom(articles: [Article], categoryName: String){
        
       let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
       
       for article in articles {
           let cdArticle = CDArticle(context: context)
           cdArticle.seourceName = article.source.name
           cdArticle.author = article.author
           cdArticle.title = article.title
           cdArticle.descriptionText = article.description
           cdArticle.newsUrl = article.url
           cdArticle.publishedDate = article.publishedAt
           cdArticle.content = article.content
           cdArticle.imageUrl = article.urlToImage
           
           let fetchRequest = NSFetchRequest<CDCategory>(entityName: "CDCategory")
           fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
           
           do {
               let category = try context.fetch(fetchRequest).first
               category?.articles?.adding(cdArticle)
               cdArticle.category = category
               try context.save()
               print("\(categoryName) items added")
           }catch{
               print(error.localizedDescription)
           }
           
           
       }
       
   }

    
}
