//
//  ConversationsOneController.swift
//  Automotive English Program
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
        let URL1 = globalUtility.getAndRemoveHeadConversationVideos()
        let movieURL = NSURL(fileURLWithPath: URL1)
        let asset3 = AVPlayer(URL: movieURL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3.currentItem)
        asset3.seekToTime(kCMTimeZero)
        asset3.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
        videoPlaybackAsset!.frame = CGRectMake(20, 130, 260, 250)
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
        print("--Finished Playing video, going to camera")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsTwoController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
    
}