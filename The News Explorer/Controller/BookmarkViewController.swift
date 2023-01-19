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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchField.delegate = self
        
        searchField.layer.cornerRadius = 8
        searchField.layer.borderWidth = 0.5
        searchField.layer.borderColor = UIColor.darkGray.cgColor
        refreshCoreData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == Constants.segueBookmarkToDtails {
              let destinationVC = segue.destination as! DetailsVC

                  destinationVC.currentArticle = selectedBookmarkArticle
              
          }
      }
    
    
    
    
    
    // MARK: Show Alert
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: "ok", style: .default) {[weak self] (action) in
            guard let self = self else{return}
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    
    
    func searchNews(For searchText: String){
        fetchedhResultController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
           refreshCoreData()
        }
    
    
    // MARK: categorywise sorting
    fileprivate func selectItemFromCategories(_ indexPath: IndexPath) {
       
        do{
            let categoryName = Constants.categoryList[indexPath.row]
            fetchedhResultController.fetchRequest.predicate = NSPredicate(format: "category == %@", categoryName)
            try fetchedhResultController.performFetch()
            
        }catch{
            print(error.localizedDescription)
        }
        tableView.reloadData()
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


// MARK: - Tableview delegate and data source
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let article = fetchedhResultController.object(at: indexPath) as! BookmarkedArticle
                CoreDataStack.sharedInstance.persistentContainer.viewContext.delete(article)
                CoreDataStack.sharedInstance.saveContext()
                refreshCoreData()
            }
        }
    
}


extension BookmarkedArticle: NSFetchedResultsControllerDelegate{
    
}


// MARK: - Collectionview delegate and datasource
extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.categoryList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.bookmarkCVCell, for: indexPath) as! BookmarkCollectionViewCell
        cell.categoryLabel.text = Constants.categoryList[indexPath.row]
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 8
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = Constants.categoryList
        categoryName.text = category[indexPath.row]
        selectItemFromCategories(indexPath)
        tableView.reloadData()
        
    }
    
}


// MARK: - Textfield Delegate

extension BookmarkViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!)
        searchNews(For: searchField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Write something"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchField.text != ""{
            self.searchNews(For: textField.text!)
        }
        self.searchNews(For: textField.text!)
        searchField.text = ""
        
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text != ""{
            searchNews(For: text)
            categoryName.text = "Search Result"
        }
        refreshCoreData()
        categoryName.text = "Search Result"
        return true
    }
    
}
