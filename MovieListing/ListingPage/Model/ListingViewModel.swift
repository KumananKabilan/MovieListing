//
//  ListingViewModel.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import CoreData
import RxSwift

class ListingViewModel {
    // MARK: - Properties

    let stateChangeObservable: BehaviorSubject<ListingViewState> = BehaviorSubject(value: .default)
    private var currentState: ListingViewState {
        self.stateChangeObservable.helperSafeValue
    }
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
//        self.resetCoreData()
        self.performCoreDataFetch()
    }
}

// MARK: - CoreData Helpers

private extension ListingViewModel {
    func importJSONData() {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let moviesData = try decoder.decode([MovieCoreData].self, from: data)
            saveToCoreData(moviesData: moviesData)
        } catch {
            print("Failed to load and decode JSON: \(error)")
        }
    }

    func saveToCoreData(moviesData: [MovieCoreData]) {
        for (index, movieData) in moviesData.enumerated() {
            let moviesEntity = Movie(context: self.managedObjectContext)
            moviesEntity.actors = movieData.actors
            moviesEntity.awards = movieData.awards
            moviesEntity.boxOffice = movieData.boxOffice
            moviesEntity.country = movieData.country
            moviesEntity.director = movieData.director
            moviesEntity.dvd = movieData.dvd
            moviesEntity.genre = movieData.genre
            moviesEntity.imdbID = movieData.imdbID
            moviesEntity.imdbRating = movieData.imdbRating
            moviesEntity.imdbVotes = movieData.imdbVotes
            moviesEntity.language = movieData.language
            moviesEntity.metaScore = movieData.metaScore
            moviesEntity.plot = movieData.plot
            moviesEntity.poster = movieData.poster
            moviesEntity.production = movieData.production
            moviesEntity.rated = movieData.rated
            moviesEntity.released = movieData.released
            moviesEntity.response = movieData.response
            moviesEntity.runTime = movieData.runTime
            moviesEntity.title = movieData.title
            moviesEntity.type = movieData.type
            moviesEntity.website = movieData.website
            moviesEntity.writer = movieData.writer
            moviesEntity.year = movieData.year
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let jsonData = try encoder.encode(movieData.ratings)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    moviesEntity.ratings = jsonString
                }
            } catch {
                print("Error encoding RatingData to JSON: \(error.localizedDescription)")
            }
            if index == (moviesData.count - 1) {
                self.stateChangeObservable.onNext(
                    self.currentState.copy(
                        coreDataActionState: .savingSuccess
                    )
                )
            }
            do {
                try self.managedObjectContext.save()
            } catch {
                self.stateChangeObservable.onNext(
                    self.currentState.copy(
                        coreDataActionState: .failedToSave
                    )
                )
            }
        }
        self.stateChangeObservable.onNext(
            self.currentState.copy(
                coreDataActionState: .savingSuccess
            )
        )
    }

    func initiateFetchFromCoreData() -> [MovieCoreData] {
        do {
            let fetchedData = try self.managedObjectContext.fetch(Movie.fetchRequest())
            return fetchedData.helperMovieData
        } catch {
            self.stateChangeObservable.onNext(
                self.currentState.copy(
                    coreDataActionState: .failedToFetch
                )
            )
        }
        return []
    }

    func performCoreDataFetch() {
        let moviesArray = self.initiateFetchFromCoreData()
        if moviesArray.isEmpty {
            self.importJSONData()
        }
        self.stateChangeObservable.onNext(
            self.currentState.copy(
                coreDataActionState: .fetchingSuccess, 
                moviesArray: self.getMovieData(
                    from: moviesArray
                )
            )
        )
    }

    func resetCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.managedObjectContext.execute(batchDeleteRequest)
            try self.managedObjectContext.save()
        } catch {
            print("Failed to delete items: \(error)")
        }
    }
}

// MARK: - Helpers

extension ListingViewModel {
    func headerCellSelected(listingOption: ListingOptions) {
        var listingOptionValues: (ListingOptions, [String])
        switch listingOption {
        case .none:
            listingOptionValues.0 = .none
            listingOptionValues.1 = []
        case .year:
            listingOptionValues.0 = .year
            var array: [String] = []
            self.currentState.moviesArray.forEach { movieData in
                if !array.contains(movieData.year) {
                    array.append(movieData.year)
                }
            }
            listingOptionValues.1 = array
        case .genre:
            listingOptionValues.0 = .genre
            var array: [String] = []
            self.currentState.moviesArray.forEach { movieData in
                if !array.contains(movieData.genre) {
                    array.append(contentsOf: movieData.genre)
                }
            }
            listingOptionValues.1 = array
        case .directors:
            listingOptionValues.0 = .directors
            var array: [String] = []
            self.currentState.moviesArray.forEach { movieData in
                if !array.contains(movieData.director) {
                    array.append(contentsOf: movieData.director)
                }
            }
            listingOptionValues.1 = array
        case .actors:
            listingOptionValues.0 = .actors
            var array: [String] = []
            self.currentState.moviesArray.forEach { movieData in
                if !array.contains(movieData.actors) {
                    array.append(contentsOf: movieData.actors)
                }
            }
            listingOptionValues.1 = array
        case .allMovies:
            listingOptionValues.0 = .allMovies
            listingOptionValues.1 = []
        }

        self.stateChangeObservable.onNext(
            self.currentState.copy(
                listingOptionValues: listingOptionValues
            )
        )
    }
}

// MARK: - Private Helpers

private extension ListingViewModel {
    func getMovieData(from moviesCoreData: [MovieCoreData]) -> [MovieData] {
        var movieData: [MovieData] = []
        moviesCoreData.forEach { movieCoreData in
            var actors = movieCoreData.actors.components(separatedBy: ",")
            var directors = movieCoreData.director.components(separatedBy: ",")
            var genre = movieCoreData.genre.components(separatedBy: ",")
            
            actors = actors.compactMap({ _actor in
                var actor = _actor
                if actor.hasPrefix(" ") {
                    actor.remove(at: actor.startIndex)
                }
                return actor
            })
            
            directors = directors.compactMap({ _director in
                var director = _director
                if director.hasPrefix(" ") {
                    director.remove(at: director.startIndex)
                }
                return director
            })
            
            genre = genre.compactMap({ _genre in
                var genre = _genre
                if genre.hasPrefix(" ") {
                    genre.remove(at: genre.startIndex)
                }
                return genre
            })
            
            movieData.append(
                MovieData(
                    actors: actors,
                    awards: movieCoreData.awards,
                    boxOffice: movieCoreData.boxOffice,
                    country: movieCoreData.country,
                    director: directors,
                    dvd: movieCoreData.dvd,
                    genre: genre,
                    imdbID: movieCoreData.imdbID,
                    imdbRating: movieCoreData.imdbRating,
                    imdbVotes: movieCoreData.imdbVotes,
                    language: movieCoreData.language,
                    metaScore: movieCoreData.metaScore,
                    plot: movieCoreData.plot,
                    poster: movieCoreData.poster,
                    production: movieCoreData.production,
                    rated: movieCoreData.rated,
                    ratings: movieCoreData.ratings,
                    released: movieCoreData.released,
                    response: movieCoreData.response,
                    runTime: movieCoreData.runTime,
                    title: movieCoreData.title,
                    type: movieCoreData.type,
                    website: movieCoreData.website,
                    writer: movieCoreData.writer,
                    year: movieCoreData.year
                )
            )
        }
        return movieData
    }
}
