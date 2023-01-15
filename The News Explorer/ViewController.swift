
import UIKit
import CoreData

class ViewController: UIViewController {
    var  articles: [Article] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "The News Explorer"
        tableView.delegate = self
        tableView.dataSource = self

        DispatchQueue.global(qos: .background).async {
            addCategories()
            for ct in Constants.categoryList{
                DispatchQueue.global().sync {
                    
                    NetworkManager.shared.getNews(for: ct.categoryName) { result in
                        switch result {
                        case .success(let articles):
                            createArticleEntityFrom(articles: articles, categoryName: ct.categoryName)
                            
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
        category.categoryName = ct.categoryName
        do {
            try context.save()
            print("\(ct.categoryName) created")
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
