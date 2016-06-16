//
//  ConversationsOneController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//Play video, redirect when complete.

import UIKit
import Foundation

class ConversationsOneController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Conversations 1 Page loaded.")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sleep(10)
        print("Finished Playing video, going to camera")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsTwoController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
}