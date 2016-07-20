//
//  Lesson1Unit1Table.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/15/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class UnitTable: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Unit Embedded Table loaded.")
        
    }
    
    var data = ["Pronunciation","Conversations","Speaking Assessment","Feedback"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("UnitCell", forIndexPath: indexPath) as UITableViewCell
        let style = UITableViewCellStyle.Default
        let cell = UITableViewCell(style: style, reuseIdentifier: "UnitCell")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            print("Pronunciations Pressed.")
        case 1:
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsStartController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        case 2:
            print("Speaking Assessment Pressed.")
        case 3:
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        default:
            print("How did you get here?")
        }
    }
    
}