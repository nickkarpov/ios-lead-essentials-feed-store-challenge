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

	private let operationsQueue = DispatchQueue(label: "\(type(of: InMemoryFeedStore.self))Queue",
												qos: .background,
												attributes: .concurrent)

	public init() {}
}

extension InMemoryFeedStore: FeedStore {
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		operationsQueue.async(flags: .barrier) {
			self.cachedFeed.removeAll()
			completion(nil)
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		operationsQueue.async(flags: .barrier) { [weak self] in
			self?.cachedFeed = feed
			self?.lastUpdate = timestamp
			completion(nil)
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		operationsQueue.async { [cachedFeed, lastUpdate] in
			if cachedFeed.isEmpty {
				completion(.empty)
			} else {
				completion(.found(feed: cachedFeed, timestamp: lastUpdate))
			}
		}
	}
}
