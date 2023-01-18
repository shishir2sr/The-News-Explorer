//
//  BookmarkViewController.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 15/1/23.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    

}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeTableViewCell, for: indexPath) as! HomeTableViewCell
        cell.newsTitle.text = "Nothing"
        cell.newsImage.image = UIImage(named: "placeholder")
        return cell
    }
    
    
}
