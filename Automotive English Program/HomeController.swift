//
//  HomeController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/25/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import Foundation

class HomeController: UIViewController{
    
    @IBOutlet weak var WelcomeTextLabel: UILabel!
    @IBOutlet weak var HowToGetStartedTextButton: UIButton!
    @IBOutlet weak var MyCoachTextButton: UIButton!
    @IBOutlet weak var LessonsTextButton: UIButton!
    @IBOutlet weak var MyProfileTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home Page loaded.")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentLanguageIsEnglish:Bool = globalUtility.getIsEnglishLanguageSetting()
        print("Loading page: Got Global Language Setting: English: \(currentLanguageIsEnglish)")
        if(currentLanguageIsEnglish){
            WelcomeTextLabel.text = "Welcome!"
            HowToGetStartedTextButton.setTitle("How to get started", forState: .Normal)
            MyCoachTextButton.setTitle("My Coach", forState: .Normal)
            LessonsTextButton.setTitle("Lessons", forState: .Normal)
            MyProfileTextButton.setTitle("My Profile", forState: .Normal)
        }else{
            WelcomeTextLabel.text = "いらっしゃいませ！"
            HowToGetStartedTextButton.setTitle("始めましょう", forState: .Normal)
            MyCoachTextButton.setTitle("マイ先生", forState: .Normal)
            LessonsTextButton.setTitle("授業", forState: .Normal)
            MyProfileTextButton.setTitle("マイプロフィール", forState: .Normal)
        }

        print("Home Page appeared.")
    }
    
    @IBAction func OneOnOneButtonPressed(sender: AnyObject) {
        print("Going to 1-on-1 webpage.")
        if let url = NSURL(string: "http://www.google.com") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("invalid url")
        }
    }

    @IBAction func BlogButtonPressed(sender: AnyObject) {
        print("Going to blog.")
        if let url = NSURL(string: "http://u.osu.edu/intermediate/") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("invalid url")
        }
        //TESTING VIDEO
<<<<<<< HEAD
//        let videoURL = NSBundle.mainBundle().pathForResource("TestVideo1", ofType: "mp4")!
//        print("LINE 1 with \(videoURL)")
//        let video:Video = Video(videoURL: videoURL, videoName: "TestVideo1")
//        print("LINE 2")
//        video.uploadVideo()
//        print("LINE 3")
=======
        var video: Video = Video.downloadVideo("TestVideo1.mp4")
>>>>>>> origin/AWS
    }
    
    
    @IBAction func LogoutButtonPressed(sender: AnyObject) {
        //clear user specific data
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPageNavigationController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)

    }
}