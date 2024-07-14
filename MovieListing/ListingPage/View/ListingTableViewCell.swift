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

    @IBOutlet private weak var movieViewStackView: UIStackView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.reset()
    }

    private func reset() {
        self.headerViewStackView.isHidden = true
        self.headerLabel.text = "..."
        self.stackViewLeadingConstraint.constant = self.defaultHeaderPadding

        self.movieViewStackView.isHidden = true
        self.movieImageView.image = UIImage(systemName: "photo")
        self.movieTitle.text = "..."
        self.languageLabel.text = "..."
        self.yearLabel.text = "..."
    }
}

// MARK: - Helpers

extension ListingTableViewCell {
    func configureAsHeader(
        with data: Any,
        isCollapsed: Bool
    ) {
        self.reset()

        self.movieViewStackView.isHidden = true
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

    func configureMovieCell(
        using movieData: MovieData
    ) {
        self.reset()

        self.headerViewStackView.isHidden = true
        self.movieViewStackView.isHidden = false

        if let url = URL(string: movieData.poster) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.movieImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        self.movieTitle.text = movieData.title
        self.languageLabel.text = movieData.language
        self.yearLabel.text = movieData.year
    }
}
