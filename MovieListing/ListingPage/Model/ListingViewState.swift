//
//  ListingViewState.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import Foundation

struct ListingViewState {
    let titleArray: [String]
}

// MARK: - Helper

extension ListingViewState {
    static let `default` = ListingViewState(
        titleArray: []
    )

    func copy(
        titleArray: [String]? = nil
    ) -> ListingViewState {
        ListingViewState(
            titleArray: titleArray ?? self.titleArray
        )
    }
}
