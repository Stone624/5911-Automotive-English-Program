//
//  HomeController.swift
//  Automotive English Program
//
//  Programmatic page for the Home Page
//  Page Objects:
//      Welcome text label
//      How To Get Started Button
//      My Coach Button
//      Lessons Button
//      My Profile Button
//      * One on One Button
//      * Blog Button
//      ? Navigation controller (root page) **NOT IMPLEMENTED**
//  Page Methods:
//      ViewDidLoad
//      ViewWillAppear
//      ? creators for each object **Not functional due to static elements on storyboard** transitions to the corresponding page
//      ? Pressed methods for each button **NOT IMPLEMENTED**
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
    @IBOutlet weak var OneOnOneTextButton: UIButton!
    @IBOutlet weak var BlogTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createWelcomeTextLabel()
        createHowToGetStartedButton()
        createMyCoachButton()
        createLessonsButton()
        createMyProfileButton()
        createOneOnOneButton()
        createBlogButton()
//        let nav:UINavigationController = UINavigationController.init(rootViewController: self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentLanguageIsEnglish:Bool = globalUtility.getIsEnglishLanguageSetting()
        print("Loading page: Got Global Language Setting: English: \(currentLanguageIsEnglish)")
        if(currentLanguageIsEnglish){
            WelcomeTextLabel.text = "Welcome, \(globalUtility.getUsername())!"
            HowToGetStartedTextButton.setTitle("How to get started", forState: .Normal)
            MyCoachTextButton.setTitle("My Coach", forState: .Normal)
            LessonsTextButton.setTitle("Lessons", forState: .Normal)
            MyProfileTextButton.setTitle("My Profile", forState: .Normal)
        }else{
            WelcomeTextLabel.text = "いらっしゃいませ, \(globalUtility.getUsername())さん！"
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
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController")
//        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
//        Video.downloadVideo("someFolder/TestVideo1.mp4")
    }

    @IBAction func BlogButtonPressed(sender: AnyObject) {
        print("Going to blog.")
        if let url = NSURL(string: "http://u.osu.edu/intermediate/") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            print("invalid url")
        }
        //TESTING VIDEO
//        let videoURL = NSBundle.mainBundle().pathForResource("TestVideo1", ofType: "mp4")!
//        print("LINE 1 with \(videoURL)")
//        let video:Video = Video(videoURL: videoURL, s3destination: "TestVideo1")
//        print("LINE 2")
//        video.uploadVideo()
//        print("LINE 3")
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController")
//        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func LogoutButtonPressed(sender: AnyObject) {
        //clear user specific data
        globalUtility.username = "nil.-1"
        //return to login page
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPageNavigationController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
    func createWelcomeTextLabel(){
        let x = Int(self.view.layer.frame.width * 0.05)
        let y = Int(self.view.layer.frame.height * 0.1)
        let width = Int(self.view.layer.frame.width * 0.9)
        let height = 30
        WelcomeTextLabel.frame = CGRect(x: x, y: y, width: width, height: height)
//        WelcomeTextLabel.backgroundColor = .redColor()
    }
    
    func createHowToGetStartedButton(){
        
        let x = Int(self.view.layer.frame.width * 0.05)
        let y = Int(self.view.layer.frame.height * 0.25)
        let width = Int(self.view.layer.frame.width * 0.9)
        let height = 30
        HowToGetStartedTextButton.frame = CGRect(x: x, y: y, width: width, height: height)
        styleButton(HowToGetStartedTextButton)
        
        
        
//        HowToGetStartedTextButton=UIButton(frame: CGRect(x:x,y: y,width:width,height: height))
//        HowToGetStartedTextButton.setTitle("How to Get Start", forState:.Normal)
//        HowToGetStartedTextButton.backgroundColor = .redColor()
//        HowToGetStartedTextButton.addTarget(self, action: #selector(HomeController.BlogButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(HowToGetStartedTextButton)
        
        //            HowToGetStartedTextButton.setTitleColor(UIColor.redColor(), forState:.Normal)
        //            HowToGetStartedTextButton.frame=CGRectMake(15, 50, 300, 500)
        //            HowToGetStartedTextButton.addTarget(self, action: "pressedAction:", forControlEvents:.TouchUpInside)
        //            self.view.addSubview(HowToGetStartedTextButton)
    }
    func createMyCoachButton(){
        let x = Int(self.view.layer.frame.width * 0.0)
        let y = Int(self.view.layer.frame.height * 0.4)
        let width = Int(self.view.layer.frame.width * 1.0)
        let height = 30
        MyCoachTextButton.frame = CGRect(x: x, y: y, width: width, height: height)//UIButton(frame: CGRect(x:x,y: y,width:width,height: height))
        MyCoachTextButton.setTitle("My Coach", forState:.Normal)
        styleButton(MyCoachTextButton)
        

//        MyCoachTextButton.addTarget(self, action: #selector(HomeController.BlogButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(MyCoachTextButton)
    }
    func createLessonsButton(){
        let x = Int(self.view.layer.frame.width * 0.05)
        let y = Int(self.view.layer.frame.height * 0.55)
        let width = Int(self.view.layer.frame.width * 0.9)
        let height = 30
        LessonsTextButton.frame = CGRect(x: x, y: y, width: width, height: height)
        styleButton(LessonsTextButton)
    }
    func createMyProfileButton(){
        let x = Int(self.view.layer.frame.width * 0.05)
        let y = Int(self.view.layer.frame.height * 0.7)
        let width = Int(self.view.layer.frame.width * 0.9)
        let height = 30
        MyProfileTextButton.frame = CGRect(x: x, y: y, width: width, height: height)
        styleButton(MyProfileTextButton)
    }
    func createOneOnOneButton(){
        let x = Int(self.view.layer.frame.width * 0.1)
        let y = Int(self.view.layer.frame.height * 0.85)
        let width = Int(self.view.layer.frame.width * 0.35)
        let height = 30
        OneOnOneTextButton.frame = CGRect(x: x, y: y, width: width, height: height)
        styleButton(OneOnOneTextButton)
    }
    func createBlogButton(){
        let x = Int(self.view.layer.frame.width * 0.55)
        let y = Int(self.view.layer.frame.height * 0.85)
        let width = Int(self.view.layer.frame.width * 0.35)
        let height = 30
        BlogTextButton.frame = CGRect(x: x, y: y, width: width, height: height)
        styleButton(BlogTextButton)
    }
    
    
    func styleButton(button:UIButton){
        //color text/background
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitleColor(.redColor(), forState: .Highlighted)
        button.backgroundColor = .blackColor()
        //create gradient
//        let btnGradient:CAGradientLayer = CAGradientLayer()
//        btnGradient.frame = button.bounds;
//        let colorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor
//        let colorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).CGColor
//        btnGradient.colors = [colorTop, colorBottom]
//        button.layer.insertSublayer(btnGradient, atIndex: 0)
        //round corners
        button.layer.cornerRadius = 5.0
    }
    
    
    
    
    
    
}