//
//  HalfCategoryCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

@objc class HalfCategoryCell: UITableViewCell {

    @IBOutlet weak var leftSection: UIView!
    
    @IBOutlet weak var rightSection: UIView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var RightLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    public var catLabel1: String!
    public var catLabel2: String!
    public var cellIndex1: Int!
    public var cellIndex2: Int!
    public var imageName: String!
    public var rightImage: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI()
    {
        leftLabel.text = catLabel1
        RightLabel.text = catLabel2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
