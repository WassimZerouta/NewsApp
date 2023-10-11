//
//  CD_FavoriteSubjectTests.swift
//  NewsAppTests
//
//  Created by Wass on 11/10/2023.
//

import XCTest
import CoreData
@testable import NewsApp


final class CD_FavoriteSubjectTests: XCTestCase {

    let coreDataStack = TestCoreDataStack.shared
    let repository = CD_FavoriteSubjectRepository(coreDataStack: TestCoreDataStack.shared)
    
    override func tearDown() {

        let context = coreDataStack.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CD_FavoriteSubject.fetchRequest()
        
        let removeAll = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(removeAll)
            
            try context.save()
        } catch {
            print("Erreur : \(error)")
        }
        super.tearDown()
    }
    
    
    func testSaveFavoriteSubject() {
        
        
        _ = repository.saveFavoriteSubject(name: "Sport", isAdded: true) {
            print("Is saved")
        }
        
        _ = repository.saveFavoriteSubject(name: "Music", isAdded: true) {
            print("Is saved")
        }
        
        repository.getFavoriteSubject { articles in
            XCTAssertEqual(articles.count, 2)
        }
        

    }
    
    func testRemoveArticles() {
        let firstFavortiteSubject = repository.saveFavoriteSubject(name: "Sport", isAdded: true) {
            print("saved")
        }
        
        _ = repository.saveFavoriteSubject(name: "Music", isAdded: true) {
            print("saved")
        }


        repository.removeFavoriteSubject(favoriteSubject: firstFavortiteSubject) {
            print("article removed")
        }
        
        repository.getFavoriteSubject { recipes in
            XCTAssertEqual(recipes.count, 1)
        }
        
    }
    
    func testGetArticles() {
        _ = repository.saveFavoriteSubject(name: "Sport", isAdded: true) {
            print("saved")
        }
        
        _ = repository.saveFavoriteSubject(name: "Music", isAdded: true) {
            print("saved")
        }
        
        repository.getFavoriteSubject { recipes in
            print(recipes)
            XCTAssertEqual(recipes.count, 2)
        }
        
    }

}
