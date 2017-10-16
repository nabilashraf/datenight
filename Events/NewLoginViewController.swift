//
//  NewLoginViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/12/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class NewLoginViewController: UIViewController {

    @IBOutlet weak var nameFIeld: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameFIeld.backgroundColor = UIColor.init(red: 68/255, green: 70/255, blue: 85/255, alpha: 1.0)
        emailField.backgroundColor = UIColor.init(red: 68/255, green: 70/255, blue: 85/255, alpha: 1.0)
        passwordField.backgroundColor = UIColor.init(red: 68/255, green: 70/255, blue: 85/255, alpha: 1.0)
        
//        //Name Field icon
//        nameFIeld.leftViewMode = .always
//        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
//        let image = UIImage(named: "ic_account_circle_white")
//        imageView.image = image
//        nameFIeld.leftView?.frame = imageView.frame
//        nameFIeld.leftView = imageView
//        
//        //Email Field icon
//        emailField.leftViewMode = .always
//        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image1 = UIImage(named: "ic_mail_outline_white")
//        imageView1.image = image1
//        emailField.leftView = imageView1
//        
//        //Password Field icon
//        passwordField.leftViewMode = .always
//        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image2 = UIImage(named: "ic_lock_outline_white")
//        imageView2.image = image2
//        passwordField.leftView = imageView2
        
        self.registerButton.layer.cornerRadius = 20.0;
        
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
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func checkFields() -> Bool
    {
        if(nameFIeld.text == "" || emailField.text == "" && passwordField.text == "")
        {
            return false
        }
        return isValidEmail(testStr: emailField.text!)
    }
    
    @IBAction func registerButtonPress(_ sender: Any) {
        self.hideKeyboards()
        
        if(checkFields())
        {
            DSBezelActivityView.init(for: UIApplication.shared.keyWindow, withLabel: "Processing", width: 100)
            
            let parameters = ["name": nameFIeld.text, "email": emailField.text, "pwd": passwordField.text]
            
            
            Utility.getDataForMethod(NSLocalizedString("REGISTER_METHOD", comment: "REGISTER_METHOD"), parameters: parameters, key: "", withCompletion: {
                response in
                
                if let resp = response as? NSDictionary
                {
                    if(resp.object(forKey: "message") as! String == "Sorry, that username already exists!")
                    {
                        Utility.alertNotice("DateNight", withMSG: "Sorry, that username already exists!", cancleButtonTitle: "OK", otherButtonTitle: nil)
                    }
                    else{
                        Utility.setNSUserDefaultValueFor("\(resp.object(forKey: "user_id")!)", strKey: "user_id")
                        
                        let av = UIAlertView.init(title: "DateNight", message: resp.object(forKey: "message") as? String, delegate: self, cancelButtonTitle: "OK")
                        av.tag = 99
                        av.show()
                        
                        self.performSegue(withIdentifier: "loginAfterRegister", sender: self)
                    }
                }
                else if let resp = response as? NSArray
                {
                    if((resp.object(at: 0) as! NSDictionary).object(forKey: "message") as! String == "Sorry, that username already exists!")
                    {
                        Utility.alertNotice("DateNight", withMSG: "Sorry, that username already exists!", cancleButtonTitle: "OK", otherButtonTitle: nil)
                    }
                    else{
                        Utility.setNSUserDefaultValueFor((resp.object(at: 0) as! NSDictionary).object(forKey: "user_id") as! String, strKey: "user_id")
                        
                        let av = UIAlertView.init(title: "DateNight", message: (resp.object(at: 0) as! NSDictionary).object(forKey: "message") as? String, delegate: self, cancelButtonTitle: "OK")
                        av.tag = 99
                        av.show()
                        
                        self.performSegue(withIdentifier: "loginAfterRegister", sender: self)
                    }
                }
                
                DSBezelActivityView.remove(animated: true)
            }, withFailure: {
                error in
                DSBezelActivityView.remove(animated: true)
                print(error)
            })
        }
        else
        {
            print("CANNOT REGISTER CHECK FIELDS")
        }
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func hideKeyboards()
    {
        nameFIeld.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

}
