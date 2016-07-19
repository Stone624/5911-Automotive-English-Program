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
            //how to get start function test
            
            func howTostart(){
                
                let x = Int(self.view.layer.frame.width * 0.1)
                let y = Int(self.view.layer.frame.height * 0.85)
                let width = Int(self.view.layer.frame.width * 0.8)
                let height = 30
                HowToGetStartedTextButton=UIButton(frame: CGRect(x:x,y: y,width:width,height: height))
                HowToGetStartedTextButton.setTitle("How to Get Start", forState:.Normal)
                HowToGetStartedTextButton.backgroundColor = .redColor()
                HowToGetStartedTextButton.addTarget(self, action: #selector(HomeController.BlogButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(HowToGetStartedTextButton)
                
//            HowToGetStartedTextButton.setTitleColor(UIColor.redColor(), forState:.Normal)
//            HowToGetStartedTextButton.frame=CGRectMake(15, 50, 300, 500)
//            HowToGetStartedTextButton.addTarget(self, action: "pressedAction:", forControlEvents:.TouchUpInside)
//            self.view.addSubview(HowToGetStartedTextButton)
            }
            
            func pressedAction(sender:UIButton){
                
            }
            
            func myCoach(){
                let x = Int(self.view.layer.frame.width * 0.1)
                let y = Int(self.view.layer.frame.height * 0.85)
                let width = Int(self.view.layer.frame.width * 0.8)
                let height = 30
                MyCoachTextButton=UIButton(frame: CGRect(x:x,y: y,width:width,height: height))
                MyCoachTextButton.setTitle("My Coach", forState:.Normal)
                MyCoachTextButton.backgroundColor = .redColor()
                MyCoachTextButton.addTarget(self, action: #selector(HomeController.BlogButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(MyCoachTextButton)
                
            }
    
            
            //MyCoachTextButton.setTitle("My Coach", forState: .Normal)
            LessonsTextButton.setTitle("Lessons", forState: .Normal)
            MyProfileTextButton.setTitle("My Profile", forState: .Normal)
        }else{
            
            func languageJap(){
                
                let x = Int(self.view.layer.frame.width * 0.1)
                let y = Int(self.view.layer.frame.height * 0.85)
                let width = Int(self.view.layer.frame.width * 0.8)
                let height = 30
                HowToGetStartedTextButton=UIButton(frame: CGRect(x:x,y: y,width:width,height: height))
            WelcomeTextLabel.text = "いらっしゃいませ！"
            HowToGetStartedTextButton.setTitle("始めましょう", forState: .Normal)
                HowToGetStartedTextButton.backgroundColor = .redColor()
                HowToGetStartedTextButton.addTarget(self, action: #selector(HomeController.BlogButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(HowToGetStartedTextButton)
                
    
            MyCoachTextButton.setTitle("マイ先生", forState: .Normal)
            LessonsTextButton.setTitle("授業", forState: .Normal)
            MyProfileTextButton.setTitle("マイプロフィール", forState: .Normal)
            }
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

    }
    
    
    @IBAction func LogoutButtonPressed(sender: AnyObject) {
        //clear user specific data
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPageNavigationController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)

    }
}