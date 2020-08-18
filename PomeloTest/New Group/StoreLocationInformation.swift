//
//  StoreLocationInformation.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import Foundation

struct StoreLocationInformation: Codable {
    let alias: String
    let city: String
    let address1: String
    let active: Bool
    let latitude: Double?
    let longitude: Double?
}
