//
//  ListingTableViewCell.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    // MARK: - Properties

    private let subHeadingPadding: CGFloat = 30.0
    private let defaultHeaderPadding: CGFloat = 10.0

    // MARK: - IBOutlets

    @IBOutlet private weak var headerViewStackView: UIStackView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collapseImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.reset()
    }

    private func reset() {
        self.headerViewStackView.isHidden = true
        self.movieTitle.text = "..."
        self.stackViewLeadingConstraint.constant = self.defaultHeaderPadding
    }
}

// MARK: - Helpers

extension ListingTableViewCell {
    func configureAsHeader(
        with text: String,
        isSectionHeader: Bool,
        isCollapsed: Bool
    ) {
        self.headerViewStackView.isHidden = false
        self.movieTitle.text = text
        self.stackViewLeadingConstraint.constant = isSectionHeader ? self.defaultHeaderPadding : self.subHeadingPadding
        self.collapseImageView.transform = isCollapsed ? .identity : CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}
