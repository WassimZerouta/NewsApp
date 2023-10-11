//
//  CD_ArticleRepository.swift
//  NewsApp
//
//  Created by Wass on 13/04/2023.
//

import Foundation
import CoreData

final class CD_ArticleRepository {
    
    // MARK: - Properties

    private let coreDataStack: CoreDataStackProtocol

    // MARK: - Init

    init(coreDataStack: CoreDataStackProtocol) {
      self.coreDataStack = coreDataStack
    }

    // MARK: - Repository

    func getArticles(completion: ([CD_Article]) -> Void) {
        let request: NSFetchRequest<CD_Article> = CD_Article.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
          let articles = try coreDataStack.viewContext.fetch(request)
          completion(articles)
        } catch {
          completion([])
        }
    }

    func saveArticle(title: String, desc: String, url: String, urlToImage: String, isAdded: Bool, completion: () -> Void) -> CD_Article {
        
        let article = CD_Article(context: coreDataStack.viewContext)
        article.title = title
        article.desc = desc
        article.url = url
        article.urlToImage = urlToImage
        article.isAdded = isAdded
        do {
            try  coreDataStack.viewContext.save()
            completion()
        }
        catch {
            print("We are unable to save \(article.title ?? "the article")")
        }
        return article
    }
    
    func removeArticles(article: CD_Article, completion: () -> Void) {
        coreDataStack.viewContext.delete(article)
        do {
            try  coreDataStack.viewContext.save()
            completion()
        }
        catch {
            print("We are unable to remove the article")
        }
    }
    
}
