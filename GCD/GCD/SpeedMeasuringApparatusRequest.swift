//
//  SpeedMeasuringApparatusRequest.swift
//  GCD
//
//  Created by littlema on 2019/8/22.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

enum SpeedMeasuringApparatusRequest: RestAPIRequest {
    
    case getData(limit: Int, offset: Int)
    
    var header: [String : String] { return [:] }
    
    var body: Data? { return nil }
    
    var method: String { return HttpMethod.GET.rawValue }
    
    var endPonit: String {
        switch self {
        case .getData(let limit, let offset):
            return "/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=\(limit)&offset=\(offset)"
        }
    }
    
}
