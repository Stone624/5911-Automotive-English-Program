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
    var videoPlaybackAsset:AVPlayerLayer?
    let fullConvoMovieURL = globalUtility.getConversationVideoLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Conversations Start Page loaded.")
        ConversationImage.image = UIImage(data: NSData(contentsOfURL: globalUtility.getConversationImageLink())!)
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
        let audioURL = globalUtility.getConversationAudioLink()
        do{
            try asset4 = AVAudioPlayer(contentsOfURL: audioURL)
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
    
    
    @IBAction func PlayConversationVideoButtonPressed(sender: AnyObject) {
        print("Button Pressed.")
        globalUtility.requestAudioSession(true)
        initVideos()
        videoPlaybackAsset?.player?.play()
    }
    
    func initVideos(){
        let asset3 = AVPlayer(URL: fullConvoMovieURL)
        print("Playing with URL: \(fullConvoMovieURL)")
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3.currentItem)
        asset3.seekToTime(kCMTimeZero)
        asset3.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
//        self.view.frame.origin.y -= 300
//        self.view.frame.size.height += 300
        let x = Int(self.view.layer.frame.width * 0.0)
        let y = Int(self.view.layer.frame.height * 0.0)//.2
        let width = Int(self.view.layer.frame.width * 1.0)
        let height = Int(self.view.layer.frame.height * 1.0)//0.65)
        videoPlaybackAsset!.frame = CGRectMake(CGFloat(x), CGFloat(y), CGFloat(width), CGFloat(height))
        videoPlaybackAsset!.backgroundColor = UIColor.orangeColor().CGColor
        videoPlaybackAsset?.videoGravity = AVLayerVideoGravityResizeAspect
        self.view.layer.addSublayer(videoPlaybackAsset!)
    }
    
    func playerDidFinishPlaying(note: NSNotification){
        videoPlaybackAsset?.player?.pause()
        videoPlaybackAsset?.player = nil
        videoPlaybackAsset?.removeFromSuperlayer()
        videoPlaybackAsset = nil
        
        print("playback layer removed and nilled")
        globalUtility.requestAudioSession(false)
//        self.view.frame.origin.y += 300
//        self.view.frame.size.height -= 300
        
    }
    
}