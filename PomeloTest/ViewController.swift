//
//  ViewController.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var storeLocationTableView: UITableView!
    var storeLocations: StoreLocation?
    var filteredLocations: [StoreLocationInformation]?
    let locationManager = CLLocationManager()
    var storeLocation: [CLLocation] = []
    var currentLocation: CLLocation?
    var isUpdating = false

    @IBAction func didTapGetCurrentLocation(_ sender: Any) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            print("Please set location service to be enable in settings")
        }
        
        if isUpdating {
            stopLocationManager()
        } else {
            currentLocation = nil
            startLocationManager()
            storeLocationTableView.reloadData()

        }
    }
    
    func distanceFromCurrentLocation(source: CLLocation?, destination: CLLocation) -> Int {
        if source == nil {
            return -1
        } else {
            return Int(round((source!.distance(from: destination) / 1000)))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeLocationTableView.register(UINib(nibName: StoreLocationCell.nibName, bundle: nil), forCellReuseIdentifier: StoreLocationCell.cellId)
        fetchPickupStoreLocations()
    }
    
    func fetchPickupStoreLocations() {
        let parameter = ["filter[shop_id]" : 1]
        AF.request("https://api-staging.pmlo.co/v3/pickup-locations/", parameters: parameter).validate().responseJSON { (response) in
            switch (response.result) {
                
            case .success( _):
                if let data = response.data {
                    do {
                        self.storeLocations = try
                            JSONDecoder().decode(StoreLocation.self, from: data)
                        self.filteredLocations = self.storeLocations?.pickup.filter { $0.active && !$0.city.isEmpty && !$0.alias.isEmpty }
                        self.storeLocationTableView.reloadData()
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        stopLocationManager()
    }
    
    func startLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        isUpdating = true
    }
    
    func stopLocationManager() {
        if isUpdating {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdating = false
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocationCell.cellId, for: indexPath) as! StoreLocationCell
        let distanceFromcurrentLocation = distanceFromCurrentLocation(source: currentLocation, destination: CLLocation(latitude: filteredLocations![indexPath.row].latitude ?? 0.0, longitude: filteredLocations![indexPath.row].longitude ?? 0.0))
        cell.configCell(store: filteredLocations![indexPath.row], distanceFromCurrentLocation: distanceFromcurrentLocation )
        return cell
    }
}

