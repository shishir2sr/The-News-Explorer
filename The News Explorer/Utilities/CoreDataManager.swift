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
    
    /**
     let articleURL = "https://example.com/article1"
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
     fetchRequest.predicate = NSPredicate(format: "url == %@", articleURL)

     do {
         let result = try context.fetch(fetchRequest)
         if result.count > 0 {
             // article already exists in bookmark table
         } else {
             // create a new bookmark object for the article
             let bookmark = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: context) as! Bookmark
             bookmark.url = articleURL
             // set other attributes
             try context.save()
         }
     } catch {
         print("Error fetching bookmark: \(error)")
     }
     */
    
    // MARK: Bookmark
    static func addBookmark(article: CDArticle, completion: @escaping (Result<String, CustomError>) -> Void) {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookmarkedArticle")
        fetchRequest.predicate = NSPredicate(format: "newsUrl == %@ AND sourceName == %@", article.newsUrl!, article.seourceName!)
        
        do{
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                // article already exists in bookmark table
                print("Article already exist in the bookmark table")
                completion(.failure(.bookmarkExist))
            } else {
                // create a new bookmark object for the article
                let bookmark = BookmarkedArticle(context: context)
                bookmark.sourceName = article.seourceName
                bookmark.author = article.author
                bookmark.title = article.title
                bookmark.descriptionText = article.descriptionText
                bookmark.newsUrl = article.newsUrl
                bookmark.publishedDate = article.publishedDate
                bookmark.content = article.content
                bookmark.imageUrl = article.imageUrl
                bookmark.category = article.category?.categoryName
                try context.save()
                completion(.success("Item added to bookmark list"))
            }
        }catch{
            print(error)
            completion(.failure(.bookmarkFailed))
        }
        
    }
    
    
    // MARK: Clear articles
//    static func clearArticles(categoryName: String) {
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDArticle")
//        fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@", categoryName)
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//            print("Articles deleted")
//        } catch let error as NSError {
//            print("Error: \(error)")
//        }
//    }
//    
    
    static func deleteAllArticles() {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDArticle")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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
