//
//  HintsAndTipsViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/9/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit
import SDFeedParser

@objc class HintsAndTipsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collView: UICollectionView!
    
    var posts = [SDPost]()
    var count = 0
    
    var fromMenu: Int = 1
    
    var sendURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(fromMenu == 1)
        {
            self.createMenuButton()
        }
        
        let nibName = UINib(nibName: "PostCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "PostCell")
        
        let nibName1 = UINib(nibName: "FirstPostViewCell", bundle:nil)
        self.collView.register(nibName1, forCellWithReuseIdentifier: "FirstPostViewCell")
        
        self.loadPosts()
        self.collView.delegate = self
        self.collView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMenuButton()
    {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "ic_menu_white"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.pressMenuButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        item1.tintColor = UIColor.white
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    
    func pressMenuButton()
    {
        self.toggleSideMenuView()
    }

    @IBAction func unwindToPosts(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showPostDetails")
        {
            let dest = segue.destination as! PostDetailViewController
            dest.postURL = sendURL
        }
    }

    
    func loadPosts()
    {
        DSBezelActivityView.newActivityView(for: self.view.window)

        let feed = SDFeedParser.init()
        
        feed.parseURL("http://datenight.perceptions.agency/events/?json=1", success: {(objects, count) -> Void in
            self.posts = objects! as! [SDPost]
            self.count = count

            let post1 = self.posts.first as! SDPost
            self.collView.reloadData()
            
            DSBezelActivityView.remove(animated: true)
            
        }, failure: {(error) in
            DSBezelActivityView.remove(animated: true)
            print(error)
        })
    }

    //MARK: COLLECTIONVIEW METHODS
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(posts.count > 0)
        {
            if(section == 0)
            {
                return 1
            }
            else{
                return posts.count-1
            }
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if(indexPath.section == 0)
        {
            let size = CGSize.init(width: collectionView.frame.width-2, height: 530)
            return size
        }
        let width = collView.frame.width - 2
        let size = CGSize.init(width: width/2, height: 430)
        return size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.section == 0)
        {
            //FirstPostViewCell
             var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstPostViewCell", for: indexPath) as! FirstPostViewCell
            
            cell.postLabel.text = posts[0].title
            cell.thumbImage.setImageWith(URL.init(string: posts[0].thumbnailURL))
            
            return cell
        }
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        cell.titleLabel.text = posts[indexPath.row + 1].title
//        cell.titleLabel.textColor = UIColor.white
        cell.thumbImage.setImageWith(URL.init(string: posts[indexPath.row].thumbnailURL))
        //sd_setImage(with: URL.init(string: posts[indexPath.row].thumbnailURL)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            let post = posts[0] as! SDPost
            sendURL = post.url
        }
        else{
            let post = posts[indexPath.row + 1] as! SDPost
            sendURL = post.url
        }
        
        self.performSegue(withIdentifier: "showPostDetails", sender: self)
    }
    
    
}
