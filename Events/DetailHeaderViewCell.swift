//
//  DetailHeaderViewCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/20/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class DetailHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
