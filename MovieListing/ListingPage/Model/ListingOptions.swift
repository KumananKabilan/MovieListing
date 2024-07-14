//
//  ListingOptions.swift
//  MovieListing
//
//  Created by Kumanan K on 14/07/24.
//

import Foundation

enum ListingOptions: Int, CaseIterable {
    case year
    case genre
    case directors
    case actors
    case allMovies
    case none

    var title: String {
        switch self {
        case .none:
            "None"
        case .year:
            "Year"
        case .genre:
            "Genre"
        case .directors:
            "Directors"
        case .actors:
            "Actors"
        case .allMovies:
            "All Movies"
        }
    }

    func movieData(movieData: [MovieCoreData]) -> [String] {
        var array: [String] = []
        for (index, movie) in movieData.enumerated() {
            switch self {
            case .year:
                array.append(movie.year)
            case .genre:
                array.append(movie.genre)
            case .directors:
                array.append(movie.director)
            case .actors:
                array.append(movie.actors)
            default:
                break
            }
        }
        return array
    }
}
