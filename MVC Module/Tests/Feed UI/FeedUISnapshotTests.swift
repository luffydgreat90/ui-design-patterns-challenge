//
//  Copyright © Essential Developer. All rights reserved.
//

import XCTest
import FeedFeature
@testable import MVC

class FeedUISnapshotTests: XCTestCase {
	func test_emptyFeed() {
		let sut = makeSUT()

		sut.display(emptyFeed())

		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_FEED_light")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_FEED_dark")
	}

	func test_feedWithError() {
		let sut = makeSUT()

		sut.display(errorMessage: "An error message")

		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_ERROR_light")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_ERROR_dark")
	}

	// MARK: - Helpers

	private func makeSUT() -> FeedViewController {
		let bundle = Bundle(for: FeedViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! FeedViewController
		controller.refreshController?.feedLoader = AlwaysSucceedingFeedLoader()
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func emptyFeed() -> [FeedImageCellController] {
		[]
	}
}

private class AlwaysSucceedingFeedLoader: FeedLoader {
	func load(completion: @escaping (FeedLoader.Result) -> Void) {
		completion(.success([]))
	}
}

private extension FeedViewController {
	func display(errorMessage: String) {
		refreshController?.errorView?.show(message: errorMessage)
	}

	func display(_ feed: [FeedImageCellController]) {
		tableModel = feed
	}
}
