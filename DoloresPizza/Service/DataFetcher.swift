//
//  DataFetcher.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import UIKit
import Combine

struct DataFetcher {
	
	/// Provides asynchronous publisher of data from Foursquare API
	/// - Returns: Publisher returns an array of tuples of information about venues and a photo of the venue. On failure returns dummy information.
	func publisher() -> AnyPublisher<[(VenueDetailInfo, UIImage?)], Never> {
		typealias InfoPlusPhotoPublisher = AnyPublisher<(VenueDetailInfo, UIImage?), Error>
		typealias ArrayOfInfosPlusPhotosPublisher = AnyPublisher<[(VenueDetailInfo, UIImage?)], Error>
		
		let pub = FoursquareRequest(resource: RecommendedVenuesBasicInfoResource()).publisher()
			.flatMap { (basicInfoArray) -> ArrayOfInfosPlusPhotosPublisher in
				
				// Get an array of publishers of InfoPlusPhoto tuples
				let detailsAndPhotoInfoPublishers = basicInfoArray.map { (basicInfo) -> InfoPlusPhotoPublisher in
					
					// Use the id obtained from the basic info to get detailed info
					let detailPub = FoursquareRequest(resource: VenueDetailResource(id: basicInfo.id)).publisher()
					
					// Use the id obtained from the basic info to get the info needed to download the photo
					let photoPub = FoursquareRequest(resource: VenueTopPhotoResource(id: basicInfo.id)).publisher()
						.flatMap { (photoInfoArray) -> AnyPublisher<UIImage?, Error> in
							let photoInfo = photoInfoArray[0]
							let url = URL(string: photoInfo.prefix + "100x100" + photoInfo.suffix)
							return PhotoGetRequest(photoURL: url!).publisher()
						}
						.eraseToAnyPublisher()
					
					// Zip the two different publishers into a publisher of a tuple
					return Publishers.Zip(detailPub, photoPub).eraseToAnyPublisher()
				}
				
				// Turn an array of publishers to a publisher of an array
				return Publishers.MergeMany(detailsAndPhotoInfoPublishers).collect().eraseToAnyPublisher()
			}
		.replaceError(with: [(VenueDetailInfo(id: "000", name: "Noname Cafe", location: VenueLocationInfo(address: "0 Nowhere Street"), rating: 0.0), nil)])
		.eraseToAnyPublisher()
		
		return pub
	}
}
