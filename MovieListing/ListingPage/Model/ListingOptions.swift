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

    static var allOptions: [ListingOptions] {
        var array: [ListingOptions] = []
        ListingOptions.allCases.forEach { listingOption in
            if listingOption != .none {
                array.append(listingOption)
            }
        }
        return array
    }
}
