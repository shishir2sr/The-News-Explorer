//
//  HomeTableViewCell.swift
//  The News Explorer
//
//  Created by bjit on 16/1/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsPublishedData: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        print("Star button")
        sender.setImage(UIImage(named: "star-filled"), for: .normal)
    }
    
    func setArticleWith(article: CDArticle){
        self.newsTitle.text = article.title
        self.newsSource.text = article.seourceName
        self.newsPublishedData.text = article.publishedDate?.formatted()
    }
    

}
