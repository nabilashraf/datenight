//
//  ThreeButtonCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/20/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class ThreeButtonCell: UITableViewCell {

    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
