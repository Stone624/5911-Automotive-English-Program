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
    
    @IBOutlet weak var SentenceLabel: UILabel!
    var redirectToHome:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var sentence = ""
        if(globalUtility.getConversationsLength() != 0){
            sentence = globalUtility.getAndRemoveHeadConversationSentence()
            SentenceLabel.text = sentence
        } else {
            redirectToHome = true
        }        
        print("Conversations 1 Page loaded.")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(!redirectToHome){
            sleep(5)
            print("Finished Playing video, going to camera")
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsTwoController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        } else {
            print("Length of conversations is now 0, Exiting back to home.")
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        }
    }

}