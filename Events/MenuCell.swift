//
//  MenuCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/15/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
