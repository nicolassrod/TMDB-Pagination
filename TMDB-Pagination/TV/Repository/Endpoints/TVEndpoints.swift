//
//  TVEndpoints.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation
import Moya

enum TVTarget {
    case getOnTheAir(apiKey: String, language: String, page: Int)
    case getAiringToday(apiKey: String, language: String, page: Int)
}

extension TVTarget: TMDBTargetType {
    var requestEndpoint: String {
        switch self {
        case .getOnTheAir:
            return "/tv/on_the_air"
        case .getAiringToday:
            return "/tv/airing_today"
        }
        
    }
    
    var requestMethod: TMDBNetworkMethod {
        switch self {
        case .getOnTheAir,
             .getAiringToday:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getOnTheAir(let apiKey, let language, let page),
             .getAiringToday(let apiKey, let language, let page):
            let params: [String: Any] = [
                "api_key": apiKey,
                "language": language,
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    
}
