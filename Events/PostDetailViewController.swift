//
//  PostDetailViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/11/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var postURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let postAddressURL = URL.init(string: postURL)
        let request = URLRequest.init(url: postAddressURL!)
        
        self.webView.loadRequest(request as URLRequest)
        
        self.createMenuButton()
    }
    
    func createMenuButton()
    {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "left_arrow"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.tintColor = UIColor.white
        btn1.addTarget(self, action: #selector(self.pressBackButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        item1.tintColor = UIColor.white
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    
    func pressBackButton()
    {
        self.performSegue(withIdentifier: "backToPosts", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
