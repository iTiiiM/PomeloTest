//
//  StoreLocation.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import Foundation

struct PickupStoreLocation: Codable {
    let numberOfNewLocations: Int
    let pickup: [PickupStoreLocationInformation]
    
    enum CodingKeys: String, CodingKey {
        case numberOfNewLocations = "number_of_new_locations"
        case pickup
    }
}
