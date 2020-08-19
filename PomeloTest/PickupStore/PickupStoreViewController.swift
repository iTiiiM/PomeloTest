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
import PopupDialog

class PickupStoreViewController: UIViewController {
    // I've tried to move logic to viewModel but I got stuck with it. when tapped on getCurrentLocation it get another row of data I need to learn more of RxSwift to do that properly
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var storeLocationTableView: UITableView!
    
    let locationManager = CLLocationManager()
    var isUpdating = false
    
    var filteredLocations: [PickupStoreLocationInformation]? {
        didSet {
            self.storeLocationTableView.reloadData()
        }
    }
    
    var currentLocation: CLLocation? {
        didSet {
            self.storeLocationTableView.reloadData()
        }
    }
    
    var sortedLocations: [PickupStoreLocationInformation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        storeLocationTableView.register(UINib(nibName: PickupStoreLocationCell.nibName, bundle: nil), forCellReuseIdentifier: PickupStoreLocationCell.cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPickupStoreLocations()
    }
    
    @IBAction func didTapGetCurrentLocation(_ sender: Any) {
        getCurrentLocation()
    }
    
    func fetchPickupStoreLocations() {
        let parameter = ["filter[shop_id]" : 1]
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
        AF.request("https://api-staging.pmlo.co/v3/pickup-locations/", parameters: parameter).validate().responseJSON { (response) in
            switch (response.result) {
                
            case .success( _):
                if let data = response.data {
                    do {
                        let storeLocations = try
                            JSONDecoder().decode(PickupStoreLocation.self, from: data)
                        self.filteredLocations = storeLocations.pickup.filter { $0.active && !$0.city.isEmpty && !$0.alias.isEmpty }
                    } catch let error as NSError {
                        let popUpDialog = PopupDialog(title: "Failed to load: \(error.localizedDescription)", message: "Please try again")
                        self.present(popUpDialog, animated: true)
                    }
                }
                
            case .failure(let error):
                let popUpDialog = PopupDialog(title: "Request error: \(error.localizedDescription)", message: "Please try again")
                self.present(popUpDialog, animated: true)
            }
            self.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView.isHidden = true
        }
    }
    
    func sortNearestStoreLocation() {
           if filteredLocations != nil {
               //MARK : Tried to add "distanceFromCurrentLocation" attribute to each data in filteredLocations Array.
               
               //But the value assign to for loop is only in the loop
               
               //I don't know how to assign to itself directly
               
               //So I create another variable to recieve it (WHICH IS BAD)
               for var storeInformation in filteredLocations!  {
                   storeInformation.distanceFromCurrentLocation = getDistanceFromCurrentLocation(destination: CLLocation(latitude: storeInformation.latitude!, longitude: storeInformation.longitude!))
                   sortedLocations.append(storeInformation)
               }
               filteredLocations = sortedLocations
               sortedLocations = []
               filteredLocations?.sort(by: { $0.distanceFromCurrentLocation ?? 0 < $1.distanceFromCurrentLocation ?? 0})
               self.storeLocationTableView.reloadData()
           }
       }
       
       func getCurrentLocation() {
        
           let authorizationStatus = CLLocationManager.authorizationStatus()
           if authorizationStatus == .notDetermined {
               locationManager.requestWhenInUseAuthorization()
           } else if authorizationStatus == .denied || authorizationStatus == .restricted {
               let popUpDialog = PopupDialog(title: "Please set location service to be enable in settings", message: "to see nearest store")
               self.present(popUpDialog, animated: true)
           }
           
           if isUpdating {
               stopLocationManager()
           } else {
               currentLocation = nil
               startLocationManager()
           }
       }
       
       func getDistanceFromCurrentLocation(destination: CLLocation) -> Int {
           if currentLocation == nil {
               return -1
           } else {
            return Int(round(((currentLocation?.distance(from: destination))! / 1000)))
           }
       }
}

extension PickupStoreViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        sortNearestStoreLocation()
        stopLocationManager()
    }
    
    func startLocationManager() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
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
            self.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView.isHidden = true
        }
    }
}

extension PickupStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension PickupStoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickupStoreLocationCell.cellId, for: indexPath) as! PickupStoreLocationCell
        guard let filteredLocations = filteredLocations,
            let storeLatitude = filteredLocations[indexPath.row].latitude,
            let storeLongitude = filteredLocations[indexPath.row].longitude
            else { return UITableViewCell() }
        
        let storeDistanceFromCurrentLocation = filteredLocations[indexPath.row].distanceFromCurrentLocation ??
            getDistanceFromCurrentLocation(destination: CLLocation(latitude: storeLatitude, longitude: storeLongitude))
        cell.viewModel = PickupStoreLocationCellViewModel(store:  filteredLocations[indexPath.row], distanceFromCurrentLocation: storeDistanceFromCurrentLocation)
        return cell
    }
}

