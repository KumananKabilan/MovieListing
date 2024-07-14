//
//  ListingTableViewCell.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    // MARK: - Properties

    private let subHeadingPadding: CGFloat = 50.0

    // MARK: - IBOutlets

    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collapseImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.reset()
    }

    private func reset() {
        self.movieTitle.text = "..."
        self.stackViewLeadingConstraint.constant = 0
    }
}

// MARK: - Helpers

extension ListingTableViewCell {
    func configureAsHeader(
        with text: String,
        isSectionHeader: Bool,
        isCollapsed: Bool
    ) {
        self.movieTitle.text = text
        self.stackViewLeadingConstraint.constant = isSectionHeader ? 0 : self.subHeadingPadding
        self.collapseImageView.transform = isCollapsed ? .identity : CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}
