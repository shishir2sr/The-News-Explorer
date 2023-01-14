//
//  NetworkManager.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 14/1/23.
//

import Foundation
class NetworkManager: NSObject {
    
    private override init() {}
    
    static let shared = NetworkManager()
    
    let newsUrl =  "https://newsapi.org/v2/top-headlines?apiKey=d5f4c3ef5deb4b68a286c9e0092bc3ce&category=$query"
    
    
    func getNews(for category: String, completed: @escaping (Result<[Article], CustomError>) -> Void) {
        
        let urlString = newsUrl
            .replacingOccurrences(of: "$query", with: category)
            .replacingOccurrences(of: " ", with: "%20")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard
            let url = URL(string: urlString)
        else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard
                let data = data
            else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(NewsModel.self, from: data)
//                print(decodedResponse)
                completed(.success(decodedResponse.articles))
                
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
    
    /**
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard
            let url = URL(string: posterImageBaseUrl + urlString)
        else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                completed(nil)
                return
            }
            
            self?.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
     */
