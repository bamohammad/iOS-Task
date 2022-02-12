//
//  GetDocumentsUC.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation

class GetDocumentsUC {
    private let repo:DocumentRepo
    init(repo:DocumentRepo) {
        self.repo = repo
    }
    
    func getDocuments(arg:APIFetchType) -> Observable<PagingInfo<DocumentItemViewModel>> {
        switch arg {
        case .srearch(let page, let search):
            return searchForDocuments(page: page, search: search)
                .map({ output in
                    PagingInfo(page: output.page, items: output.items.map(DocumentItemViewModel.init))
                })
                .eraseToAnyPublisher()
        case .fetch(let offset):
           return fetchDocuments(offset: offset)
                .map { output in
                    PagingInfo(offset: output.offset, items: output.items.map(DocumentItemViewModel.init), totalItems: output.totalItems)
                        
                }
                .eraseToAnyPublisher()
        }
//        return repo.getDocuments(ofset: offset)
//             .map({ output in
//                 PagingInfo(offset: offset, items: output.docs, totalItems: output.totalDocs ?? 0)
//             })
//             .eraseToAnyPublisher()
     }
    
    func getDocument(id: String) -> Observable<DocumentModel> {
        
    return repo.getDocument(id: id)
    }
    
    
    private func fetchDocuments(offset:Int) -> Observable<PagingInfo<DocumentModel>> {
        
        return repo.getDocuments(ofset: offset)
             .map({ output in
                 PagingInfo(offset: offset, items: output.docs, totalItems: output.totalDocs ?? 0)
             })
             .eraseToAnyPublisher()
     }
    
  private  func searchForDocuments(page:Int , search:SearchDocuemtFilds) -> Observable<PagingInfo<SearchDocumentModel>> {
        
        return repo.searchForDocuments(page: page, search: search)
             .map ({ output in
                 PagingInfo(page: page, items: output.docs)
             })
             .eraseToAnyPublisher()
     }
}


                                    

