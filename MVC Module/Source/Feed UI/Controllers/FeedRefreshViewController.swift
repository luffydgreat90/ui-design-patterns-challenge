//
//  Copyright © Essential Developer. All rights reserved.
//

import UIKit
import FeedFeature

final class FeedRefreshViewController: NSObject {
	@IBOutlet private(set) public var view: UIRefreshControl?
	@IBOutlet private(set) public var errorView: ErrorView?

	var feedLoader: FeedLoader?
	var onRefresh: (([FeedImage]) -> Void)?

	@IBAction func refresh() {
		view?.beginRefreshing()
		errorView?.hideMessage()
		feedLoader?.load { [weak self] result in
			self?.handle(result)
		}
	}

	private func handle(_ result: FeedLoader.Result) {
		switch result {
		case let .success(feed):
			onRefresh?(feed)
		case .failure:
			errorView?.show(message: Localized.Feed.loadError)
		}
		view?.endRefreshing()
	}
}
