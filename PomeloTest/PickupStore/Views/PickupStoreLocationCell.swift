//
//  StoreLocationCell.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import UIKit


enum DistanceMetrics: String {
    case kilometer = "Km"
}

class PickupStoreLocationCell: UITableViewCell {
    
    var viewModel: PickupStoreLocationCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    static let cellId = "PickupStoreLocationCell"
    static let nibName = "PickupStoreLocationCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceFromCurrentLocationLabel: UILabel!
    @IBOutlet weak var distanceMetricsLabel: UILabel!
    @IBOutlet weak var distanceStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI() {
        guard let viewModel = viewModel else { return }
        self.cityLabel.text = viewModel.city
        self.addressLabel.text = viewModel.address
        self.aliasLabel.text = viewModel.alias
        self.distanceStackView.isHidden = viewModel.shouldHideDistanceFromCurrentLocation()
        self.distanceFromCurrentLocationLabel.text = "\(viewModel.distanceFromCurrentLocation)"
    }
}


