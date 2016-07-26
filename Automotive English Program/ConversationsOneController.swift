//
//  ConversationsOneController.swift
//  Automotive English Program
//
//  Conversation Other Page (2/3). This page is the Second page for the Conversation Section. This page (along with 3) can either be a continuing page if there is still content left to do, or a finishing page if there is no content left to do. If it is a continuing page, it will play the other person's video clip of their section of the conversation. At the end of the clip, it goes to page 3. If it is a finishing page, it runs the "mergeAndSend" method.
//  Page Objects:
//      Video - Plays the conversation video
//
//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//Play video, redirect when complete.
//  ViewDidLoad:1. set sentence,
//              2. Set Init Video
//  ViewDidAppear:1. Lock Audio Session     or      Redirect to homepage
//                2. Start video
//  PlayerDidFinishPlaying:1. Unlock Audio
//                         2. Redirect to next page.

//NOTE DO NOT PROVIDE GLOBAL REFERENCE TO AVPLAYER DIRECTLY!! ONLY ACCESS AVPLAYER THROUGH AVPLAYERLAYER. IT WILL NOT FULLY DEALLOCATE AVPLAYER IF A GLOBAL VARIABLE REFERENCES IT, EVEN IF YOU DEREFERENCE IT WITH BOTH GLOBAL AND AVPLAYERLAYER.

import UIKit
import Foundation
import AVFoundation

class ConversationsOneController: UIViewController{
    
    @IBOutlet weak var SentenceLabel: UILabel!
    var redirectToHome:Bool = false
    var videoPlaybackAsset:AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Conversations Page 1 loaded.")
        if(globalUtility.getConversationsLength() != 0){
            var sentence = ""
            sentence = globalUtility.getAndRemoveHeadConversationSentence()
            SentenceLabel.text = sentence
            initVideos()
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                print("--Audio Session set to playback.")
            } catch{print("**ERROR: Could not set audio session to playback.")}
            globalUtility.requestAudioSession(true)
        } else {
            redirectToHome = true
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("--Playing video.")
        videoPlaybackAsset?.player?.play()
        if(redirectToHome){
            print("--Length of conversations is now 0, Exiting back to home.")
            globalUtility.requestAudioSession(false)
            globalUtility.mergeAndSend()
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        }
    }
    
    func initVideos(){
        let movieURL = globalUtility.getAndRemoveHeadConversationVideos()
        let asset3 = AVPlayer(URL: movieURL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3.currentItem)
        asset3.seekToTime(kCMTimeZero)
        asset3.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
        let x = Int(self.view.layer.frame.width * 0.0)
        let y = Int(self.view.layer.frame.height * 0.20)
        let width = Int(self.view.layer.frame.width * 1.0)
        let height = Int(self.view.layer.frame.height * 0.65)
        videoPlaybackAsset!.frame = CGRectMake(CGFloat(x), CGFloat(y), CGFloat(width), CGFloat(height))
//        videoPlaybackAsset!.backgroundColor = UIColor.orangeColor().CGColor
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
        print("--Finished Playing video, going to camera")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsTwoController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
    
}