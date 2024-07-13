//
//  BehaviourSubjectHelper.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import RxSwift

extension BehaviorSubject {
    var helperSafeValue: Element {
        do {
            return try self.value()
        } catch {
            fatalError("Failed to query value from BehaviourSubject: \(self)")
        }
    }
}
