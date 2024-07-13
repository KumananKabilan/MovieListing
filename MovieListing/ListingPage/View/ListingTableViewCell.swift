//
//  ListingTableViewCell.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.reset()
    }

    private func reset() {
        self.movieTitle.text = "..."
    }
}

// MARK: - Helpers

extension ListingTableViewCell {
    func configure(with text: String) {
        self.movieTitle.text = text
    }
}
