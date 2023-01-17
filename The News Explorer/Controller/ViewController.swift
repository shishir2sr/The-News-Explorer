
import UIKit
import CoreData
import SDWebImage

class ViewController: UIViewController {
    
    var  articles: [Article] = []
    var isLoading = false
    
    
    // MARK: FetchedResultController
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CDArticle.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: true)]
        fetchRequest.fetchBatchSize = 10
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: ViewDidLoad method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLaunch()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: First launch
    fileprivate func firstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        print(hasLaunchedBefore)
        
        if !hasLaunchedBefore {
            CoreDataManager.addCategories()
            coreDataInit(){
                self.refreshCoreData()
            }
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            
        } else{
            refreshCoreData()
        }
    }
    
    
    // MARK: Refresh coredata
    fileprivate func refreshCoreData() {
        self.isLoading = false
        do {
            try self.fetchedhResultController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // reload table data
    
    //    func reloadTableData(collectionViewIndexPath: Int) {
    //        self.collectionVCIndexPath = collectionViewIndexPath
    //        do {
    //            try self.fetchedhResultController.performFetch()
    //        } catch {
    //            print("Error fetching data: \(error)")
    //        }
    //        self.tableView.reloadData()
    //    }
    //
    
    
    // MARK: CoreData Init()
    func coreDataInit(completion: @escaping  ()->Void) {
        isLoading = true
        DispatchQueue.global(qos: .background).async {
            for ct in Constants.categoryList{
                DispatchQueue.global().async {
                    NetworkManager.shared.getNews(for: ct) { result in
                        switch result {
                        case .success(let articles):
                            createArticleEntityFrom(articles: articles, categoryName: ct)
                            completion()
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
            }
        }
    }
    
}

//MARK: Create Categories
func addCategories() {
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

//MARK: Create Articles
private func createArticleEntityFrom(articles: [Article], categoryName: String){
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


//MARK: - Tableview delegate and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isLoading{
            if let count = fetchedhResultController.sections?.first?.numberOfObjects {
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        if !isLoading{
            let article = fetchedhResultController.object(at: indexPath) as! CDArticle
            
            cell.newsTitle.text = article.title
            cell.newsSource.text = article.seourceName
            cell.newsPublishedData.text = article.publishedDate?.formatted()
            cell.newsImage.sd_setImage(with: URL(string: article.imageUrl ?? "" ), placeholderImage: UIImage(named: "placeholder"))
            return cell
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: - Collectionview Delegate and Data source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MARK: Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.categoryModelList.count
    }
    
    //MARK: Cell for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = Constants.categoryModelList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCVCell, for: indexPath) as! CategoryCollectionVC
        
        cell.categoryImageView.image = UIImage(systemName: category.categoryIcon)
        cell.categoryLabel.text = category.categoryName
        return cell
    }
    
    // MARK: DidSelectItem At
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCVCell, for: indexPath) as! CategoryCollectionVC
        
        print(indexPath.row)
        isLoading = false
        
        do{
     
            if indexPath.row > 0{
                let categoryName = Constants.categoryModelList[indexPath.row].categoryName
                fetchedhResultController.fetchRequest.predicate = NSPredicate(format: "category.categoryName == %@", categoryName)
                try fetchedhResultController.performFetch()
                
            }else{
                fetchedhResultController.fetchRequest.predicate = nil
                try fetchedhResultController.performFetch()
            }
            
            
        }catch{
            print(error.localizedDescription)
        }
        tableView.reloadData()
        
    }
}

//MARK:- NS Fetch Request Controller delegate
extension ViewController: NSFetchedResultsControllerDelegate{
    
}
