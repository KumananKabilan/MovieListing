//
//  ListingViewController.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import RxSwift
import UIKit

class ListingViewController: UIViewController {
    // MARK: - Properties

    private let headerCellHeight: CGFloat = 60.0
    private let movieCellHeight: CGFloat = 100.0
    private let disposeBag = DisposeBag()
    private var stateRepresenting: ListingViewState = .default
    var viewModel: ListingViewModel!

    // MARK: - IBOutlets

    @IBOutlet private weak var listingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movie Database"
        self.configureTableView()
        self.subscribeToStateChange()
    }
}

// MARK: - Private Helpers

private extension ListingViewController {
    func configureTableView() {
        self.listingTableView.dataSource = self
        self.listingTableView.delegate = self
        self.listingTableView.register(
            ListingTableViewCell.nib,
            forCellReuseIdentifier: ListingTableViewCell.identifier
        )
    }

    func subscribeToStateChange() {
        self.viewModel.stateChangeObservable.observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] event in
                guard let self 
                else {
                    return
                }

                switch event {
                case let .next(listingViewState):
                    self.refreshViewState(using: listingViewState)
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }

    func refreshViewState(using listingViewState: ListingViewState) {
        self.stateRepresenting = listingViewState
        self.listingTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource Conformance

extension ListingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.stateRepresenting.sectionHeaders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let subHeading = self.stateRepresenting.sectionHeaders[section] as? String,
           subHeading == self.stateRepresenting.selectedHeader.1 {
            return self.stateRepresenting.cellItemData.count + 1
        }
        if self.stateRepresenting.selectedHeader.0 == .allMovies,
           section == ListingOptions.allMovies.rawValue {
            return self.stateRepresenting.cellItemData.count + 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as? ListingTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 {
            var isCollapsed: Bool {
                if let listingOption = self.stateRepresenting.sectionHeaders[indexPath.section] as? ListingOptions {
                    listingOption != self.stateRepresenting.selectedHeader.0
                } else if let subHeading = self.stateRepresenting.sectionHeaders[indexPath.section] as? String {
                    subHeading != self.stateRepresenting.selectedHeader.1
                } else {
                    false
                }
            }
            cell.configureAsHeader(
                with: self.stateRepresenting.sectionHeaders[indexPath.section],
                isCollapsed: isCollapsed
            )
        } else {
            cell.configureMovieCell(
                using: self.stateRepresenting.cellItemData[indexPath.row - 1]
            )
        }

        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate Conformance

extension ListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.headerCellHeight
        }
        return self.movieCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.viewModel.headerCellSelected(index: indexPath.section)
        } else {
            let listingStoryboard = UIStoryboard(name: "Listing", bundle: nil)
            if let movieDetailsViewController = listingStoryboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
                movieDetailsViewController.modalPresentationStyle = .formSheet
                movieDetailsViewController.configure(
                    with: self.stateRepresenting.cellItemData[indexPath.row - 1]
                )
                let navController = UINavigationController(rootViewController: movieDetailsViewController)
                movieDetailsViewController.title = "Movie Details"
                self.present(navController, animated: true)
            }
        }
    }
}
