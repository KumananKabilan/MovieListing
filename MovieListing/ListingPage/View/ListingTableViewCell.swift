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
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collapseImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.reset()
    }

    private func reset() {
        self.headerViewStackView.isHidden = true
        self.headerLabel.text = "..."
        self.stackViewLeadingConstraint.constant = self.defaultHeaderPadding
    }
}

// MARK: - Helpers

extension ListingTableViewCell {
    func configureAsHeader(
        with data: Any,
        isCollapsed: Bool
    ) {
        self.headerViewStackView.isHidden = false
        self.collapseImageView.transform = isCollapsed ? .identity : CGAffineTransform(rotationAngle: CGFloat.pi)
        if let listingOption = data as? ListingOptions {
            self.headerLabel.text = listingOption.title
            self.stackViewLeadingConstraint.constant = self.defaultHeaderPadding
        } else if let subHeading = data as? String {
            self.headerLabel.text = subHeading
            self.stackViewLeadingConstraint.constant = self.subHeadingPadding
        }
    }
}
