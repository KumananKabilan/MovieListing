//
//  ListingViewState.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import Foundation

struct ListingViewState {
    let coreDataActionState: CoreDataActionState
    let moviesArray: [MovieData]
    let listingOptionValues: (ListingOptions, [String])

    enum CoreDataActionState {
        case none
        case failedToSave
        case failedToFetch
        case savingSuccess
        case fetchingSuccess
    }
}

// MARK: - Helper

extension ListingViewState {
    static let `default` = ListingViewState(
        coreDataActionState: .none,
        moviesArray: [],
        listingOptionValues: (.none, [])
    )

    func copy(
        coreDataActionState: CoreDataActionState? = nil,
        moviesArray: [MovieData]? = nil,
        listingOptionValues: (ListingOptions, [String])? = nil
    ) -> ListingViewState {
        ListingViewState(
            coreDataActionState: coreDataActionState ?? self.coreDataActionState,
            moviesArray: moviesArray ?? self.moviesArray,
            listingOptionValues: listingOptionValues ?? self.listingOptionValues
        )
    }
}

struct MovieData: Codable {
    let actors: String
    let awards: String
    let boxOffice: String?
    let country: String
    let director: String
    let dvd: String?
    let genre: String
    let imdbID: String
    let imdbRating: String
    let imdbVotes: String
    let language: String
    let metaScore: String
    let plot: String
    let poster: String
    let production: String?
    let rated: String
    let ratings: [RatingData]
    let released: String
    let response: String
    let runTime: String
    let title: String
    let type: String
    let website: String?
    let writer: String
    let year: String

    enum CodingKeys: String, CodingKey {
        case actors = "Actors"
        case awards = "Awards"
        case boxOffice = "BoxOffice"
        case country = "Country"
        case director = "Director"
        case dvd = "DVD"
        case genre = "Genre"
        case imdbID = "imdbID"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case language = "Language"
        case metaScore = "Metascore"
        case plot = "Plot"
        case poster = "Poster"
        case production = "Production"
        case rated = "Rated"
        case ratings = "Ratings"
        case released = "Released"
        case response = "Response"
        case runTime = "Runtime"
        case title = "Title"
        case type = "Type"
        case website = "Website"
        case writer = "Writer"
        case year = "Year"
    }
}

struct RatingData: Codable {
    var source: String
    var value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

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

    func movieData(movieData: [MovieData]) -> [String] {
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
