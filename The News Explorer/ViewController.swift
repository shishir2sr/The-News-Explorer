
import UIKit

class ViewController: UIViewController {
    var  articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "note working!!"
        DispatchQueue.global(qos: .background).async {
            
            NetworkManager.shared.getNews() { [weak self] result in
                switch result {
                case .success(let articles):
                    print(articles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    
}

