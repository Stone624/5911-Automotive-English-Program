//
//  ConversationsStartController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//load the conversation image file into the image slot

import UIKit
import Foundation

class ConversationsStartController: UIViewController{
    
    @IBOutlet weak var ConversationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Conversations Start Page loaded.")
        ConversationImage.image = UIImage.init(named: globalUtility.getConversationImageLink())
        print("Convo Image \(globalUtility.getConversationImageLink()) Posted.")
    }
}