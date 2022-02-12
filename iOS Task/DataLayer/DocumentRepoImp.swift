//
//  DocumentRepoImp.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import Foundation

class DocumentRepoImp:DocumentRepo {
    
    private let sesion = HttpService.shared
    
    init() {
        
    }
    func getDocuments(ofset: Int) -> Observable<DocumentsModel> {
        let input = DocumentsAPIInput(ofset: ofset)
        return sesion.request(input)        
    }
    
    func searchForDocuments(page: Int , search:SearchDocuemtFilds) -> Observable<SearchDocumentsModel> {
        let input = SearchDocumentsAPIInput(page: page, search: search)
        return sesion.request(input)
    }
    
    func getDocument(id: String) -> Observable<DocumentModel> {
        let input = DocumentAPIInput(id: id)
        return sesion.request(input)
    }
}

