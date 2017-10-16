//
//  StartCategoryCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

@objc class StartCategoryCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    var catLabel: String!
    var cellIndex: Int!
    var imageName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI()
    {
        self.myLabel.text = catLabel
        self.myImage.image = UIImage.init(named: imageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
