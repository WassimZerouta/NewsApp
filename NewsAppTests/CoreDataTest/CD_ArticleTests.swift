//
//  CD_ArticleTests.swift
//  NewsAppTests
//
//  Created by Wass on 10/10/2023.
//

import XCTest
import CoreData
@testable import NewsApp

final class CD_ArticleTests: XCTestCase {

    let coreDataStack = TestCoreDataStack.shared
    let repository = CD_ArticleRepository(coreDataStack: TestCoreDataStack.shared)
    
    override func tearDown() {

        let context = coreDataStack.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CD_Article.fetchRequest()
        
        let removeAll = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(removeAll)
            
            try context.save()
        } catch {
            print("Erreur : \(error)")
        }
        super.tearDown()
    }
    
    
    func testSaveArticle() {
        
        
        _ = repository.saveArticle(title: "", desc: "", url: "", urlToImage: "", isAdded: true) {
            print("saved")
        }
        
        repository.getArticles { articles in
            XCTAssertEqual(articles.count, 1)
        }
        

    }
    
    func testRemoveArticles() {
        let firstArticle = repository.saveArticle(title: "First article", desc: "", url: "", urlToImage: "", isAdded: true) {
            print("saved")
        }
        
        _ = repository.saveArticle(title: "Second article", desc: "", url: "", urlToImage: "", isAdded: true) {
            print("saved")
        }


        repository.removeArticles(article: firstArticle) {
            print("article removed")
        }
        
        repository.getArticles { recipes in
            XCTAssertEqual(recipes.count, 1)
        }
        
    }
    
    func testGetArticles() {
        _ = repository.saveArticle(title: "First article", desc: "", url: "", urlToImage: "", isAdded: true) {
            print("saved")
        }
        
        _ = repository.saveArticle(title: "Second article", desc: "", url: "", urlToImage: "", isAdded: true) {
            print("saved")
        }
        
        repository.getArticles { recipes in
            print(recipes)
            XCTAssertEqual(recipes.count, 2)
        }
        
    }
}
