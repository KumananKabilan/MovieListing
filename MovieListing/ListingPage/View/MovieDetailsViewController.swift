//
//  MovieDetailsViewController.swift
//  MovieListing
//
//  Created by Kumanan K on 14/07/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Properties

    private var movieData: MovieData!

    // MARK: - IBOutlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var castAndCrewLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = CGSize(
            width: self.scrollView.frame.width,
            height: self.scrollView.contentSize.height
        )
        self.scrollView.contentOffset = CGPoint.zero
        self.refreshUI()
    }

    func configure(with movieData: MovieData) {
        self.movieData = movieData
    }

    private func refreshUI() {
        if let url = URL(string: self.movieData.poster) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        self.titleLabel.text = self.movieData.title
        self.plotLabel.text = self.movieData.plot
        self.castAndCrewLabel.text = self.movieData.director.joined(separator: ", ") + self.movieData.actors.joined(separator: ", ") + self.movieData.writer
        self.releaseDateLabel.text = self.movieData.released
        self.genreLabel.text = self.movieData.genre.joined(separator: ", ")
        self.ratingLabel.text = "\(self.movieData.ratings)"
    }
}
