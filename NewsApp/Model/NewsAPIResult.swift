//
//  NewsAPIResult.swift
//  NewsApp
//
//  Created by Wass on 03/06/2023.
//

import Foundation

// Creation of Decodable struct for JSON deserialisation

struct NewsAPIResult: Decodable {
    
    var articles: [Article]?
}

struct Article: Decodable {
    
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Decodable {
    
    var name: String?
}

