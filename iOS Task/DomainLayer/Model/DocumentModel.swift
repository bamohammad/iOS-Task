//
//  DocumentModel.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation


struct DocumentsModel:Decodable {
    let key, name, subjectType: String
    var title:String?
    var docs: [DocumentModel]
    var totalDocs: Int?
    enum CodingKeys: String, CodingKey {
            case key, name
            case subjectType = "subject_type"
            case docs = "works"
        case totalDocs = "work_count"
        }
}



struct DocumentModel: Codable {

    let title: String?
    let key:String?
    let ISBNS:[String]?
    let authors: [Author]
        
    enum CodingKeys: String, CodingKey {
        case key, title , authors
        case ISBNS = "isbn"
    }
}



struct Author: Codable {
    let key, name: String?
}
