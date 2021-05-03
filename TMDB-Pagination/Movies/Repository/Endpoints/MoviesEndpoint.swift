//
//  MoviesEndpoint.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation
import Moya

enum MoviesTarget {
    case getPopulars(apiKey: String, language: String, page: Int)
    case getTopRated(apiKey: String, language: String, page: Int)
}

// MARK: TMDBTargetType Implementation
extension MoviesTarget: TMDBTargetType {
    var requestEndpoint: String {
        switch self {
        case .getPopulars:
            return "/movie/upcoming"
        case .getTopRated:
            return "/movie/top_rated"
        }
    }
    
    var requestMethod: TMDBNetworkMethod {
        switch self {
        case .getPopulars,
             .getTopRated:
            return .get
        }
    }
}

// MARK: Moya Implementation
extension MoviesTarget {
    var task: Task {
        switch self {
        case .getPopulars(let apiKey, let language, let page),
             .getTopRated(let apiKey, let language, let page):
            let params: [String: Any] = [
                "api_key": apiKey,
                "language": language,
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
