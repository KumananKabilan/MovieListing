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

    private let listingTableViewHeight: CGFloat = 44.0
    private let disposeBag = DisposeBag()
    private var stateRepresenting: ListingViewState = .default
    var viewModel: ListingViewModel!

    // MARK: - IBOutlets

    @IBOutlet private weak var listingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cyan
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stateRepresenting.titleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as? ListingTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: self.stateRepresenting.titleArray[indexPath.row])

        return cell
    }
}

// MARK: - UITableViewDelegate Conformance

extension ListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listingTableViewHeight
    }
}
