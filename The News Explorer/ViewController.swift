
import UIKit

class ViewController: UIViewController {
    var  articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "note working!!"
        DispatchQueue.global(qos: .background).async {
            
            NetworkManager.shared.getNews(for: Constants.categoryList[6].categoryName) { result in
                switch result {
                case .success(let articles):
                    print(articles[0].publishedAt.formatted(date: .abbreviated, time: .shortened))
                    print(articles[0].title)
                    print(articles[0].content!)
                    print(articles[0].description)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    
}

