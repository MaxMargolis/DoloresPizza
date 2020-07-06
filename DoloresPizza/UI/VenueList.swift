//
//  VenueList.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import SwiftUI

struct VenueList: View {
	
	@ObservedObject var venueListViewModel = VenueListViewModel()
    var body: some View {
		List(venueListViewModel.venues) {venue in
			VenueListRow(venue: venue)
		}
    }
}

//struct VenueList_Previews: PreviewProvider {
//    static var previews: some View {
//        VenueList()
//    }
//}
