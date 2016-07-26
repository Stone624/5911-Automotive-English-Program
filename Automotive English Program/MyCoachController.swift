//
//  MyCoachController.swift
//  Automotive English Program
//
//  Programmatic view for MyCoach page. A table view with teacher names, and description for their lessons.
//
//  page objects:
//      Cells = [TEACHER  LESSONS]
//
//  Methods:
//      Table view delegate methods - creates table for English/Japanese setting.
//
//  Created by Tyler Stone on 7/18/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import Foundation
import UIKit

class MyCoachController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyCoach page Loaded.")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {return 1}
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {return "Lesson \(section+1)"}
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let style = UITableViewCellStyle.Value1
        let cell = UITableViewCell(style: style, reuseIdentifier: "MyCoachCell")
            
//            tableView.dequeueReusableCellWithIdentifier("MyCoachCell", forIndexPath: indexPath) as UITableViewCell
        if(globalUtility.currentLanguageIsEnglish){
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "Yuko Hijikata Someya"
                cell.detailTextLabel?.text = "Lessons 1/2"
            case 1:
                cell.textLabel?.text = "Abby Shelton"
                cell.detailTextLabel?.text = "Lessons 2/3"
            case 2:
                cell.textLabel?.text = "Debbie Nicely"
                cell.detailTextLabel?.text = "Lessons 3/4"
            case 3:
                cell.textLabel?.text = "Maria DeMatteo"
                cell.detailTextLabel?.text = "Lessons 4/5"
            default:
                print("How did you get here?")
                cell.textLabel?.text = "HOW DID YOU GET HERE??"
                cell.detailTextLabel?.text = "HOW???"
            }
        } else {
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "ゆこ　土方　染谷"
                cell.detailTextLabel?.text = "授業　１／２"
            case 1:
                cell.textLabel?.text = "アービー　シェルターン"
                cell.detailTextLabel?.text = "授業　２／３"
            case 2:
                cell.textLabel?.text = "デービー　ナイスリー"
                cell.detailTextLabel?.text = "授業　３／４"
            case 3:
                cell.textLabel?.text = "マリア　デマット"
                cell.detailTextLabel?.text = "授業　４／５"
            default:
                print("なんでここにいますか？")
                cell.textLabel?.text = "HOW DID YOU GET HERE??"
                cell.detailTextLabel?.text = "HOW???"
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Click.")
    }
    
}