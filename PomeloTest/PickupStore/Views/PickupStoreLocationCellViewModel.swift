//
//  PickupStoreLocationCellViewModel.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 19/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import Foundation

struct PickupStoreLocationCellViewModel {
    var store: PickupStoreLocationInformation
    var distanceFromCurrentLocation: Int
    
    var city: String {
        return store.city
    }
    var address: String {
        return store.address1
    }
    
    var alias: String {
        return store.alias
    }
    
    func shouldHideDistanceFromCurrentLocation() -> Bool{
        if distanceFromCurrentLocation == -1 {
            return true
        }
        return false
    }
    
    init(store: PickupStoreLocationInformation, distanceFromCurrentLocation: Int) {
        self.store = store
        self.distanceFromCurrentLocation = distanceFromCurrentLocation
    }
}
