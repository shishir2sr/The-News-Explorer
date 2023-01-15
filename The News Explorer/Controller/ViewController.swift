
import UIKit
import CoreData

class ViewController: UIViewController {
    var  articles: [Article] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit

        // Create a UIBarButtonItem using the image view
        let logoButton = UIBarButtonItem(customView: logoImageView)

        // Set the leftBarButtonItem of your navigation item
        self.navigationItem.titleView = logoImageView
        
        // Create a text field
//        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
//        textField.placeholder = "Search"
//        textField.textAlignment = .right
//        textField.borderStyle = .roundedRect
//
//        // Set the text field as the titleView of the navigation item
//        self.navigationItem.titleView = textField
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false


        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        self.navigationItem.rightBarButtonItem = searchButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // coreDataInit()
    }
    
    @objc func searchButtonTapped(){
        print("search button tapped")
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


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}


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
}
