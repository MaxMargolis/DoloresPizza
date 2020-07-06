//
//  NetworkModels.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import Foundation

/// Basic information about a venue
struct VenueBasicInfo : Decodable {
	/// Unique identifier of the venue
	let id: String
	/// Name of the venue
	let name: String
}

/// Wrapper for `[VenueBasicInfo]`
struct ExploreVenuesResult: Decodable {
	let response : Response
	
	struct Response : Decodable {
		let groups: [Groups]
	}
	struct Groups : Decodable {
		let items: [VenueBasicInfoWrapper]
	}
	struct VenueBasicInfoWrapper: Decodable {
		let venue: VenueBasicInfo
	}
}

/// Detailed information about a venue
struct VenueDetailInfo : Decodable {
	/// Unique identifier of the venue
	let id: String
	/// Name of the venue
	let name: String
	/// Information regarding the location of the venue
	let location: VenueLocationInfo
	/// Rating of the venue. Between 1 and 10.
	let rating: Double
}

/// Wrapper for `VenueDetailInfo`
struct VenueDetailResult : Decodable {
	let response: Response
	
	struct Response: Decodable {
		let venue: VenueDetailInfo
	}
}

/// Information regarding the location of a venue
struct VenueLocationInfo : Decodable {
	/// Street address of the venue
	let address : String
}

/// Information about a photo of a venue
struct VenuePhotoInfo : Decodable {
	/// Unique identifier of the photo (not the venue)
	let id: String
	/// Prefix for constructing the url of the photo
	let prefix: String
	/// Suffix for constructing the url of the photo
	let suffix: String
}

/// Wrapper for `[VenuePhotoInfo]`
struct VenuePhotosResult : Decodable {
	let response: Response
	struct Response: Decodable {
		let photos: Photos
	}
	struct Photos: Decodable {
		let items: [VenuePhotoInfo]
	}
}

