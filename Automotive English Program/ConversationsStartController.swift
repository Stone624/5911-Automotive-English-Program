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
        ConversationImage.image = UIImage(data: NSData(contentsOfURL: globalUtility.getConversationImageLink())!)
            //.init(named: globalUtility.getConversationImageLink())
        print("--Convo Image \(globalUtility.getConversationImageLink()) Posted.")
        initAudio()
    }
    @IBAction func PlayConversationAudioButtonPressed(sender: AnyObject) {
        print("--Play Button Pressed")
        //HIDE BUTTONS
        if(!(asset4?.playing)!){
            globalUtility.requestAudioSession(true)
            asset4?.prepareToPlay()
            asset4?.play()
            print("----Audio playing")
        } else {
            print("----Audio is currently playing. Doing nothing")
        }
    }
    
    func initAudio(){
        var v1 = true
        var v2 = true
        let movieURL = globalUtility.getConversationAudioLink()
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
        globalUtility.requestAudioSession(false)
        if flag {
            print("----successfully finished playing")
        } else {
            print("****ERROR: Failed to finish playing successfully")
        }
        //UNHIDE BUTTONS
    }
}