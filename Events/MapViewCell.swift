//
//  MapViewCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/20/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewCell: UITableViewCell {

    @IBOutlet weak var mapArea: GMSMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fullAddressLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var lat: Double!
    var long: Double!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Create a GMSCameraPosition that tells the map to display the
        
//        self.updateLatLong()
    }
    
    func updateLatLong()
    {
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapArea = mapView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
