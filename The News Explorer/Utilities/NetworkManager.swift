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
    let newsUrl =  "https://newsapi.org/v2/top-headlines?apiKey=d5f4c3ef5deb4b68a286c9e0092bc3ce&category=$query&country=us"
    
    // MARK: Fetch news
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
                
                DispatchQueue.main.async {
                    completed(.success(decodedResponse.articles))
                }
  
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
}





