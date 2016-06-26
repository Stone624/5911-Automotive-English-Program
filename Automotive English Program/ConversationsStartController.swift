//
//  ConversationsStartController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//load image file, create audio that plays when the button is pressed.

import UIKit
import Foundation
import AVFoundation

class ConversationsStartController: UIViewController, AVAudioPlayerDelegate{
    
    @IBOutlet weak var ConversationImage: UIImageView!
    var asset4:AVAudioPlayer?
    var asset5 = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Conversations Start Page loaded.")
        ConversationImage.image = UIImage.init(named: globalUtility.getConversationImageLink())
        print("--Convo Image \(globalUtility.getConversationImageLink()) Posted.")
        initAudio()
    }
    @IBAction func PlayConversationAudioButtonPressed(sender: AnyObject) {
        print("--Play Button Pressed")
        if(!(asset4?.playing)!){
            do{
                try asset5.setActive(true)
                print("----Audio Session Successfully created")
            } catch{print("****Could not activate audio session.")}

            print("----Audio playing")
            asset4?.prepareToPlay()
            asset4?.play()
        } else {
            print("----Audio is currently playing. Doing nothing")
        }
    }
    
    func initAudio(){
        var v1 = true
        var v2 = true
        let URL1 = NSBundle.mainBundle().pathForResource(/*globalUtility.getConversationAudioLink()*/"TestAudioHaru", ofType: "mp3")
        let movieURL = NSURL(fileURLWithPath: URL1!)
        do{
            try asset4 = AVAudioPlayer(contentsOfURL: movieURL)
            asset4?.delegate = self
        } catch{print("**ERROR: AVAudioPlayer Init Failed.");v1=false}
        do{
            try asset5.setCategory(AVAudioSessionCategoryPlayback)
        } catch{print("**ERROR: Could not activate audio session.");v2=false}
        if(v1 && v2){
            print("--Audio Initialisation successfully completed")
        } else {
            print("**ERROR: Something went wrong in Audio Init")
        }
    }
    
    //delegate methods
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        do{
            try asset5.setActive(false)
            print("----Audio Session Successfully Destroyed")
        } catch{print("****Could not activate audio session.")}
        if flag {
            print("----successfully finished playing")
        } else {
            print("****ERROR: Failed to finish playing successfully")
        }
    }
}