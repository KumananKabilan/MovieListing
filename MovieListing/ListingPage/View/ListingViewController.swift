//
//  ListingViewController.swift
//  MovieListing
//
//  Created by Kumanan K on 13/07/24.
//

import UIKit

class ListingViewController: UIViewController {
    // MARK: - Properties

    private let listingTableViewHeight: CGFloat = 44.0

    // MARK: - IBOutlets

    @IBOutlet private weak var listingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cyan
        self.configureTableView()
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
}

// MARK: - UITableViewDataSource Conformance

extension ListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as? ListingTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: String(indexPath.row))

        return cell
    }
}

// MARK: - UITableViewDelegate Conformance

extension ListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listingTableViewHeight
    }
}
