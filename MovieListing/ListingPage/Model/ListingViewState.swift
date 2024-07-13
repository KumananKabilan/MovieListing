//
//  ListingViewState.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import Foundation

struct ListingViewState {
    let coreDataActionState: CoreDataActionState
    let titleArray: [String]

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
        titleArray: []
    )

    func copy(
        coreDataActionState: CoreDataActionState? = nil,
        titleArray: [String]? = nil
    ) -> ListingViewState {
        ListingViewState(
            coreDataActionState: coreDataActionState ?? self.coreDataActionState,
            titleArray: titleArray ?? self.titleArray
        )
    }
}
