//
//  DetailsVC.swift
//  The News Explorer
//
//  Created by bjit on 16/1/23.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {

    @IBOutlet weak var detailsViewImage: UIImageView!
    @IBOutlet weak var detailsVCTitle: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var bookmarkButtonOutlet: UIButton!
    
    var currentArticle: AnyObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentArticle = currentArticle else{return}

        
        if currentArticle is CDArticle {
                   let article = currentArticle as! CDArticle
                   detailsVCTitle.text = article.title
                   detailsViewImage.sd_setImage(with: URL(string: article.imageUrl ?? ""), placeholderImage: UIImage(named: Constants.placeholderImage))
                   publishedDate.text = article.publishedDate?.formatted(date: .abbreviated, time: .shortened)
                   content.text = article.content
                   author.text = article.author
                   categoryName.text = article.category?.categoryName
                    
            if isIsBookmarked(article: article){
                bookmarkButtonOutlet.imageView?.image = UIImage(systemName: "bookmark.fill")
            }else{
                bookmarkButtonOutlet.imageView?.image = UIImage(systemName: "bookmark")
            }
            
               }else if currentArticle is BookmarkedArticle {
                   let article = currentArticle as! BookmarkedArticle
                   detailsVCTitle.text = article.title
                   detailsViewImage.sd_setImage(with: URL(string: article.imageUrl ?? ""), placeholderImage: UIImage(named: Constants.placeholderImage))
                   publishedDate.text = article.publishedDate?.formatted(date: .abbreviated, time: .shortened)
                   content.text = article.content
                   author.text = article.author
                   categoryName.text = article.category
                   
                   bookmarkButtonOutlet.isUserInteractionEnabled = false
                   bookmarkButtonOutlet.alpha = 0
                   
               }
        
    }
    
    func isIsBookmarked(article: CDArticle)-> Bool{
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookmarkedArticle")
        fetchRequest.predicate = NSPredicate(format: "newsUrl == %@ AND sourceName == %@", article.newsUrl!, article.seourceName!)
        
        do{
            let result = try context.fetch(fetchRequest)
            if result.count > 0{
                return true
                
            }else{
               return false
            }
            
        }catch{
            return false
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if currentArticle is CDArticle{
            if isIsBookmarked(article: currentArticle as! CDArticle){
                
            }else{
                CoreDataManager.addBookmark(article: (currentArticle as! CDArticle)){result in
                    switch result{
                    case .success(_):
                        print("Bookmarked")
                    case .failure(_):
                        print("failed to bookmark")
                    }
                    
                }
            }
        }
            
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.webkitSegue {
               let safariVC = segue.destination as! WebKitViewController
            safariVC.newsUrl = currentArticle.newsUrl
           }
       }
    
    
    @IBAction func continueReading(_ sender: UIButton) {
        
    }

}
