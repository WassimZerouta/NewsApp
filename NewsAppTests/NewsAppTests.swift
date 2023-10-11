//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Wass on 03/06/2023.
//

import XCTest
@testable import NewsApp

final class NewsAppTests: XCTestCase {

    func testGetRecipesSucced() {
        //Given
        let apiHelper: APIHelper = MockNewsAPIHelper()
        
        //When
        let expectation = XCTestExpectation(description: "Wait for queu change")
        apiHelper.performRequest(q: "apple") { success , Recipes in
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(Recipes)
            XCTAssertEqual(Recipes?.count, 2)
            expectation.fulfill()
            
            
        }
        wait(for: [expectation], timeout: 0.01)
        
    }

}
