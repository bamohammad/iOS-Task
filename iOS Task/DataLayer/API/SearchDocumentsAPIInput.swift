//
//  SearchDocumentsAPIInput.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 11/02/2022.
//

import Foundation

final class SearchDocumentsAPIInput: APIInput {
    init(page:Int , search:SearchDocuemtFilds) {

        var apiParams = Dictionary<String, String>()
        if let query = search.query{
            apiParams.updateValue(query , forKey: "q")
        }
        if let title = search.title{
            apiParams.updateValue(title , forKey: "title")
        }
        if let auther = search.auther{
            apiParams.updateValue(auther , forKey: "author")
        }
        
        
        var components = URLComponents()
        
        components.queryItems = apiParams.map {
             URLQueryItem(name: $0, value: $1)
        }
        let urlQuery = components.url

        
        super.init(urlString: "search.json\(urlQuery?.absoluteString ?? "")&page=\(page)&limit=10",
                   parameters: [:] ,
                   method: "get")
        
    }
}

public struct SearchDocuemtFilds {
    var query:String? = nil
    var title:String? = nil
    var auther:String? = nil
}


extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}
