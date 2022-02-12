//
//  DocumentItemViewModel.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import Foundation
struct DocumentItemViewModel {
    let title: String
    let auther: String
    let authers: [String]
    var isbns: [String]
    let key:String
    
    init(document: DocumentModel) {
        self.title = document.title ?? ""
        self.auther = document.authors.map({$0.name ?? ""}).joined(separator: ", ")
        self.authers = document.authors.map({$0.name ?? ""})
        self.key = document.key ?? ""
        self.isbns = []
    }
    
    init(document: SearchDocumentModel) {
        self.title = document.title ?? ""
        self.auther = document.authorName?.joined(separator: ", ") ?? ""
        self.key = document.key
        self.authers = document.authorName ?? []
        self.isbns = document.isbn ?? []
        
        self.isbns = isbns.count > 5 ?  isbns.dropLast(isbns.count - 5) : isbns
    }
}

extension DocumentItemViewModel :Equatable {
    
}
extension Double {
    var currency: String {
        return String(format: "$%.02f", self)
    }
}

func == (lhs: DocumentItemViewModel, rhs: DocumentItemViewModel) -> Bool {
    lhs.title == rhs.title && lhs.auther == rhs.auther
}
