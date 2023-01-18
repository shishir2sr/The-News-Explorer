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
    
    var currentArticle: CDArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentArticle = currentArticle else{return}
        detailsVCTitle.text = currentArticle.title
        detailsViewImage.sd_setImage(with: URL(string: currentArticle.imageUrl ?? ""), placeholderImage: UIImage(named: Constants.placeholderImage))
        publishedDate.text = currentArticle.publishedDate?.formatted(date: .abbreviated, time: .shortened)
        content.text = currentArticle.content
        author.text = currentArticle.author
        categoryName.text = currentArticle.category?.categoryName
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
