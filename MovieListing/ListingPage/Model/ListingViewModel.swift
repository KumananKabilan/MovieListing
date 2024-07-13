//
//  ListingViewModel.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import RxSwift

class ListingViewModel {
    // MARK: - Properties

    private let titleArray: [String] = [
        "Kums",
        "Sherie",
        "Ramvi",
        "Suchin",
        "Yohesh",
        "Achu",
        "Poongi",
        "Narmadha",
        "Vichu"
    ]

    let stateChangeObservable: BehaviorSubject<ListingViewState> = BehaviorSubject(value: .default)

    init() {
        self.stateChangeObservable.onNext(ListingViewState(titleArray: titleArray))
    }
}
