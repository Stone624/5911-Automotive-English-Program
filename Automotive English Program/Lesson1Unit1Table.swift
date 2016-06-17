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
    
    var data = ["Pronunciation","Conversations","Speaking Assessment"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UnitCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            print("Pronunciations Pressed.")
        case 1:
            globalUtility.setConversationImageLink("5911HomePageMan.png")
            globalUtility.addConversationSentence("Hi, I'm Mia Clarkson")
            globalUtility.addConversationSentence("Hi, My name is [your full name]")
            globalUtility.addConversationSentence("It's nice to meet you")
            globalUtility.addConversationSentence("It's nice to meet you too.")
            globalUtility.addConversationSentence("Where are you from?")
            globalUtility.addConversationSentence("I'm from [your home town], Japan. Where are you from?")
            globalUtility.addConversationSentence("I'm from Toronto Canada.")
            globalUtility.addConversationSentence("I see.")
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsStartController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        case 2:
            print("Speaking Assessment Pressed.")
        default:
            print("How did you get here?")
        }
    }
    
}