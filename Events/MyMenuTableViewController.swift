//
//  MyMenuTableViewController.swift
//  WallaZoom
//
//  Created by Muhammad Shabbir on 1/13/17.
//  Copyright © 2017 Muhammad Shabbir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit


class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 1
    let pages:[String] = ["Home", "Find Date", "Saved Dates" ,"Hints & Tips", "Top Picks", "Logout"]
    
    let imageNames: [String] = ["pickDate", "find-dateicon","savedDates", "hintsAndTips", "topPicks", "logOut"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.init(red: 90/255, green: 90/255, blue: 113/255, alpha: 1.0)
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor.clear
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        tableView.separatorColor = orange
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView()
        
        let nib1 = UINib.init(nibName: "MenuCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "menuCell")
        
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return pages.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "menuCell") as! MenuCell
        }
        
        cell.backgroundColor = UIColor.init(red: 90/255, green: 90/255, blue: 113/255, alpha: 1.0)
        
        cell.cellLabel?.textColor = UIColor.white
        let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.init(red: 90/255, green: 90/255, blue: 113/255, alpha: 1.0)
        cell.selectedBackgroundView = selectedBackgroundView
        
        let font1 = UIFont.init(name: "OpenSans-Light", size: 14)
        
        cell.cellLabel.font = font1
        cell.cellLabel?.numberOfLines = 1
        
        if(indexPath.row == 0)
        {
//            let decoded  = UserDefaults.standard.object(forKey: "myUser") as! Data
//            let myUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            
//            let labelSize = rectForText(myUser.first_name!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: (cell!.textLabel?.frame.width)! ,height: 999))
//            let labelHeight = labelSize.height //here it is!
//            cell!.textLabel?.frame = CGRect(x: (cell!.textLabel?.frame.minX)!, y: (cell!.textLabel?.frame.minY)!, width: (cell!.textLabel?.frame.width)!, height: labelHeight)
//            cell.textLabel?.text = "Welcome";
            cell.cellLabel?.text = "Welcome"
            cell.selectionStyle = .none
            cell.cellImage.image = UIImage.init(named: "heart_filter")
        }else{
//            let labelSize = rectForText(pages[indexPath.row-1], font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: (cell.textLabel?.frame.width)! ,height: 999))
//            let labelHeight = labelSize.height //here it is!
//            cell.cellLabel?.frame = CGRect(x: (cell.textLabel?.frame.minX)!, y: (cell.textLabel?.frame.minY)!, width: (cell.textLabel?.frame.width)!, height: labelHeight)
            
            cell.cellImage.image = UIImage.init(named: imageNames[indexPath.row-1])
            cell.cellLabel?.text = pages[indexPath.row-1]
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        
//        if (indexPath.row == selectedMenuItem) {
//            return
//        }
        
        if(indexPath.row == 0)
        {
            //do nothing
            tableView.deselectRow(at: indexPath, animated: false)
            
            return
        }
        
        selectedMenuItem = indexPath.row
        
        UserDefaults.standard.set(selectedMenuItem, forKey: "SelectedType")
        UserDefaults.standard.synchronize()
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "iPhoneMain",bundle: nil)
        var destViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        switch (indexPath.row-1) {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 1: //for find date page
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "findDatePageNew")
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 2:
            //savedDatesPage
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "savedDatesPage")
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "hintsNTipsPage")
            sideMenuController()?.setContentViewController(destViewController)
            break
        case 4:
            let startPage = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! StartPageViewController
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! StartPageViewController
            startPage.takeToTopPicks()
            
            sideMenuController()?.setContentViewController(startPage)
            startPage.takeToTopPicks()
//            [destViewController takeToTopPicks];
            break
//            let topPicks : ProgramViewController = mainStoryboard.instantiateViewController(withIdentifier: "programViewController") as! ProgramViewController
//            topPicks.categoryFilter = ["Top Picks"];
//            topPicks.menuIsAllowed = 0;
//            sideMenuController()?.setContentViewController(topPicks)
//            break
        case 5:
            Utility.setNSUserDefaultValueFor(nil, strKey: "user_id")
            
            let loginManager = FBSDKLoginManager.init()
            loginManager.logOut()
            
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "firstPage")
            sideMenuController()?.setContentViewController(destViewController)
            break
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            sideMenuController()?.setContentViewController(destViewController)
            break
        }
        
    }
    
    func rectForText(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}
