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
    private var currentState: ListingViewState {
        self.stateChangeObservable.helperSafeValue
    }
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.performCoreDataFetch()
    }
}

// MARK: - Private Helpers

private extension ListingViewModel {
    func saveToCoreData() {
        for (index, title) in self.titleArray.enumerated() {
            let moviesEntity = Movies(context: self.managedObjectContext)
            moviesEntity.title = title
            do {
                try self.managedObjectContext.save()
            } catch {
                self.stateChangeObservable.onNext(self.currentState.copy(coreDataActionState: .failedToSave))
                break
            }
            if index == (self.titleArray.count - 1) {
                self.stateChangeObservable.onNext(self.currentState.copy(coreDataActionState: .savingSuccess))
            }
        }
    }

    func initiateFetchFromCoreData() -> [String] {
        do {
            let fetchedData = try self.managedObjectContext.fetch(Movies.fetchRequest())
            return fetchedData.helperMovieTitles
        } catch {
            self.stateChangeObservable.onNext(self.currentState.copy(coreDataActionState: .failedToFetch))
        }
        return []
    }

    func performCoreDataFetch() {
        let titleArray = self.initiateFetchFromCoreData()
        if titleArray.isEmpty {
            self.saveToCoreData()
        }
        self.stateChangeObservable.onNext(self.currentState.copy(coreDataActionState: .fetchingSuccess, titleArray: titleArray))
    }

    func resetCoreData() { // Used when SampleData was replaced with OriginalData
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Movies.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.managedObjectContext.execute(batchDeleteRequest)
            try self.managedObjectContext.save()
        } catch {
            print("Failed to delete items: \(error)")
        }
    }
}
