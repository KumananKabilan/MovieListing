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

    private let listingTableViewHeight: CGFloat = 60.0
    private let disposeBag = DisposeBag()
    private var stateRepresenting: ListingViewState = .default
    var viewModel: ListingViewModel!

    // MARK: - IBOutlets

    @IBOutlet private weak var listingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
            UINib(nibName: "ListingTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ListingTableViewCell"
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
        ListingOptions.allCases.count - 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ListingOptions.allCases[section] == self.stateRepresenting.listingOptionValues.0 {
            return self.stateRepresenting.listingOptionValues.1.count + 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as? ListingTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.section == self.stateRepresenting.listingOptionValues.0.rawValue,
           indexPath.row != 0 {
            switch self.stateRepresenting.listingOptionValues.0 {
            case .year:
                cell.configureAsHeader(
                    with: self.stateRepresenting.listingOptionValues.1[indexPath.row - 1],
                    isSectionHeader: false,
                    isCollapsed: true
                )
            case .genre:
                cell.configureAsHeader(
                    with: self.stateRepresenting.listingOptionValues.1[indexPath.row - 1],
                    isSectionHeader: false,
                    isCollapsed: true
                )
            case .directors:
                cell.configureAsHeader(
                    with: self.stateRepresenting.listingOptionValues.1[indexPath.row - 1],
                    isSectionHeader: false,
                    isCollapsed: true
                )
            case .actors:
                cell.configureAsHeader(
                    with: self.stateRepresenting.listingOptionValues.1[indexPath.row - 1],
                    isSectionHeader: false,
                    isCollapsed: true
                )
            case .allMovies:
                cell.configureAsHeader(
                    with: "",
                    isSectionHeader: false,
                    isCollapsed: true
                )
            case .none:
                cell.configureAsHeader(
                    with: "",
                    isSectionHeader: false,
                    isCollapsed: true
                )
            }
        } else {
            cell.configureAsHeader(
                with: ListingOptions.allCases[indexPath.section].title,
                isSectionHeader: true,
                isCollapsed: self.stateRepresenting.listingOptionValues.0.rawValue != indexPath.section
            )
        }

        cell.selectionStyle = .default
        return cell
    }
}

// MARK: - UITableViewDelegate Conformance

extension ListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listingTableViewHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingOption = ListingOptions.allCases[indexPath.section]
        if listingOption == self.stateRepresenting.listingOptionValues.0 {
            self.viewModel.cellSelected(listingOption: .none)
        } else {
            self.viewModel.cellSelected(listingOption: listingOption)
        }
    }
}
