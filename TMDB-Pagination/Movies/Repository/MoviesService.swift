//
//  MoviesService.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation
import Combine

protocol MoviesServiceType {
    func populars(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[PopularMovieResponse]>, Error>
    func topRated(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[TopRatedMovieResponse]>, Error>
}

struct MoviesService: MoviesServiceType {
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    func populars(apiKey: String, language: String = "en", page: Int = 1) -> AnyPublisher<PagedResponse<[PopularMovieResponse]>, Error> {
        apiRequester
            .request(
                MoviesTarget.getPopulars(apiKey: apiKey, language: language, page: page)
            )
    }
    
    func topRated(apiKey: String, language: String = "en", page: Int = 1) -> AnyPublisher<PagedResponse<[TopRatedMovieResponse]>, Error> {
        apiRequester
            .request(
                MoviesTarget.getTopRated(apiKey: apiKey, language: language, page: page)
            )
    }
}
