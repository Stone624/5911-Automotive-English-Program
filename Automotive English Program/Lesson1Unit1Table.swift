//
//  Lesson1Unit1Table.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/15/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class Lesson1Unit1Table: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Unit Embedded Table loaded.")
        
    }
    @IBOutlet weak var ConversationButton: UITableViewCell!
    
    @IBAction func ConversationsButtonPressed(sender: AnyObject) {
        globalUtility.setConversationImageLink("5911HomePageMan.png")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsStartController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
}