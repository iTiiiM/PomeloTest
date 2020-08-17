//
//  StoreLocation.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import Foundation

struct StoreLocation: Codable {
    let number_of_new_locations: Int
    let pickup: [StoreLocationInformation]
}
