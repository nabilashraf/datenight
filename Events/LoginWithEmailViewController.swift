//
//  LoginWithEmailViewController.swift
//  Events
//
//  Created by Muhammad Shabbir on 7/13/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

import UIKit

class LoginWithEmailViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailField.backgroundColor = UIColor.init(red: 68/255, green: 70/255, blue: 85/255, alpha: 1.0)
        passwordField.backgroundColor = UIColor.init(red: 68/255, green: 70/255, blue: 85/255, alpha: 1.0)
        
        self.loginButton.layer.cornerRadius = 20.0;
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
        if(emailField.text == "" && passwordField.text == "")
        {
            return false
        }
        return isValidEmail(testStr: emailField.text!)
    }

    
    @IBAction func loginButtonPress(_ sender: Any) {
        self.hideKeyboards()
        if(checkFields())
        {
            DSBezelActivityView.init(for: UIApplication.shared.keyWindow, withLabel: "Processing", width: 100)
            
            let parameters = ["email": emailField.text, "pwd": passwordField.text]
            
            Utility.getDataForMethod(NSLocalizedString("LOGIN_METHOD", comment: "LOGIN_METHOD"), parameters: parameters, key: "", withCompletion: {
                response in
                
                if let resp = response as? NSDictionary
                {
                    if(resp.object(forKey: "status") as! String == "0")
                    {
                        Utility.alertNotice("DateNight", withMSG: resp.object(forKey: "message") as! String, cancleButtonTitle: "OK", otherButtonTitle: nil)
                    }
                    else{
                        Utility.setNSUserDefaultValueFor("\(resp.object(forKey: "user_id")!)", strKey: "user_id")
                        
                        let av = UIAlertView.init(title: "DateNight", message: "Login Successful!", delegate: self, cancelButtonTitle: "OK")
                        av.tag = 99
                        av.show()
                        
                        self.performSegue(withIdentifier: "loginAfterLogin", sender: self)
                    }
                }
                else if let resp = response as? NSArray
                {
                    if((resp.object(at: 0) as! NSDictionary).object(forKey: "status") as! String == "0")
                    {
                        Utility.alertNotice("DateNight", withMSG: (resp.object(at: 0) as! NSDictionary).object(forKey: "message") as? String, cancleButtonTitle: "OK", otherButtonTitle: nil)
                    }
                    else{
                        Utility.setNSUserDefaultValueFor((resp.object(at: 0) as! NSDictionary).object(forKey: "user_id") as! String, strKey: "user_id")
                        
                        let av = UIAlertView.init(title: "DateNight", message: "Login Successful", delegate: self, cancelButtonTitle: "OK")
                        av.tag = 99
                        av.show()
                        
                        self.performSegue(withIdentifier: "loginAfterLogin", sender: self)
                    }
                }
                
                
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
    
    
    @IBAction func backButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboards()
    {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}
