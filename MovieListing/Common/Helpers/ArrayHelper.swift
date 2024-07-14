//
//  ArrayHelper.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import Foundation

extension Array where Element == Movie {
    var helperMovieData: [MovieCoreData] {
        var array: [MovieCoreData] = []
        self.forEach { movie in
            if let actors = movie.actors,
               let awards = movie.awards,
               let boxOffice = movie.boxOffice,
               let country = movie.country,
               let director = movie.director,
               let dvd = movie.dvd,
               let genre = movie.genre,
               let imdbID = movie.imdbID,
               let imdbRating = movie.imdbRating,
               let imdbVotes = movie.imdbVotes,
               let language = movie.language,
               let metaScore = movie.metaScore,
               let plot = movie.plot,
               let poster = movie.poster,
               let production = movie.production,
               let rated = movie.rated,
               let _ratings = movie.ratings,
               let released = movie.released,
               let response = movie.response,
               let runTime = movie.runTime,
               let title = movie.title,
               let type = movie.type,
               let website = movie.website,
               let writer = movie.writer,
               let year = movie.year {
                var ratings: [RatingData] = []
                let jsonData = _ratings.data(using: .utf8)!
                let decoder = JSONDecoder()
                do {
                    let ratingsData = try decoder.decode([RatingData].self, from: jsonData)
                    ratings = ratingsData
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
                let movieData: MovieCoreData = MovieCoreData(
                    actors: actors,
                    awards: awards,
                    boxOffice: boxOffice,
                    country: country,
                    director: director,
                    dvd: dvd,
                    genre: genre,
                    imdbID: imdbID,
                    imdbRating: imdbRating,
                    imdbVotes: imdbVotes,
                    language: language,
                    metaScore: metaScore,
                    plot: plot,
                    poster: poster,
                    production: production,
                    rated: rated,
                    ratings: ratings,
                    released: released,
                    response: response,
                    runTime: runTime,
                    title: title,
                    type: type,
                    website: website,
                    writer: writer,
                    year: year
                    )
                array.append(movieData)
            }
        }
        return array
    }
}
