//
//  DetailsVC.swift
//  The News Explorer
//
//  Created by bjit on 16/1/23.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var detailsViewImage: UIImageView!
    @IBOutlet weak var detailsVCTitle: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    
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
            
               }else if currentArticle is BookmarkedArticle {
                   let article = currentArticle as! BookmarkedArticle
                   detailsVCTitle.text = article.title
                   detailsViewImage.sd_setImage(with: URL(string: article.imageUrl ?? ""), placeholderImage: UIImage(named: Constants.placeholderImage))
                   publishedDate.text = article.publishedDate?.formatted(date: .abbreviated, time: .shortened)
                   content.text = article.content
                   author.text = article.author
                   categoryName.text = article.category
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
