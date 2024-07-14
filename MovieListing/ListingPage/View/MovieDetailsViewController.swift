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
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var percentageView: PercentageView!
    
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
//        for ratingData in self.movieData.ratings {
        self.movieData.ratings.forEach { ratingData in
            var source: String = ""
            if self.segmentControl.selectedSegmentIndex == 0 {
                source = "Internet Movie Database"
            }
            if self.segmentControl.selectedSegmentIndex == 1 {
                source = "Rotten Tomatoes"
            }
            if self.segmentControl.selectedSegmentIndex == 2 {
                source = "Metacritic"
            }

            if source == ratingData.source {
                var value: CGFloat = 0.0
                if ratingData.value.hasSuffix("%") {
                    let numericString = ratingData.value.trimmingCharacters(in: CharacterSet(charactersIn: "%"))
                    if let floatValue = Float(numericString) {
                        value = CGFloat(floatValue / 100.0)
                    }
                } else {
                    let components = ratingData.value.components(separatedBy: "/")
                    if components.count == 2,
                       let value1 = Float(components[0]),
                       let value2 = Float(components[1]) {
                        value = CGFloat(value1) / CGFloat(value2)
                    }
                }

                self.percentageView.configure(for: value)
            }
        }
    }
}

// MARK: - IBActions

private extension MovieDetailsViewController {
    @IBAction func actionSegmentControlClicked(_ sender: UISegmentedControl) {
        self.movieData.ratings.forEach { ratingData in
            var source: String = ""
            if sender.selectedSegmentIndex == 0 {
                source = "Internet Movie Database"
            }
            if sender.selectedSegmentIndex == 1 {
                source = "Rotten Tomatoes"
            }
            if sender.selectedSegmentIndex == 2 {
                source = "Metacritic"
            }

            if source == ratingData.source {
                var value: CGFloat = 0.0
                if ratingData.value.hasSuffix("%") {
                    let numericString = ratingData.value.trimmingCharacters(in: CharacterSet(charactersIn: "%"))
                    if let floatValue = Float(numericString) {
                        value = CGFloat(floatValue / 100.0)
                    }
                } else {
                    let components = ratingData.value.components(separatedBy: "/")
                    if components.count == 2,
                       let value1 = Float(components[0]),
                       let value2 = Float(components[1]) {
                        value = CGFloat(value1) / CGFloat(value2)
                    }
                }

                self.percentageView.configure(for: value)
            }
        }
    }
}

class PercentageView: UIControl {
    var percentage: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let fillColor = UIColor.systemYellow
        let backgroundColor = UIColor.lightGray

        let bgPath = UIBezierPath(rect: rect)
        backgroundColor.setFill()
        bgPath.fill()

        let fillRectWidth = rect.width * percentage
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: fillRectWidth, height: rect.height)
        let fillPath = UIBezierPath(rect: fillRect)
        fillColor.setFill()
        fillPath.fill()
    }

    func configure(for value: CGFloat) {
        self.percentage = value
    }
}
