//
//  CustomMovieResponse.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/19/21.
//

import Foundation

protocol CustomMovieResponse: Codable {
    var id: Int { get }
    var title: String { get }
    var overview: String { get }
    var releaseDate: String { get }
    var posterPath: String? { get }
    var voteAverage: Double { get }
}
