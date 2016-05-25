//
//  LoginController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/25/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class LoginController: UIViewController{

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Login Page loaded.")
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
        }
    }
    
}