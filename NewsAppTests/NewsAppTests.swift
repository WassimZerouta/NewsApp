//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Wass on 03/06/2023.
//

import XCTest
@testable import NewsApp

final class NewsAppTests: XCTestCase {

    func testPerformRequestWithMock() {
        // Créer une instance de mock avec les données de réponse réussie
        let fakeResponseData = FakeResponseData()
        let mockHelper = NewsAPIHelperMock(fakeResponseData: fakeResponseData.successData!)
        
        // Appeler la méthode performRequest avec le mock
        mockHelper.performRequest(q: "apple") { success, articles in
            // Vérifier que la méthode performRequest du mock a été appelée
            XCTAssertTrue(mockHelper.performRequestCalled)
            
            // Vérifier que les paramètres de l'appel sont corrects
            XCTAssertEqual(mockHelper.performRequestQArgument, "apple")
            
            // Vérifier que la réponse contient des articles fictifs
            XCTAssertNotNil(articles)
            XCTAssertEqual(articles?.count, 2) // Vérifier le nombre d'articles
            
            // Vérifier le contenu des articles si nécessaire
            
            // Vérifier que la complétion a été appelée avec succès
            XCTAssertTrue(success)
        }
    }

    func testPerformRequestWithMockFailure() {
        // Créer une instance de mock avec les données de réponse en erreur
        let fakeResponseData = FakeResponseData()
        let mockHelper = NewsAPIHelperMock(fakeResponseData: fakeResponseData.errorData!)
        
        // Appeler la méthode performRequest avec le mock
        mockHelper.performRequest(q: "apple") { success, articles in
            // Vérifier que la méthode performRequest du mock a été appelée
            XCTAssertTrue(mockHelper.performRequestCalled)
            
            // Vérifier que les paramètres de l'appel sont corrects
            XCTAssertEqual(mockHelper.performRequestQArgument, "apple")
            
            // Vérifier que la réponse est nulle en cas d'erreur
            XCTAssertNil(articles)
            
            // Vérifier que la complétion a été appelée avec une erreur
            XCTAssertFalse(success)
        }
    }

}
