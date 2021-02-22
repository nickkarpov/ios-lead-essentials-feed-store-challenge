//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Nick on 19/02/2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class InMemoryFeedStore {
	private var cache: (feed: [LocalFeedImage], timestamp: Date)?
	private let operationsQueue = DispatchQueue(label: "\(type(of: InMemoryFeedStore.self))Queue",
												qos: .background,
												attributes: .concurrent)

	public init() {}
}

extension InMemoryFeedStore: FeedStore {
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		operationsQueue.async(flags: .barrier) { [weak self] in
			self?.cache = nil
			completion(nil)
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		operationsQueue.async(flags: .barrier) { [weak self] in
			self?.cache = (feed: feed, timestamp: timestamp)
			completion(nil)
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		operationsQueue.async { [cache] in
			guard let cachedFeed = cache else {
				completion(.empty)
				return
			}
			completion(.found(feed: cachedFeed.feed, timestamp: cachedFeed.timestamp))
		}
	}
}
