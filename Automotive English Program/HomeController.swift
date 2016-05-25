//
//  HomeController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/25/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class HomeController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Home Page loaded.")
    }
    
    @IBAction func OneOnOneButtonPressed(sender: AnyObject) {
        print("Going to 1-on-1 webpage.")
        if let url = NSURL(string: "http://www.google.com") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("invalid url")
        }
    }

    @IBAction func BlogButtonPressed(sender: AnyObject) {
        print("Going to blog.")
        if let url = NSURL(string: "http://www.amazon.com") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("invalid url")
        }

    }
    
    
}