//
//  MoyaRequester.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/6/21.
//

import Foundation
import Moya
import Combine

protocol MoyaRequesterType {
    func request(_ target: TargetType) -> AnyPublisher<Moya.Response, Error>
}

struct MoyaRequester: MoyaRequesterType {
    private let provider: MoyaProvider<MultiTarget>
    
    init(with provider: MoyaProvider<MultiTarget> = MoyaProvider()) {
        self.provider = provider
    }
    
    func request(_ target: TargetType) -> AnyPublisher<Moya.Response, Error> {
        Future { seal in
            provider.request(MultiTarget(target)) { networkResponse in
                switch networkResponse {
                case .failure(let error):
                    seal(.failure(error))
                case .success(let response):
                    seal(.success(response))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
