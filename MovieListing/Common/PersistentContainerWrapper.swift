//
//  PersistentContainerWrapper.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import CoreData

enum PersistentContainerState {
    case none
    case loading
    case failed(error: Error)
    case loaded(container: NSPersistentContainer)
}

class PersistentContainerWrapper {
    private var container: NSPersistentContainer
    private(set) var containerState: PersistentContainerState

    init(name: String) {
        self.container = NSPersistentContainer(name: name)
        self.containerState = .loading

        self.loadData()
    }

    private func loadData() {
        self.container.loadPersistentStores { _, error in
            if let error = error {
                self.containerState = .failed(error: error)
            } else {
                self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                self.containerState = .loaded(container: self.container)
            }
        }
    }
}
