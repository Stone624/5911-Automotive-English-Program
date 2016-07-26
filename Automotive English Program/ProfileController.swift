//
//  ProfileController.swift
//  Automotive English Program
//
//  Programmatic view for MyProfile page. A page for user settings and personal statistics.
//      Currently this page only has a button for switching the language setting
//  Page Objects:
//      Button - switches language setting
//      Label - Displays current language setting
//  Methods:
//      updatePage - Updates the label with the current language setting.
//
//  Created by Tyler Stone on 6/6/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//
import UIKit
import Foundation

class ProfileController: UIViewController{

    @IBOutlet weak var CurrentLanguageTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updatePage()
        print("Profile Page loaded.")
    }
    
    @IBAction func SwitchLanguageButtonPressed(sender: AnyObject) {
        globalUtility.switchLanguageSetting()
        updatePage()
    }
    
    func updatePage(){
        print("Updating Profile Page...")
        if(globalUtility.getIsEnglishLanguageSetting()){
            self.CurrentLanguageTextField.text = "English"
        }else{
            self.CurrentLanguageTextField.text = "日本語"
        }
    }
    
}