//
//  HttpService.swift
//  iOS Task
//
//  Created by Ali Bamohammad on 10/02/2022.
//

import Foundation
import Combine

class HttpService/*: DataSource*/{
    
    static var shared = HttpService()
    private var manager: URLSession
//    public var logOptions = LogOptions.default
    
    private convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        self.init(configuration: configuration)
    }
    
    private init(configuration: URLSessionConfiguration) {
        manager =  URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(_ input: APIInputBase) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(
            url: input.url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 60)
        
        request.httpMethod = input.method
                
        return manager.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { data , response in
                let json = (try? JSONSerialization.jsonObject(with: data, options: []))
                print("data is \(data) and response \(json  ?? "")")
            }, receiveCompletion: { completion in
                if case .failure(let err) = completion {
                  print("Retrieving data failed with error \(err)")
                }
              })
            .map { $0.data }
            .decode(type: T.self,
                    decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                  print("Retrieving data failed with error \(err)")
                }
              })
            .eraseToAnyPublisher()
    }
    

}





