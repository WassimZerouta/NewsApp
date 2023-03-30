//
//  NewsAPIHelper.swift
//  NewsApp
//
//  Created by Wass on 30/03/2023.
//

import Foundation
import Alamofire

class NewsAPIHelper {
    
    static let shared = NewsAPIHelper()
    
    private var session = URLSession(configuration: .default)
    
    let baseURL = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=10206633f4524d4a8636d39049e726a6"
    
    
    func getUrl(q: String) -> String? {
        let baseUrl = baseURL
        let urlString = baseUrl + q
     
        return urlString
    }
    
    func performRequest(q: String, completion: @escaping (Bool, [Article]?) -> Void) {
        if let urlString = getUrl(q: q) {
            _ = AF.request(urlString)
                .responseDecodable(of: NewsAPIResult.self) { response in
                    switch response.result {
                    case .success(_):
                        guard let result = response.value else { return }
                        completion( true, result.articles)
                        
                    case .failure(let error):
                                print(error)
                        
                    }
                }
        }
    
    }
}
