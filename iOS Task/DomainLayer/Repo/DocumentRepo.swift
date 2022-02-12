//
//  DocumentRepo.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation
import Combine

protocol DocumentRepo {
    func getDocuments(ofset: Int) -> Observable<DocumentsModel>
    func getDocument(id: String) -> Observable<DocumentModel>
    func searchForDocuments(page: Int , search:SearchDocuemtFilds) -> Observable<SearchDocumentsModel>
}
