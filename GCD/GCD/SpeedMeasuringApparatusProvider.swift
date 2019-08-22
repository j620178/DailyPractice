//
//  SpeedMeasuringApparatusProvider.swift
//  GCD
//
//  Created by littlema on 2019/8/22.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct SpeedMeasuringApparatusResponse: Decodable {
    let result: Content
}

struct Content: Decodable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [Apparatus]
}

struct Apparatus: Decodable {
    let functions: String
    let area: String
    let no: String
    let direction: String
    let speedLimit: String
    let location: String
    let id: Int
    let road: String
    
    enum CodingKeys: String, CodingKey {
        case speedLimit = "speed_limit"
        case id = "_id"
        case functions, area, no, direction, location, road
    }
}



class SpeedMeasuringApparatusProvider {
    let decoder = JSONDecoder()
    
    func fetchData(limit: Int, offset: Int, completion: @escaping (Result<SpeedMeasuringApparatusResponse, RestAPIError>) -> Void) {
        
        HttpClient.shared.request(SpeedMeasuringApparatusRequest.getData(limit: limit, offset: offset).mackRequset()) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                do {
                    let response = try strongSelf.decoder.decode(SpeedMeasuringApparatusResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(response))
                    }
                } catch {
                    completion(Result.failure(RestAPIError.unexpectedError))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        
    }
    
}
