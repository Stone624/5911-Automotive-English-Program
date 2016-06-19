//
//  Lesson1.swift
//  Automotive English Program
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Unit \(globalUtility.getUnitNumber()) Page loaded.")
        self.navigationItem.title = "Unit \(globalUtility.getUnitNumber())"
        self.UnitName.text = globalUtility.getUnitName()
        UnitMainImage.image = UIImage.init(named: globalUtility.getUnitImageLink())
        print("Image posted.")
    }
}