//
//  TVService.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation
import Combine

protocol TVServiceType {
    func onTheAir(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[OnTheAirResponse]>, Error>
    func airingToday(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[AiringTodayResponse]>, Error>
}

struct TVService: TVServiceType {
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    func onTheAir(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[OnTheAirResponse]>, Error> {
        apiRequester
            .request(
                TVTarget.getOnTheAir(apiKey: apiKey, language: language, page: page)
            )
    }
    
    func airingToday(apiKey: String, language: String, page: Int) -> AnyPublisher<PagedResponse<[AiringTodayResponse]>, Error> {
        apiRequester
            .request(
                TVTarget.getAiringToday(apiKey: apiKey, language: language, page: page)
            )
    }
}
