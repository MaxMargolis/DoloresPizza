//
//  FoursquareResources.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import Foundation
import Combine


/// For creating network models to access the Foursquare API
protocol FoursquareResource {
	associatedtype WrapperType: Decodable
	associatedtype PublisherType
	func convert(wrapper: WrapperType) -> PublisherType
	var path: String { get set }
	var queryItems: [URLQueryItem] { get }
}

extension FoursquareResource {
	var url: URL {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.foursquare.com"
		components.path = path
		
		assert(FoursquareKeys.clientID.count != 0 && FoursquareKeys.clientSecret.count != 0, "Hi there. You need to set your API Keys in ApiKeys.swift")
		
		let clientID = URLQueryItem(name: "client_id", value: FoursquareKeys.clientID)
		let clientSecret = URLQueryItem(name: "client_secret", value: FoursquareKeys.clientSecret)
		let version = URLQueryItem(name: "v", value: "20200601")
		let baseQueryItems = [clientID, clientSecret, version]
		components.queryItems = baseQueryItems + self.queryItems
		
		return components.url!
	}
}

/// Basic info on recommended pizza places near Dolores Park
struct RecommendedVenuesBasicInfoResource : FoursquareResource {
	typealias WrapperType = ExploreVenuesResult
	typealias PublisherType = [VenueBasicInfo]
	
	var path = "/v2/venues/explore"
	let queryItems = [RecommendedVenuesBasicInfoResource.locationQueryItem, RecommendedVenuesBasicInfoResource.venueTypeQueryItem, RecommendedVenuesBasicInfoResource.limitQueryItem]
	
	func convert(wrapper: ExploreVenuesResult) -> [VenueBasicInfo] {
		return wrapper.response.groups[0].items.map {$0.venue}
	}
		
	private static let locationQueryItem = URLQueryItem(name: "ll", value: "37.759773,-122.427063")
	private static let venueTypeQueryItem = URLQueryItem(name: "query", value: "pizza")
	private static let limitQueryItem = URLQueryItem(name: "limit", value: String(Constants.numberOfVenuesToRequest))
}

/// Detail info on the venue with id passed in as init parameter
struct VenueDetailResource : FoursquareResource {
	typealias WrapperType = VenueDetailResult
	typealias PublisherType = VenueDetailInfo
	
	var path = "/v2/venues/"
	let queryItems = [URLQueryItem]()
	
	func convert(wrapper: VenueDetailResult) -> VenueDetailInfo {
		return wrapper.response.venue
	}
	
	init(id: String) {
		path += id
	}
}

/// The top photo for the venue with id passed in as init parameter
struct VenueTopPhotoResource: FoursquareResource {
	typealias WrapperType = VenuePhotosResult
	typealias PublisherType = [VenuePhotoInfo]
	
	var path = "/v2/venues/"
	let queryItems = [URLQueryItem(name: "limit", value: "1")]
	
	func convert(wrapper: VenuePhotosResult) -> [VenuePhotoInfo] {
		return wrapper.response.photos.items
	}
	
	init(id: String) {
		path += "\(id)/photos"
	}
}
