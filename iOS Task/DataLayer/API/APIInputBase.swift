//
//  APIInputBase.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/30/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

import Foundation

open class APIInputBase {
    public var headers: [String : String]?
    public var url: URL
    public var method: String = "get"
    public var parameters: [String:AnyObject]
    public init(urlString: String,
                parameters: [String:AnyObject],
                method: String) {
        self.url = URL(string: urlString)!
        self.parameters = parameters
        self.method = method

    }
}

class APIInput: APIInputBase {  // swiftlint:disable:this final_class
    fileprivate var baseUrl = "https://openlibrary.org/"
    override init(urlString: String, parameters: [String : AnyObject], method: String) {
        super.init(urlString: baseUrl + urlString, parameters: parameters, method: method)
        self.headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
            "locale": "en"
        ]
    }
    
}

