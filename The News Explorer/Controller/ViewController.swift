
import UIKit
import CoreData

class ViewController: UIViewController {
    var  articles: [Article] = []
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CDArticle.self))
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            return frc
        }()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        try? fetchedhResultController.performFetch()
//        coreDataInit()
        

    }
    
}


// MARK: CoreData Init()
fileprivate func coreDataInit() {
    DispatchQueue.global(qos: .background).async {
        addCategories()
        for ct in Constants.categoryList{
            DispatchQueue.global().sync {
                
                NetworkManager.shared.getNews(for: ct) { result in
                    switch result {
                    case .success(let articles):
                        createArticleEntityFrom(articles: articles, categoryName: ct)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
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
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
                    return count
                }
                return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let article = fetchedhResultController.object(at: indexPath) as! CDArticle
        cell.newsTitle.text = article.title
        cell.newsSource.text = article.seourceName
        cell.newsPublishedData.text = article.publishedDate?.formatted()
        return cell
    }
    
    
    
}


//MARK: - Collectionview Delegate and Data source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.categoryModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = Constants.categoryModelList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCVCell, for: indexPath) as! CategoryCollectionVC
        
        cell.categoryImageView.image = UIImage(systemName: category.categoryIcon)
        cell.categoryLabel.text = category.categoryName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}

//MARK:- NS Fetch Request Controller delegate
extension ViewController: NSFetchedResultsControllerDelegate{
    
}
