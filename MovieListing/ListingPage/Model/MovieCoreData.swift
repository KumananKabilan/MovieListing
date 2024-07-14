//
//  MovieCoreData.swift
//  MovieListing
//
//  Created by Kumanan K on 14/07/24.
//

import Foundation

struct MovieCoreData: Codable {
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
