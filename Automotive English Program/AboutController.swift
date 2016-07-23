//
//  AboutController.swift
//  Automotive English Program
//
//  Programmatic view for About page.
//  page objects:
//      Description Text Field
//
//  Created by Tyler Stone on 7/18/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class AboutController: UIViewController{

    @IBOutlet weak var DescriptionTextField: UITextView!

    override func viewDidLoad() {
        if(globalUtility.currentLanguageIsEnglish){
            DescriptionTextField.text = "Welcome to the Mobile Application for Honda's Automotive English Program! Created by the Computer Science and Engineering department of the College of Engineering at The Ohio State University. Watch the video to learn how to use this app. (Coming soon)"
        }else{
            DescriptionTextField.text = "本田技研工業株式会社のAEPにようこそ。オハイオ州大学のコンピューターサイエンス学生が作りました。"
        }
    }
}