//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Nick on 19/02/2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class InMemoryFeedStore {
	private var cachedFeed = [LocalFeedImage]()
	private var lastUpdate = Date()

	public init() {
	}
}

extension InMemoryFeedStore: FeedStore {
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		cachedFeed.removeAll()
		completion(nil)
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		cachedFeed = feed
		lastUpdate = timestamp
		completion(nil)
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		if cachedFeed.isEmpty {
			completion(.empty)
		} else {
			completion(.found(feed: cachedFeed, timestamp: lastUpdate))
		}
	}
}
