//
//  BookmarkViewController.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 15/1/23.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedBookmarkArticle: BookmarkedArticle?
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookmarkedArticle.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: true)]
        fetchRequest.fetchBatchSize = 10
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        refreshCoreData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == Constants.segueBookmarkToDtails {
              let destinationVC = segue.destination as! DetailsVC

                  destinationVC.currentArticle = selectedBookmarkArticle
              
          }
      }
    
    
    fileprivate func refreshCoreData() {
        do {
            try self.fetchedhResultController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
        self.tableView.reloadData()
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeTableViewCell, for: indexPath) as! HomeTableViewCell
        
        let article = fetchedhResultController.object(at: indexPath) as! BookmarkedArticle
        cell.newsTitle.text = article.title
        cell.newsSource.text = article.sourceName
        cell.newsPublishedData.text = article.publishedDate?.formatted(date: .omitted, time: .shortened)
        cell.newsImage.sd_setImage(with: URL(string: article.imageUrl ?? "" ), placeholderImage: UIImage(named: "placeholder"))
        cell.newsImage.layer.cornerRadius = 8
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedBookmarkArticle =  fetchedhResultController.object(at: indexPath) as? BookmarkedArticle
        performSegue(withIdentifier: Constants.segueBookmarkToDtails, sender: self)
        
    }
    
    
}


extension BookmarkedArticle: NSFetchedResultsControllerDelegate{
    
}
