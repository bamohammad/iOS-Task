//
//  DocumentsAPIInput.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import Foundation

final class DocumentsAPIInput: APIInput {
    init(ofset:Int) {

        
        super.init(urlString: "subjects/love.json?limit=10&offset=\(ofset)",
                   parameters: [:] ,
                   method: "get")
        
    }
}

final class DocumentAPIInput: APIInput {
    init(id:String) {

        
        super.init(urlString: "\(id).json",
                   parameters: [:] ,
                   method: "get")
        
    }
}
