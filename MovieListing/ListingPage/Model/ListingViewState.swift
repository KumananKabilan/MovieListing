//
//  ListingViewState.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import Foundation

struct ListingViewState {
    let coreDataActionState: CoreDataActionState
    let selectedHeader: (ListingOptions, String, Int)
    let sectionHeaders: [Any]
    let cellItemData: [MovieData]
    let isSearching: Bool

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
        selectedHeader: (ListingOptions.none, "", -1),
        sectionHeaders: ListingOptions.allOptions,
        cellItemData: [],
        isSearching: false
    )

    func copy(
        coreDataActionState: CoreDataActionState? = nil,
        selectedHeader: (ListingOptions, String, Int)? = nil,
        sectionHeaders: [Any]? = nil,
        cellItemData: [MovieData]? = nil,
        isSearching: Bool? = nil
    ) -> ListingViewState {
        ListingViewState(
            coreDataActionState: coreDataActionState ?? self.coreDataActionState,
            selectedHeader: selectedHeader ?? self.selectedHeader,
            sectionHeaders: sectionHeaders ?? self.sectionHeaders,
            cellItemData: cellItemData ?? self.cellItemData,
            isSearching: isSearching ?? self.isSearching
        )
    }
}

struct MovieData {
    let actors: [String]
    let awards: String
    let boxOffice: String?
    let country: String
    let director: [String]
    let dvd: String?
    let genre: [String]
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
}
