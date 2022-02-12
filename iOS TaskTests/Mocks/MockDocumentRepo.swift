//
//  File.swift
//  iOS TaskTests
//
//  Created by Ali Bamohammad on 12/02/2022.
//

import XCTest
import Combine
@testable import iOS_Task

class MockDocumentRepo:DocumentRepo {
    
    init() {
        
    }
    
    let document = DocumentModel(title: "The big", key: "", ISBNS: [], authors: [Author(key: "", name: "Ali"), Author(key: "", name: "Mohammad")])
//    (title: "The big", authors: [Author(key: "", name: "Ali"), Author(key: "", name: "Mohammad")] , )
    let documentOffset0 = DocumentModel(title: "The big", key: "", ISBNS: [], authors: [Author(key: "", name: "Ali"), Author(key: "", name: "Mohammad")])
    let documentOffset1 = DocumentModel(title: "The big", key: "", ISBNS: [], authors: [Author(key: "", name: "Ali"), Author(key: "", name: "Mohammad")])
    
    let searDocumentPage1 = SearchDocumentModel(title: "Mohammad", authorName: [], isbn: [], key: "")
    let searDocumentPage2 = SearchDocumentModel(title: "ALi", authorName: [], isbn: [], key: "")
    
    func getDocument(id: String) -> Observable<DocumentModel> {
        Observable.just(document)
    }
    func getDocuments(ofset: Int) -> Observable<DocumentsModel> {
        if ofset == 0 {
        return Observable.just(DocumentsModel.init(key: "", name: "", subjectType: "", title: "", docs: [documentOffset0], totalDocs: 0))
        } else {
            return Observable.just(DocumentsModel.init(key: "", name: "", subjectType: "", title: "", docs: [documentOffset1], totalDocs: 0))
        }
    }
    
    func searchForDocuments(page: Int, search: SearchDocuemtFilds) -> Observable<SearchDocumentsModel> {
        if page == 2 {
            return Observable.just(SearchDocumentsModel.init(docs: [searDocumentPage2]))
        } else {
            return Observable.just(SearchDocumentsModel.init(docs: [searDocumentPage1]))
        }
        
    }
}
