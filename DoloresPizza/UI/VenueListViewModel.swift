//
//  VenueListViewModel.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import UIKit
import Combine

class VenueListViewModel : ObservableObject {
	
	@Published var venues = [VenueDisplayModel]()
	
	private let dataFetcher = DataFetcher()
	private var dataStream: AnyCancellable?
	
	init() {
		dataStream = dataFetcher.publisher().sink(receiveValue: { [weak self] (venueInfoAndPhotoArray) in
			let displayModels = venueInfoAndPhotoArray.map {venueInfoAndPhoto -> VenueDisplayModel in
				return VenueDisplayModel(venueDetailInfo: venueInfoAndPhoto.0, photo: venueInfoAndPhoto.1)
			}
			DispatchQueue.main.async {
				self?.venues = displayModels.sorted(by: { (model1, model2) -> Bool in
					return Double(model1.rating)! >= Double(model2.rating)!
				})
			}
		})
	}
}
