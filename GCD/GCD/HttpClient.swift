//
//  HttpClient.swift
//  GCD
//
//  Created by littlema on 2019/8/22.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

enum RestAPIError: Error {
    case clientError
    case serverError
    case unexpectedError
}

enum HttpMethod: String {
    case GET
}

protocol RestAPIRequest {
    var header: [String: String] { get }
    var body: Data? { get }
    var method: String  { get }
    var endPonit: String  { get }
}

extension RestAPIRequest{
    func mackRequset() -> URLRequest {
        
        let urlString = "https://data.taipei" + endPonit
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = header
        
        request.httpMethod = method
        
        return request
    }
}

class HttpClient {
    static let shared = HttpClient()
    
    private let decoder = JSONDecoder()
    
    func request(_ request: URLRequest, completion: @escaping (Result<Data, RestAPIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200..<300: completion(Result.success(data!))
            case 300..<400: completion(Result.failure(RestAPIError.clientError))
            case 400..<500: completion(Result.failure(RestAPIError.serverError))
            case 500..<600: completion(Result.failure(RestAPIError.unexpectedError))
            default: completion(Result.failure(RestAPIError.unexpectedError))
            }
            
        }.resume()
    }
    
}
