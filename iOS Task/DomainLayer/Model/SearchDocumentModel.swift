//
//  DocumentModel.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation

struct SearchDocumentsModel: Codable {
    let docs: [SearchDocumentModel]
    enum CodingKeys: String, CodingKey {
        case docs = "docs"
    }
}

// MARK: - Doc
struct SearchDocumentModel: Codable {
    
    let title: String?
    let authorName:[String]?
    let isbn: [String]?
    let key:String

    enum CodingKeys: String, CodingKey {
        case title
        case isbn
        case key
        case authorName = "author_name"
       
    }
}
