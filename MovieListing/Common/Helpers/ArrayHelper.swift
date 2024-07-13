//
//  ArrayHelper.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

extension Array where Element == Movies {
    var helperMovieTitles: [String] {
        var array: [String] = []
        self.forEach { movie in
            if let title = movie.title {
                array.append(title)
            }
        }
        return array
    }
}
