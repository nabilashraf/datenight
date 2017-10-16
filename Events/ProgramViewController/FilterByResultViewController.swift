//
//  FilterByResultViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 8/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit
import FSCalendar

class FilterByResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var pageControl: UISegmentedControl!
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var applyChnagesButton: UIButton!
    
    var selectedCategories: [String] = []
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectedDateFilter: Date!
    var dateString: String!
    
    var programVC: ProgramViewController!
    
    let imageNames = ["drinks-cat", "food-cat", "activities_cat", "theatre-cat", "sport-cat", "comedy-cat", "music-cat", "artsncraft-cat", "sights-cat", "exclusives-cat", "romantic-cat", "alternatives-cat"]
    
    let categories: [String] = ["Drinks", "Food", "Activities", "Theatre", "Sport", "Comedy", "Music", "Arts & Craft", "Sights", "Exclusives", "Romantic", "Alternatives"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib.init(nibName: "FilterCatCell", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "FilterCatCell")
        
        self.collView.delegate = self
        self.collView.dataSource = self
        
        self.collView.reloadData()
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.pageControl.tintColor = UIColor.init(red: 233/255, green: 73/255, blue: 77/255, alpha: 1.0)
        let attr = NSDictionary.init(objects: [UIFont(name: "OpenSans-Light", size: 13)!, UIColor.white], forKeys: [NSFontAttributeName as NSCopying, NSForegroundColorAttributeName as NSCopying]) //NSDictionary(object: UIFont(name: "OpenSans-Light", size: 13)!, forKey: NSFontAttributeName as NSCopying)
        self.pageControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        self.applyChnagesButton.backgroundColor = UIColor.init(red: 233/255, green: 73/255, blue: 77/255, alpha: 1.0)
        self.applyChnagesButton.layer.cornerRadius = 20
        
        if(self.dateString != "")
        {
            //set selected date on calendar
            let dateformater = DateFormatter.init()
            dateformater.dateFormat = "dd MMM yyyy"
            
            self.selectedDateFilter = dateformater.date(from: self.dateString)
            self.calendar.select(self.selectedDateFilter)
        }
        self.calendar.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyChangesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: {
//            if(self.selectedCategories.first == "NONE")
//            {
//            }
//            else{
//                
//            }

            let mutedArray = NSMutableArray(array: self.selectedCategories)
            self.programVC.categoryFilter = mutedArray //self.selectedCategories as! NSMutableArray
            
            if(self.selectedDateFilter != nil)
            {
                let dateformater = DateFormatter.init()
                dateformater.dateFormat = "dd MMM yyyy"
                
                self.dateString = dateformater.string(from: self.selectedDateFilter)
            }
            self.programVC.dateFilter = self.dateString
        })
    }
    
    @IBAction func closeButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    // MARK: SEGMENTED CONTROL CHANGED THE TAB
    @IBAction func changedSegmentedControl(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) //type selected
        {
            self.calendar.isHidden = true
        }
        else
        {
            //date selected
            self.calendar.isHidden = false
        }
    }
    
    //MARK: COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.categories.count/3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let widthWithoutPadding = collectionView.frame.width - 6
        
        let size = CGSize.init(width: widthWithoutPadding/3, height: widthWithoutPadding/3)
        return size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCatCell", for: indexPath) as! FilterCatCell
        
        let index = indexPath.section * 3
        cell.catNameText.text = self.categories[index + indexPath.row]
        cell.catImage.image = UIImage.init(named: self.imageNames[index + indexPath.row])
        
//        cell.backgroundColor = UIColor.init(red: 87/255, green: 88/255, blue: 110/255, alpha: 1.0)
//        cell.backgroundColor = UIColor.init(red: 55/255, green: 56/255, blue: 83/255, alpha: 1.0)
        
        let isSelected = selectedCategories.index(where: { $0 == categories[index + indexPath.row]})
        if(isSelected != nil){
            cell.backgroundColor = UIColor.init(red: 55/255, green: 56/255, blue: 83/255, alpha: 1.0)
        }
        else{
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * 3
//        print("You selected cell #\(index + indexPath.row)!")
        let isSelected = selectedCategories.index(where: { $0 == categories[index + indexPath.row]})
        if(isSelected != nil){
            selectedCategories.remove(at: isSelected!)
            if(selectedCategories.count == 0){
                selectedCategories.append("NONE")
            }
        }
        else{
            if(selectedCategories.contains("NONE") && selectedCategories.count == 1)
            {
                selectedCategories.removeAll()
            }
            selectedCategories.append(categories[index + indexPath.row])
        }
        
        collectionView.reloadData()
    }

    
    // MARK: CALENDAR VIEW WORK
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        self.selectedDateFilter = date
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDateFilter = nil
    }
}
