//
//  GetDocumentsTests.swift
//  iOS TaskTests
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import XCTest
import Combine
@testable import iOS_Task

class GetDocumentsUCTests: XCTestCase {
    let repo = MockDocumentRepo()
    var getDocumentsUC: GetDocumentsUC!// = GetDocumentsUC(repo: MockDocumentRepo())
    private let cancelBag = CancelBag()
    override func setUp() {
    getDocumentsUC = GetDocumentsUC(repo: MockDocumentRepo())
        super.setUp()
    }
   
    override func tearDown() {
        cancelBag.cancel()
    }
    
    func test_GetDocuments_fetchDocuments() throws{
        
        let expectation = self.expectation(description: #function)
        var result:[DocumentItemViewModel]!
        
        getDocumentsUC.getDocuments(arg: .fetch())
            .map({$0.items})
            .sink { error in
                
            } receiveValue: { docs in
                result = docs
                expectation.fulfill()
            }.store(in: cancelBag)
        
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNotNil(result, "expected not null but it is")
        XCTAssertEqual(result.first, DocumentItemViewModel.init(document: repo.documentOffset0))
        
        
    }
    
    func test_GetDocumentssearchPage1Succeeds() throws {
                
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage1)
        
        var result:[DocumentItemViewModel]!
        var page:Int!
        
        getDocumentsUC.getDocuments(arg: .srearch(1, SearchDocuemtFilds(query: "ssdsd")))
            .sink { error in
                
            } receiveValue: { output in
                page = output.page
                result = output.items
            }
            .store(in: cancelBag)
        XCTAssert(page == 1, "Page expected to be 1 but was \(String(describing: page))")
        
        XCTAssert(result.first == expected , "dcoument expected to be \(expected) but was \(result)")
        
    }
    
    func test_GetDocumentssearchPage1Fail() throws {
                
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage2)
        
        var result:[DocumentItemViewModel]!
        var page:Int!
        
        getDocumentsUC.getDocuments(arg: .srearch(1, SearchDocuemtFilds(query: "ssdsd")))
            .sink { error in
                
            } receiveValue: { output in
                page = output.page
                result = output.items
            }
            .store(in: cancelBag)
        XCTAssert(page != 2, "Page expected to be 1 but was \(String(describing: page))")
        
        XCTAssert(result.first != expected , "dcoument expected to be \(expected) but was \(result)")
        
    }
    
    func test_GetDocuments_searchPage2Succeeds() throws {
                
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage2)
    
        var result:[DocumentItemViewModel]!
        var page:Int!
        
        getDocumentsUC.getDocuments(arg: .srearch(2, SearchDocuemtFilds(query: "ssdsd")))
            .sink { error in
                
            } receiveValue: { output in
                page = output.page
                result = output.items
            }
            .store(in: cancelBag)
        XCTAssert(page == 2, "Page expected to be 2 but was \(String(describing: page))")
        
        XCTAssert(result.first == expected , "dcoument expected to be \(expected) but was \(result)")
        
    }
    
    func test_GetDocuments_searchPage2Fail() throws {
                
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage1)
    
        var result:[DocumentItemViewModel]!
        var page:Int!
        
        getDocumentsUC.getDocuments(arg: .srearch(1, SearchDocuemtFilds(query: "ssdsd")))
            .sink { error in
                
            } receiveValue: { output in
                page = output.page
                result = output.items
            }
            .store(in:cancelBag)
        XCTAssert(page == 1, "Page expected to be 2 but was \(String(describing: page))")
        
        XCTAssert(result.first == expected , "dcoument expected to be \(expected) but was \(result)")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
