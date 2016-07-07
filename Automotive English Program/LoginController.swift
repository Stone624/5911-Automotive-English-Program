//
//  LoginController.swift
//  Automotive English Program
//
//  Programmatic file for the Login page.
//  Page Objects:
//      Image - home page logo
//      label - Username
//      label - Password
//      Text Field - Username
//      Text Field - Button
//      Button - login
//  Methods:
//      viewDidLoad - called when the page loads. Calls methods that setup the page UI.
//          createImage - creates the image.
//          createUsernameAndPasswordFields - creates the username label/text field, and password label/text field.
//!          createLoginButton
//      textFieldShouldReturn - implemented so that "return" closes the keyboard.
//!      LoginButtonPressed - Called when the Login Button is pressed. Takes the current information in the Username and Password text fields, and checks the server for authentication of the login credentials.
//
//
//  Created by Tyler Stone on 5/25/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//
//

import UIKit
import Foundation

// justin now has access to git, sorry for the delay
class LoginController: UIViewController,UITextFieldDelegate{

//    @IBOutlet weak var HomePageImage: UIImageView!
    var UsernameTextField: UITextField!
    var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login Page loaded.")
        //Create Image
        self.createImage()
        //create login fields (username label, username textfield, password label, password textfield)
        self.createUsernameAndPasswordFields()
        //create login button
        self.createLoginButton()
        
    }
    
    func createImage() {
        let x = self.view.layer.frame.width * 0.05
        let y = self.view.layer.frame.height * 0.05
        let width = self.view.layer.frame.width * 0.9
        let height = self.view.layer.frame.height * 0.45
        let homePageImage = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        homePageImage.image = UIImage(named: "OsuHondaAEPLogo.png")
        homePageImage.contentMode = UIViewContentMode.ScaleAspectFit
//        homePageImage.backgroundColor = .greenColor()
        view.addSubview(homePageImage)
    }
    
    func createUsernameAndPasswordFields() {
        var x = Int(self.view.layer.frame.width * 0.1)
        var y = Int(self.view.layer.frame.height * 0.5)
        var width = Int(self.view.layer.frame.width * 0.35)
        var height = 50
        let usernameLabelField = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        usernameLabelField.text = "Username:"
//        usernameLabelField.backgroundColor = .greenColor()
        view.addSubview(usernameLabelField)
        
        x = Int(self.view.layer.frame.width * 0.1)
        y = Int(self.view.layer.frame.height * 0.65)
        width = Int(self.view.layer.frame.width * 0.35)
        height = 50
        let passwordLabelField = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        passwordLabelField.text = "Password:"
//        passwordLabelField.backgroundColor = .greenColor()
        view.addSubview(passwordLabelField)
        
        x = Int(self.view.layer.frame.width * 0.45)
        y = Int(self.view.layer.frame.height * 0.5)
        width = Int(self.view.layer.frame.width * 0.45)
        height = 50
        UsernameTextField = UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
        UsernameTextField.allowsEditingTextAttributes = true
//        UsernameTextField.backgroundColor = .greenColor()
        UsernameTextField.borderStyle = UITextBorderStyle.Bezel
        UsernameTextField.delegate = self
        view.addSubview(UsernameTextField)
        
        x = Int(self.view.layer.frame.width * 0.45)
        y = Int(self.view.layer.frame.height * 0.65)
        width = Int(self.view.layer.frame.width * 0.45)
        height = 50
        PasswordTextField = UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
        PasswordTextField.allowsEditingTextAttributes = true
        PasswordTextField.secureTextEntry = true
//        PasswordTextField.backgroundColor = .greenColor()
        PasswordTextField.borderStyle = UITextBorderStyle.Bezel
        PasswordTextField.delegate = self
        view.addSubview(PasswordTextField)
    }
    
    func createLoginButton(){
        let x = Int(self.view.layer.frame.width * 0.1)
        let y = Int(self.view.layer.frame.height * 0.85)
        let width = Int(self.view.layer.frame.width * 0.8)
        let height = 50
        let loginButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        loginButton.setTitle("Click Here To Login", forState: .Normal)
        loginButton.backgroundColor = .greenColor()
        loginButton.addTarget(self, action: #selector(LoginController.LoginButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return false
    }
    
    func LoginButtonPressed(sender: AnyObject) {
        let username = self.UsernameTextField.text
        let password = self.PasswordTextField.text
        
        //Query database
        print("Username entered: \(username)")
        print("Password entered: \(password)")
        
        if username == "" && password == ""{
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