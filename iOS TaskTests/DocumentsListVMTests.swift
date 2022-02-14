//
//  iOS_TaskTests.swift
//  iOS TaskTests
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import XCTest
import Combine
@testable import iOS_Task

class DocumentsListVMTests: XCTestCase {
    
    let repo = MockDocumentRepo()
    var getDocumentsUC: GetDocumentsUC = GetDocumentsUC(repo: MockDocumentRepo())
    private let cancelBag = CancelBag()
    private let loadTrigger = PassthroughSubject<APIFetchType, Never>()
    private let reloadTrigger = PassthroughSubject<APIFetchType, Never>()
    private let loadMoreTrigger = PassthroughSubject<APIFetchType, Never>()
    private var input:DocumentsListVM.Input!
    private var documentsListVM:DocumentsListVM!
    private var output:DocumentsListVM.Output!
    
    override func setUp() {
        super.setUp()
        input = DocumentsListVM.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                                          reloadTrigger: reloadTrigger.eraseToAnyPublisher(),
                                          loadMoreTrigger: loadMoreTrigger.eraseToAnyPublisher())
        documentsListVM = DocumentsListVM(getDocumentsUC: getDocumentsUC)
         output = documentsListVM.perform(input, cancelBag: cancelBag)
    }
    
    override  func tearDown() {
        cancelBag.cancel()
    }
    
    func test_performFetchLoad() throws {
        
        // Given
        var result:[DocumentItemViewModel] = []
        let expected = DocumentItemViewModel.init(document: repo.documentOffset0)
        output.$documents
            .dropFirst()
            .sink { docs in
               result = docs

            }.store(in: cancelBag)
        
        //when
        loadTrigger.send(.fetch())
        
        // Then
        XCTAssert(!result.isEmpty)
        XCTAssertEqual(result.first, expected)
        
    }
    
    func test_performFetchLoadmore() throws {
        
        // Given
        var result:[DocumentItemViewModel] = [DocumentItemViewModel.init(document: repo.documentOffset1)]
        let expected = DocumentItemViewModel.init(document: repo.documentOffset1)
        output.$documents
            .dropFirst()
            .sink { docs in
               result = docs
            }.store(in: cancelBag)
        
        //when
        loadTrigger.send(.fetch(1))
        loadMoreTrigger.send(.fetch(2))
        
        // Then
        XCTAssert(!result.isEmpty)
        XCTAssertEqual(result.first, expected)
        
    }
    
    func test_performLoadSearch() throws {
        
        // Given
        var result:[DocumentItemViewModel] = []
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage1)
        let expectation = self.expectation(description: "")
        output.$documents
            .dropFirst()
            .sink { docs in
               result = docs
                expectation.fulfill()

            }.store(in: cancelBag)
        
        //when
        loadTrigger.send(.srearch(1, SearchDocuemtFilds(query:"Ali")))
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(!result.isEmpty)
        XCTAssertEqual(result.first, expected)
        
    }
    
    func test_performLoadMoreSearch() throws {
        
        // Given
        var result:[DocumentItemViewModel] = []
        let expected = DocumentItemViewModel.init(document: repo.searDocumentPage2)
//        let expectation = self.expectation(description: "")
        output.$documents
            .dropFirst()
            .sink { docs in
               result = docs
//                expectation.fulfill()

            }.store(in: cancelBag)
        
        //when
        loadTrigger.send(.srearch(1, SearchDocuemtFilds(query:"Ali")))
        loadMoreTrigger.send(.srearch(2, SearchDocuemtFilds(query:"Ali")))
        
        // Then
//        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(!result.isEmpty)
        XCTAssertEqual(result.last, expected)
        
    }


}
