//
//  RecommendedCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/25/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class RecommendedCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categories: [String] = ["Music", "Drinks", "Food"]
    
    @IBOutlet weak var collView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collView.delegate = self
        self.collView.dataSource = self
        
        let nib = UINib.init(nibName: "RecommendedCatCell", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "RecommendedCatCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = CGSize.init(width: 193, height: 192)
        return size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCatCell", for: indexPath) as! RecommendedCatCell
        
        cell.catLabel.text = self.categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, image: UIImage) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    
    
}
