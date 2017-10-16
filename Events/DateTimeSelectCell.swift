//
//  DateTimeSelectCell.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/20/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit
import CZPicker

class DateTimeSelectCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var changeDayButton: UIButton!
    
    @IBOutlet weak var collView: UICollectionView!
    
    var picker: CZPickerView!
    var timeSlots: [String] = []
    var dateSlots: [String] = []
    
    var selectedTime: String! = ""
    var selectedDate: String! = ""
    
    var eventDetailsPage: EventDetailsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collView.delegate = self
        self.collView.dataSource = self
        
        let nib = UINib.init(nibName: "TimeSelectCell", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "TimeSelectCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: DATE SELECT BUTTON
    
    @IBAction func changeDatePress(_ sender: Any) {
        self.picker = CZPickerView.init(headerTitle: "Select Date", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        self.picker.needFooterView = false
        
        picker.headerBackgroundColor = UIColor.init(red: 55/255, green: 56/255, blue: 83/255, alpha: 1.0)
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker.show()
    }
    
    //MARK: COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = CGSize.init(width: 95, height: 50)
        return size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSelectCell", for: indexPath) as! TimeSelectCell
        
        if(timeSlots[indexPath.row] == selectedTime)
        {
            cell.backgroundColor = UIColor.init(red: 142/255, green: 144/255, blue: 168/255, alpha: 1.0)
        }
        else{
            cell.backgroundColor = UIColor.init(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
        }
        
        cell.timeText.textColor = UIColor.white
        cell.timeText.text = timeSlots[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeSelectCell
        //save selected time
        selectedTime = timeSlots[indexPath.row]
        
        eventDetailsPage.selectedTime = timeSlots[indexPath.row]
        
        collectionView.reloadData()
    }
    
    // MARK: CZPICKERVIEW WORK
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return dateSlots.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return dateSlots[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        selectedDate = dateSlots[row]
        dateLabel.text = "Availability \(selectedDate!)"
        eventDetailsPage.selectedDate = dateSlots[row]
    }
    
}
