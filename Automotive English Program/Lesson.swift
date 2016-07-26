//
//  Lessons.swift
//  Automotive English Program
//
//  Programmatic view for Lessons page. Table view for displaying all lessons and units.
//  page objects:
//      section of Cells = Lessons 1 through 5
//      Cell = [Unit description  ]
//  Methods:
//      Table view delegate methods - sets up a 5 section, 6 cells in section 1 and 18 cells in sections 2 through 5. The L-U combination fill out globalUtility details to be used in the Unit page.
//  Created by Tyler Stone on 6/17/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class Lesson: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Lesson page Loaded.")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {return 5}
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {return "Lesson \(section+1)"}
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x = 0
        switch(section){
        case 0:
            x=6
        default:
            x=18
        }
        return x
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LessonCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "Unit \(indexPath.row+1)"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        //Lesson 1
        case 0:
            switch indexPath.row{
            //Unit 1
            case 0:
                globalUtility.setUnitNumber(1)
                globalUtility.setUnitImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911HomePageMan", ofType: "png")!))
                globalUtility.setConversationImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911Conversations1", ofType: "png")!))
                globalUtility.setConversationVideoLink(Video.downloadVideo("staticContent/L1U1FullConversation.mp4"))
//                globalUtility.setConversationVideoLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("TestVideo1", ofType: "mp4")!))
                globalUtility.addConversationSentences(["Hi, I'm Mia Clarkson",
                "Hi, My name is [your full name]",
                "Could you spell that for me?",
                "Yes. It's [spell your name].",
                "It's nice to meet you",
                "It's nice to meet you too.",
                "Where are you from?",
                "I'm from [your home town], Japan. Where are you from?",
                "I'm from Toronto Canada.",
                "I see."])
                globalUtility.setConversationAudioLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1Caudio", ofType: "m4a")!))
                globalUtility.addConversationVideos([
                    NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1CP1", ofType: "mp4")!),
                NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1CP2", ofType: "mp4")!),
                NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1CP3", ofType: "mp4")!),
                NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1CP4", ofType: "mp4")!),
                NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("L1U1CP5", ofType: "mp4")!)
                    ])
            //Unit 2
            case 1:
                print("Set unit and global things for Lesson 1 Unit 2")
                globalUtility.setUnitNumber(2)
                globalUtility.setUnitImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911HomePageMan", ofType: "png")!))
                globalUtility.setConversationImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911HomePageMan", ofType: "png")!))
                globalUtility.addConversationSentences(["This is unit 2 to be implemented in the future."])
                globalUtility.setConversationAudioLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("TestAudioSeseragi", ofType: "mp3")!))
                globalUtility.addConversationVideos([NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("TestVideo2", ofType: "mp4")!)])
            //Unit 3
            case 2:
                print("Set unit and global things for Lesson 1 Unit 3")
                globalUtility.setUnitNumber(3)
                globalUtility.setUnitImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911HomePageMan", ofType: "png")!))
                globalUtility.setConversationImageLink(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5911HomePageMan", ofType: "png")!))
                globalUtility.addConversationSentences(["This is unit 3 to be implemented in the future."])
            default:
                print("How did you get here? What do you want?")
            }
        //Lesson 2
        case 1:
            switch indexPath.row{
            case 0:
                print("Hello")
            default:
                print("How did you get here?")
            }
        default:
            print("How did you get here?")
        }
    }
    
}