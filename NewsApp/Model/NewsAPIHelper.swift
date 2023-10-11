//
//  NewsAPIHelper.swift
//  NewsApp
//
//  Created by Wass on 03/06/2023.
//

import Foundation
import Alamofire

protocol APIHelper {
    func performRequest(q: String, completion: @escaping (Bool, [Article]?) -> Void)
}

class NewsAPIHelper: APIHelper {
    
    static let shared = NewsAPIHelper()
    
        
    let baseURL = "https://newsapi.org/v2/everything?apiKey=10206633f4524d4a8636d39049e726a6&q="
    
    
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
                        print(result)
                        completion( true, result.articles)
                        
                    case .failure(let error):
                                print(error)
                        
                    }
                }
        }
    
    }
}


class NewsAPIHelperMock: NewsAPIHelper {

    var performRequestCalled = false
    var performRequestQArgument: String?
    var performRequestCompletionArgument: ((Bool, [Article]?) -> Void)?
    var fakeResponseData: Data
    
    init(fakeResponseData: Data) {
        self.fakeResponseData = fakeResponseData
    }
    
    override func performRequest(q: String, completion: @escaping (Bool, [Article]?) -> Void) {
        performRequestCalled = true
        performRequestQArgument = q
        performRequestCompletionArgument = completion
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(NewsAPIResult.self, from: fakeResponseData)
            completion(true, result.articles)
        } catch {
            completion(false, nil)
            print(error)
        }
    }
}


class MockNewsAPIHelper: APIHelper {
    func performRequest(q: String, completion: @escaping (Bool, [Article]?) -> Void) {
        let response = [Article(source: Source(name: "Lifehacker.com"), author: "Jake Peterson", title: "Customizable Sports in Apple News, and Everything Else in iOS 16.5", description: "Apple is likely to announce iOS 17 next month, including previously-announced accessibility upgrades like the ability to add your own voice to your iPhone. It’s only May though, so we need to wait a bit longer for Apple’s next big update. Until then, we can d…", url: "https://lifehacker.com/customizable-sports-in-apple-news-and-everything-else-1850450440", publishedAt: "2023-05-18T18:30:00Z", content: "Apple is likely to announce iOS 17 next month, including previously-announced accessibility upgrades like the ability to add your own voice to your iPhone. Its only May though, so we need to wait a b… [+2609 chars]"),
            Article(source: Source(name: "Lifehacker.com"), author: "Jake Peterson", title: "You Can Finally Use Final Cut Pro and Logic Pro on Your iPad", description: "Every once in a while, Apple really surprises me. Today is one of those times: The company just announced is finally bringing Final Cut Pro and Logic Pro to the iPad, and with it, the tools to produce professional videos and music using a touch-screen device.…", url: "https://lifehacker.com/you-can-finally-use-final-cut-pro-and-logic-pro-on-your-1850418917", publishedAt: "2023-05-09T19:00:00Z", content: "Every once in a while, Apple really surprises me. Today is one of those times: The company just announced is finally bringing Final Cut Pro and Logic Pro to the iPad, and with it, the tools to produc… [+5141 chars]")
        ]
        completion(true, response)
    }
}
