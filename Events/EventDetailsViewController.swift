//
//  EventDetailsViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/19/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit
import GoogleMaps
import CZPicker

@objc class EventDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var myEvent: EventList!
    
    var eligibleDates: [String] = []
    var eligibleTimes: [String] = []
    
    var selectedDate: String = ""
    var selectedTime: String = ""
    
    var picker: CZPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        
        //register NIBs below
        //Header Cell
        let nib = UINib.init(nibName: "DetailHeaderViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DetailHeaderViewCell")
        
        let nib1 = UINib.init(nibName: "DescriptionViewCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "DescriptionViewCell")
        
        let nib2 = UINib.init(nibName: "MapViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "MapViewCell")
        
        let nib3 = UINib.init(nibName: "ThreeButtonCell", bundle: nil)
        self.tableView.register(nib3, forCellReuseIdentifier: "ThreeButtonCell")
        
        let nib4 = UINib.init(nibName: "BookNowCell", bundle: nil)
        self.tableView.register(nib4, forCellReuseIdentifier: "BookNowCell")
        
        let nib5 = UINib.init(nibName: "RecommendedCell", bundle: nil)
        self.tableView.register(nib5, forCellReuseIdentifier: "RecommendedCell")
        
        let nib6 = UINib.init(nibName: "DateTimeSelectCell", bundle: nil)
        self.tableView.register(nib6, forCellReuseIdentifier: "DateTimeSelectCell")

        
        createTimeIntervals()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMyEvent(event: EventList)
    {
        self.myEvent = event
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showEventComments")
        {
            //pass comments onto the next page
            let dest = segue.destination as! EventCommentsViewController
            print(self.myEvent.eventComments.count)
            
            dest.commentsArray = self.myEvent.eventComments as NSArray as? [String]
        }
    }

    
    // MARK: TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            //header height
            return 253
        }
        if(indexPath.row == 1)
        {
            //Description height
            let heightLabel = self.heightForView(text: myEvent.eventDescription, font: UIFont.init(name: "OpenSans-Light", size: 13)!, width: tableView.frame.width-16)
            
            return 52 + heightLabel
        }
        else if(indexPath.row == 2 || indexPath.row == 6)
        {
            //3 button cell
            return 44
        }
        else if(indexPath.row == 3)
        {
            return 128
        }
        else if(indexPath.row == 5)
        {
            return 290
        }
        else if(indexPath.row == 4)
        {
            //currently map cell
            return 320
        }
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            //HEADER CELL
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderViewCell") as! DetailHeaderViewCell
            
            cell.headerLabel.text = myEvent.eventName
            if(myEvent.eventImageURL.characters.count > 0)
            {
                cell.headerImage.setImageWith(URL.init(string: myEvent.eventImageURL))
                cell.headerImage.clipsToBounds = true
            }
        
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 1)
        {
            //DESCRIPTION CELL
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionViewCell") as! DescriptionViewCell
            
            //write category names to the array
            
            //manage the height of description label
            cell.descriptionLabel.frame = CGRect.init(x: cell.descriptionLabel.frame.origin.x, y: cell.descriptionLabel.frame.origin.y, width: cell.descriptionLabel.frame.width, height: self.heightForView(text: myEvent.eventDescription, font: UIFont.init(name: "OpenSans-Light", size: 13)!, width: cell.descriptionLabel.frame.width))
            cell.descriptionLabel.text = myEvent.eventDescription
            
            cell.categoryNames = myEvent.eventCategories as! [String]
            
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 2)
        {
            //THREE BUTTON CELL SHOWING SHARE COMMENT AND SAVE
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeButtonCell") as! ThreeButtonCell
            
            //assign actions to buttons here
            cell.shareButton.addTarget(self, action: #selector(shareSheet), for: .touchDown)
            cell.commentsButton.addTarget(self, action: #selector(showCommentsPage), for: .touchDown)
            cell.saveButton.addTarget(self, action: #selector(toggleSave), for: .touchDown)
            
            if(myEvent.isFav == 1)
            {
                cell.saveButton.setImage(UIImage.init(named: "star_filled"), for: .normal)
                cell.saveButton.setTitle("Unsave", for: .normal)
            }
            else{
                cell.saveButton.setImage(UIImage.init(named: "star_unfilled"), for: .normal)
                cell.saveButton.setTitle("Save", for: .normal)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        else if(indexPath.row == 3) // DATE AND TIME CELL
        {
            //THREE BUTTON CELL SHOWING SHARE COMMENT AND SAVE
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTimeSelectCell") as! DateTimeSelectCell
            
            //assign actions to buttons here
            cell.timeSlots = self.eligibleTimes
            cell.dateSlots = self.eligibleDates
            cell.eventDetailsPage = self
            
            cell.dateLabel.text = "Availability \(self.eligibleDates.first!)"
            
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 4) // MAP VIEW CELL
        {
            //MAP VIEW
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapViewCell") as! MapViewCell
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(myEvent.eventLocationLatitude), longitude: Double(myEvent.eventLocationLongitude), zoom: 18)
            let mapView = GMSMapView.map(withFrame: cell.mapArea.frame, camera: camera)
//            cell.mapArea = mapView
            
            var marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(myEvent.eventLocationLatitude), longitude: Double(myEvent.eventLocationLongitude)))
            marker.map = cell.mapArea
            
            cell.mapArea.camera = camera
            
//            cell.addSubview(mapView)
//            cell.mapArea = mapView
            
            cell.fullAddressLabel.text = myEvent.eventLocationAddress
            cell.titleLabel.text = myEvent.eventLocationName
            cell.lat = Double(myEvent.eventLocationLatitude)
            cell.long = Double(myEvent.eventLocationLongitude)
//            cell.updateLatLong()
            
            cell.selectionStyle = .none
            return cell
        }
        
        //recommendations here
        else if(indexPath.row == 5) // RECOMMENDED CELL
        {
            //SHOULD BE DESCRIPTION CELL BUT RIGHT NOW IS MAP VIEW
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCell") as! RecommendedCell
            
            //assign action to book now
            
            
            cell.selectionStyle = .none
            return cell
        }
            
        else if(indexPath.row == 6) // BOOK NOW BUTTON
        {
            //SHOULD BE DESCRIPTION CELL BUT RIGHT NOW IS MAP VIEW
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell") as! BookNowCell
            
            //assign action to book now
            cell.bookButton.addTarget(self, action: #selector(bookButtonPress), for: .touchDown)
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 6)
        {
            
        }
    }
    
    func createTimeIntervals()
    {
        let start = self.myEvent.eventStartDateTime
        var startingHour: String! = ""
        
        var index = 0
        for char in (start?.characters)!
        {
            startingHour.append(char)
            if(index == 1)
            {
                break
            }
            index = index + 1
        }
        
        let index1 = start?.index((start?.startIndex)!, offsetBy: 11)
        let startingDate = start?.substring(from: index1!)
        
        //get the ending date and time
        let end = self.myEvent.eventEndDateTime
        var endingHour: String! = ""
        
        index = 0
        for char in (start?.characters)!
        {
            endingHour.append(char)
            if(index == 1)
            {
                break
            }
            index = index + 1
        }
        
        let index2 = end?.index((end?.startIndex)!, offsetBy: 11)
        let endingDate = end?.substring(from: index2!)
        
        //make time slots
        var startNumber = Int.init(startingHour)
        var endNumber = Int.init(endingHour)
        
        if(startNumber == endNumber)
        {
            //all day event, midnight to midnight
            endNumber = 23
        }
        
        var noOfHours = endNumber! - startNumber!
        
        while(noOfHours >= 0)
        {
            if(startNumber! < 10)
            {
                var bookingTime1 = "0\(startNumber!):00"
                self.eligibleTimes.append(bookingTime1)
                bookingTime1 = "0\(startNumber!):30"
                self.eligibleTimes.append(bookingTime1)
            }
            else
            {
                var bookingTime1 = "\(startNumber!):00"
                self.eligibleTimes.append(bookingTime1)
                bookingTime1 = "\(startNumber!):30"
                self.eligibleTimes.append(bookingTime1)
            }
            
            startNumber = startNumber! + 1
            noOfHours = noOfHours - 1
        }
        
//        print(self.eligibleTimes)
        
        //make dates list
        let myDateFormat = DateFormatter()
        myDateFormat.dateFormat = "dd MMMM yyyy"
        var date1: Date = myDateFormat.date(from: startingDate!)!
        print(date1)
        
        let date2: Date = myDateFormat.date(from: endingDate!)!
        print(date2)
        
        let calendar = Calendar.current
        while date1 <= date2 {
            date1 = calendar.date(byAdding: .day, value: 1, to: date1)!
            print(date1)
            
            var dateFormat2 = DateFormatter()
            dateFormat2.dateFormat = "dd MMM yyyy"
            
            let dateStr = dateFormat2.string(from: date1)
            print(dateStr)
            self.eligibleDates.append(dateStr)
        }
        self.selectedDate = self.eligibleDates.first!
    }
    
    //MARK: BUTTON ACTIONS
    func shareSheet()
    {
        let nameWithoutSpaces = myEvent.eventName.replacingOccurrences(of: " ", with: "-")
        let baseUrl = NSLocalizedString("APPLICATION_URL", comment: "APPLICATION_URL")
        let finalURL = myEvent.eventLink
        //baseUrl.appending("events/events/").appending(nameWithoutSpaces)
        
        let vc = UIActivityViewController(activityItems: [finalURL], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func showCommentsPage()
    {
        self.performSegue(withIdentifier: "showEventComments", sender: self)
    }
    
    func toggleSave()
    {
        if(myEvent.isFav == 0)
        {
            //mark as saved
            self.myEvent.isFav = 1
        }
        else if(myEvent.isFav == 1){
            //unsave the event
            self.myEvent.isFav = 0
        }
        self.sendSaveRequest()
//        self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
    func bookButtonPress()
    {
        if(self.selectedDate != "" && self.selectedTime != "")
        {
            self.picker = CZPickerView.init(headerTitle: "Select Booking Count", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
            self.picker.needFooterView = true
            
            picker.headerBackgroundColor = UIColor.init(red: 55/255, green: 56/255, blue: 83/255, alpha: 1.0)
            
            self.picker.delegate = self
            self.picker.dataSource = self
            
            self.picker.show()
        }
        else
        {
            //show no date time selected
            
        }
    }
    
    func sendSaveRequest()
    {
        DSBezelActivityView.init(for: UIApplication.shared.keyWindow, withLabel: "Processing", width: 100)
        let userId: String! = UserDefaults.standard.string(forKey: "user_id")
        let parameters = ["user_id": userId, "event_id": Int(myEvent.eventID)] as [String : Any]

        Utility.getDataForMethod("events/api/addRemoveFav", parameters: parameters, key: "", withCompletion: {
            response in
            
            if(response != nil)
            {
                self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
            }
            DSBezelActivityView.remove(animated: true)
            
            let av = UIAlertView.init(title: "DateNight", message: "Save Successful", delegate: self, cancelButtonTitle: "OK")
            av.tag = 99
            av.show()
            
        }, withFailure: {
            error in
            print(error)
            self.resetState()
            DSBezelActivityView.remove(animated: true)
            
            let av = UIAlertView.init(title: "DateNight", message: "Save Unsuccessful", delegate: self, cancelButtonTitle: "OK")
            av.tag = 99
            av.show()
        })
        
    }
    
    func resetState()
    {
        if(myEvent.isFav == 0)
        {
            //mark as saved
            self.myEvent.isFav = 1
        }
        else if(myEvent.isFav == 1){
            //unsave the event
            self.myEvent.isFav = 0
        }
        
        self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }

    // MARK: CZPICKERVIEW WORK
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return 10
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        let count = row + 1
        return "\(count)"
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        //send request for booking here
        let booking_spaces = row + 1
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        var dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM yyyy"
        
        var timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        
        let date = dateFormater.date(from: selectedDate)
        let time = timeFormater.date(from: selectedTime)
        
        dateFormater.dateFormat = "yyyy-MM-dd"
        timeFormater.dateFormat = "HH:mm:ss"
        
        let dateString = dateFormater.string(from: date!)
        let timeString = timeFormater.string(from: time!)
        
        var booking_date = dateString.appending(" ")
        booking_date = booking_date.appending(timeString)
        
        print(booking_date)
        
        DSBezelActivityView.init(for: UIApplication.shared.keyWindow, withLabel: "Processing", width: 100)
        let userId: String! = UserDefaults.standard.string(forKey: "user_id")
        let parameters = ["user_id": userId, "event_id": Int(myEvent.eventID), "booking_spaces": booking_spaces,
                          "booking_comment": "", "booking_date": booking_date] as [String : Any]
        
        Utility.getDataForMethod("events/api/bookTicket", parameters: parameters, key: "", withCompletion: {
            response in
            
            if(response != nil)
            {
                DSBezelActivityView.remove(animated: true)
                let av = UIAlertView.init(title: "DateNight", message: "Booking Successful", delegate: self, cancelButtonTitle: "OK")
                av.tag = 99
                av.show()
            }
            else
            {
                DSBezelActivityView.remove(animated: true)
            }
        }, withFailure: {
            error in
            print(error)
            self.resetState()
            
            DSBezelActivityView.remove(animated: true)
            
            let av = UIAlertView.init(title: "DateNight", message: "Booking Unsuccessful", delegate: self, cancelButtonTitle: "OK")
            av.tag = 99
            av.show()
        })
        
    }
    
    //FOR HEIGHT OF LABEL
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}
