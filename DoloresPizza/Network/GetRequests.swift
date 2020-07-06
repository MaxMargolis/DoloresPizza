//
//  GetRequests.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import UIKit
import Combine

protocol GetRequest {
	associatedtype PublisherType
	func publisher() -> AnyPublisher<PublisherType, Error>
}

extension GetRequest {
	
	/// Starts off a get request pipeline with a basic data task with error handling
	fileprivate func startPipeline(from url: URL) -> AnyPublisher<Data, Error> {
		// Basic dataTask
		let dataPub = URLSession.shared.dataTaskPublisher(for: url)
		.tryMap { (data: Data, response: URLResponse) -> Data in

			guard let httpResponse = response as? HTTPURLResponse else {
				throw HTTPError.nonHTTPResponse
			}
			guard httpResponse.statusCode == 200 else {
				print("Response error. Code: \(httpResponse.statusCode).\n Response: \(httpResponse) ")
				throw HTTPError.statusCodeError(code: httpResponse.statusCode)
			}
			
			return data
		}
		.eraseToAnyPublisher()
		
		return dataPub
	}
}

enum HTTPError: LocalizedError {
	case nonHTTPResponse
	case statusCodeError(code: Int)
}

// MARK: Foursquare Request

struct FoursquareRequest<Resource: FoursquareResource> {
	let resource: Resource
}

extension FoursquareRequest: GetRequest {
	
	typealias PublisherType = Resource.PublisherType
	
	func publisher() -> AnyPublisher<Resource.PublisherType, Error> {
		
		// Take the starting pipeline and convert from the WrapperType to the PublisherType
		let pub = startPipeline(from: resource.url)
			.decode(type: Resource.WrapperType.self, decoder: JSONDecoder())
			.map { (wrapper) -> PublisherType in
				return self.resource.convert(wrapper: wrapper)
			}
			.eraseToAnyPublisher()
		
		return pub
	}
}

// MARK: Photo Request

struct PhotoGetRequest {
	let photoURL: URL
}

extension PhotoGetRequest: GetRequest {
	func publisher() -> AnyPublisher<UIImage?, Error> {
		let pub = startPipeline(from: photoURL)
		.map { UIImage(data: $0)}
		.eraseToAnyPublisher()
		
		return pub
	}
}
