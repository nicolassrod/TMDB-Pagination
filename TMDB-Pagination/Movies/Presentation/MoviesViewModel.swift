//
//  MoviesViewModel.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation
import Combine
import SwiftUI

@propertyWrapper class Paginated {
    var totalPages: Int
    var wrappedValue: Int
    var shouldLoadNextPage: Bool = true
    var isResquestLoaded: Bool = false
    var isTheLastPage: Bool {
        get {
            if wrappedValue == totalPages {
                return true
            } else {
                return false
            }
        }
    }
    var projectedValue: Paginated { return self }
    
    init(wrappedValue: Int, total: Int) {
        self.wrappedValue = wrappedValue
        self.totalPages = total
    }
    
    @discardableResult func nextPage() -> Int {
        if totalPages > wrappedValue {
            wrappedValue += 1
        } else {
            shouldLoadNextPage = false
        }
        return wrappedValue
    }
}

final class MoviesViewModel: ObservableObject {
    @Published var selection: CategoryFilter = .popular
    @Published var popularMovies: [CustomMovieResponse] = []
    @Published var topRatedMovies: [CustomMovieResponse] = []
    @Published var onTV: [CustomMovieResponse] = []
    @Published var airingToday: [CustomMovieResponse] = []
    @Paginated(total: 1) var popularMoviesPage = 1
    @Paginated(total: 1) var topRatedMoviesPage = 1
    @Paginated(total: 1) var onTVPage = 1
    @Paginated(total: 1) var airingTodayPage = 1
    
    private let moviesService: MoviesServiceType
    private let tvService: TVServiceType
    private var disposables = Set<AnyCancellable>()
    
    enum CategoryFilter {
        case popular
        case topRated
        case onTV
        case airingToday
    }
    
    init(moviesService: MoviesServiceType = MoviesService(),
         tvService: TVServiceType = TVService()) {
        self.moviesService = moviesService
        self.tvService = tvService
    }
    
    func getPopularMovies() {
        guard _popularMoviesPage.shouldLoadNextPage else {
            return
        }
        moviesService
            .populars(
                apiKey: Constants.apiKey,
                language: "en",
                page: popularMoviesPage
            ).sink { _ in } receiveValue: { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self._popularMoviesPage.totalPages = response.totalPages
                self.popularMovies.append(contentsOf: response.results)
                print(response.results)
            }.store(in: &disposables)
    }
    
    func getTopRatedMovies() {
        guard _topRatedMoviesPage.shouldLoadNextPage else {
            return
        }
        moviesService
            .topRated(
                apiKey: Constants.apiKey,
                language: "en",
                page: topRatedMoviesPage
            ).sink { _ in } receiveValue: { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self._topRatedMoviesPage.totalPages = response.totalPages
                self.topRatedMovies.append(contentsOf: response.results)
            }.store(in: &disposables)
    }
    
    func getOnTV() {
        guard _onTVPage.shouldLoadNextPage else {
            return
        }
        tvService
            .onTheAir(
                apiKey: Constants.apiKey,
                language: "en",
                page: onTVPage
            ).sink { rr in
                print(rr)
            } receiveValue: { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self._onTVPage.totalPages = response.totalPages
                self.onTV.append(contentsOf: response.results)
            }.store(in: &disposables)
    }
    
    func getAiringToday() {
        guard _airingTodayPage.shouldLoadNextPage else {
            return
        }
        tvService
            .airingToday(
                apiKey: Constants.apiKey,
                language: "en",
                page: airingTodayPage
            ).sink { rr in
                print(rr)
            } receiveValue: { [weak self] response in
                guard let `self` = self else {
                    return
                }
                print(response)
                self._airingTodayPage.totalPages = response.totalPages
                self.airingToday.append(contentsOf: response.results)
            }.store(in: &disposables)
    }
}
