//
//  Copyright © Essential Developer. All rights reserved.
//

import UIKit

protocol FeedViewControllerDelegate {
	func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
	var delegate: FeedViewControllerDelegate?

	private var tableModel = [FeedImageCellController]() {
		didSet { tableView.reloadData() }
	}

	@IBOutlet private(set) public var errorView: ErrorView!

	public override func viewDidLoad() {
		super.viewDidLoad()

		refresh()
	}

	@IBAction private func refresh() {
		delegate?.didRequestFeedRefresh()
	}

	func display(_ cellControllers: [FeedImageCellController]) {
		tableModel = cellControllers
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableView.sizeTableHeaderToFit()
	}

	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cellController(forRowAt: indexPath).view(in: tableView)
	}

	public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cancelCellControllerLoad(forRowAt: indexPath)
	}

	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			cellController(forRowAt: indexPath).preload()
		}
	}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach(cancelCellControllerLoad)
	}

	private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
		return tableModel[indexPath.row]
	}

	private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
		cellController(forRowAt: indexPath).cancelLoad()
	}
}

extension FeedViewController: FeedLoadingView {
	func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			refreshControl?.beginRefreshing()
		} else {
			refreshControl?.endRefreshing()
		}
	}
}

extension FeedViewController: FeedErrorView {
	func display(_ viewModel: FeedErrorViewModel) {
		if let errorMessage = viewModel.errorMessage {
			errorView.show(message: errorMessage)
		}else{
			errorView.hideMessage()
		}
	}
}
