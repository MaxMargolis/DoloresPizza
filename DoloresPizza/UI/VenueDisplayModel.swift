//
//  VenueDisplayModel.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import UIKit

/// Everything needed to display relevant details about a venue
struct VenueDisplayModel: Identifiable {
	/// Unique identifier of the venue
	let id: String
	/// Name of the venue
	let name: String
	/// Address of the venue
	let address: String
	/// Rating of the venue between 1 and 10
	let rating: String
	/// A photo related to the venue
	let photo: UIImage
	
	init(id: String, name: String, address: String, rating: String, photo: UIImage) {
		self.id = id
		self.name = name
		self.address = address
		self.rating = rating
		self.photo = photo
	}
	
	init(venueDetailInfo: VenueDetailInfo, photo: UIImage?) {
		self.id = venueDetailInfo.id
		self.name = venueDetailInfo.name
		self.address = venueDetailInfo.location.address
		self.rating = String(venueDetailInfo.rating)
		self.photo = photo ?? UIImage(named: "cafePhotoPlaceHolder.jpg")!
	}
}
