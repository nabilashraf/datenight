//
//  DescriptionViewCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/20/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class DescriptionViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collView: UICollectionView!

    var categoryNames: [String] = []
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collView.dataSource = self
        self.collView.delegate = self
        let nibName = UINib(nibName: "CategoryNameCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "CategoryNameCell")
        
        self.collView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: COLLECTION VIEW WORK
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = CGSize.init(width: 100, height: 50)
        return size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCell", for: indexPath) as! CategoryNameCell
        
        cell.catName.text = categoryNames[indexPath.row]
        
//        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 15
//        cell.layer.borderWidth = 4.0
//        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    
    
}
