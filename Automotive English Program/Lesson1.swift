//
//  Lesson1.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/17/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class Lesson1: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Lesson 1 page Loaded.")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {return 5}
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {return "Lesson \(section+1)"}
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return 3}
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LessonCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "Unit \(indexPath.row+1)"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            globalUtility.setUnitNumber(1)
            globalUtility.setUnitImageLink("5911HomePageMan.png")
            globalUtility.setConversationImageLink("5911Conversations1.png")
            globalUtility.addConversationSentences(["Hi, I'm Mia Clarkson",
                "Hi, My name is [your full name]",
                "It's nice to meet you",
                "It's nice to meet you too.",
                "Where are you from?"
                ,"I'm from [your home town], Japan. Where are you from?",
                "I'm from Toronto Canada.",
                "I see."])
        case 1:
            print("Set unit and global things for Lesson 1 Unit 2")
            globalUtility.setUnitNumber(2)
            globalUtility.setUnitImageLink("5911HomePageMan.png")
            globalUtility.setConversationImageLink("5911HomePageMan.png")
            globalUtility.addConversationSentences(["This is unit 2 to be implemented in the future."])
        case 2:
            print("Set unit and global things for Lesson 1 Unit 3")
            globalUtility.setUnitNumber(3)
            globalUtility.setUnitImageLink("5911HomePageMan.png")
            globalUtility.setConversationImageLink("5911HomePageMan.png")
            globalUtility.addConversationSentences(["This is unit 3 to be implemented in the future."])
        default:
            print("How did you get here? What do you want?")
        }
    }
    
}