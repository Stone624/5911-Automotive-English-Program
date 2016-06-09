//
//  LoginController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/25/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

// justin now has access to git, sorry for the delay
class LoginController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Login Page loaded.")
        self.UsernameTextField.delegate = self
        self.PasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        let username = self.UsernameTextField.text
        let password = self.PasswordTextField.text
        
        //Query database
        print("Username entered: \(username)")
        print("Password entered: \(password)")
        
        if username == "bob" && password == "pass"{
            print("Access granted")
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        } else {
            print("Access denied")
            let alert = UIAlertView() //<<NOTE: UIAlertView depreciated for IOS 8 and above. UIAlertController should be used when IOS 7 and lower will not use this app.
            alert.title = "ERROR: Login Authentication Failed."
            alert.message = "Your Username and/or Password was incorrect. Please try again."
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
}