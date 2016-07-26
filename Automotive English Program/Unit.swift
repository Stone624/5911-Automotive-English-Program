//
//  Lesson1.swift
//  Automotive English Program
//
//  Programmatic view for A Unit page. Content dynamically filled out from GlobalUtility (set in lessons)
//  page objects:
//      Label - Displays current unit
//      Image - Displays unit image
//      Embedded Table view - gives options for progression.
//

//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//Set global variables for each unit and transition when pressed. 

import UIKit
import Foundation

class Unit: UIViewController{
    
    @IBOutlet weak var UnitMainImage: UIImageView!
    @IBOutlet weak var UnitName: UILabel!
    @IBOutlet weak var ContainerObject: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Unit \(globalUtility.getUnitNumber()) Page loaded.")
        self.navigationItem.title = "Unit \(globalUtility.getUnitNumber())"
        self.UnitName.text = globalUtility.getUnitName()
        UnitMainImage.image = UIImage(data: NSData(contentsOfURL: globalUtility.getUnitImageLink())!)
        print("Image posted.")
        
//        
//        let child = UITableView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        print("tableview ADDED")
////        let style = UITableViewCellStyle.Default
////        let cell = UITableViewCell(style: style, reuseIdentifier: "cellID")
//        let delegate = UnitTable()
////        child.dataSource = self
//        child.delegate = delegate
//        print("Delegates ADDED")
//        self.view.addSubview(child)
//        print("VIEW ADDED")
    }
}