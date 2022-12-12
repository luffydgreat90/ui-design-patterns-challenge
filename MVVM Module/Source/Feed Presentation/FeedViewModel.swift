//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation
import FeedFeature

final class FeedViewModel {
	typealias Observer<T> = (T) -> Void

	private let feedLoader: FeedLoader

	init(feedLoader: FeedLoader) {
		self.feedLoader = feedLoader
	}

	var title: String {
		Localized.Feed.title
	}

	var onLoadingStateChange: Observer<Bool>?
	var onFeedLoad: Observer<[FeedImage]>?
	var onErrorLoad: Observer<String?>?

	func loadFeed() {
		onLoadingStateChange?(true)
		onErrorLoad?(.none)

		feedLoader.load { [weak self] result in

			switch result {
			case let .success(feed):
				self?.onFeedLoad?(feed)
			case .failure:
				self?.onErrorLoad?(Localized.Feed.error)
			}

			self?.onLoadingStateChange?(false)
		}
	}
}
