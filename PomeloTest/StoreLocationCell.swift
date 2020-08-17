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

class StoreLocationCell: UITableViewCell {
    
    static let cellId = "StoreLocationCell"
    static let nibName = "StoreLocationCell"

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceFromCurrentLocationLabel: UILabel!
    @IBOutlet weak var distanceMetricsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
