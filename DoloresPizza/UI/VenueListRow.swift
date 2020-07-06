//
//  VenueListRow.swift
//  DoloresPizza
//
//  Created by Max Margolis on 7/6/20.
//  Copyright © 2020 Max Margolis. All rights reserved.
//

import SwiftUI

struct VenueListRow: View {
	
	let venue : VenueDisplayModel
	
    var body: some View {
		HStack {
			VStack(alignment:.leading) {
				Text(venue.name)
				Text(venue.address)
				Text(venue.rating + " rating")
			}
			Spacer()
			Image(uiImage: venue.photo)
		}
    }
}

//struct VenueListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        VenueListRow()
//    }
//}
