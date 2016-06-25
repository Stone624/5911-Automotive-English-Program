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

import UIKit
import Foundation
import AVFoundation

class ConversationsOneController: UIViewController{
    
    @IBOutlet weak var SentenceLabel: UILabel!
    var redirectToHome:Bool = false
//    var asset1:AVAsset?
//    var asset2:AVPlayerItem?
    var asset3:AVPlayer?
    var videoPlaybackAsset:AVPlayerLayer?
//    var asset5 = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Conversations 1 Page loaded.")
        var sentence = ""
        if(globalUtility.getConversationsLength() != 0){
            sentence = globalUtility.getAndRemoveHeadConversationSentence()
            SentenceLabel.text = sentence
            initVideos()
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                print("--Audio Session successfully created.")
            } catch{print("**ERROR: Could not activate audio session.")}
        } else {
            redirectToHome = true
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("--Playing video.")
        asset3?.play()
        if(redirectToHome){
            print("--Length of conversations is now 0, Exiting back to home.")
            do{
                try AVAudioSession.sharedInstance().setActive(false)
                print("----Audio Session successfully destroyed.")
            } catch{print("****ERROR: Could not deactivate audio session.")}
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        }
    }
    
    func initVideos(){
        let URL1 = NSBundle.mainBundle().pathForResource(/*globalUtility.getConversationAudioLink()*/"TestVideo1", ofType: "mp4")
        let movieURL = NSURL(fileURLWithPath: URL1!)
//        asset1 = AVAsset(URL: movieURL)
//        asset2 = AVPlayerItem(asset: asset1!)
        asset3 = AVPlayer(URL: movieURL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3!.currentItem)
        asset3!.seekToTime(kCMTimeZero)
        asset3!.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
        videoPlaybackAsset!.frame = CGRectMake(20, 130, 260, 250)
        videoPlaybackAsset!.backgroundColor = UIColor.orangeColor().CGColor
        videoPlaybackAsset?.videoGravity = AVLayerVideoGravityResizeAspect
//        videoPlaybackAsset?.zPosition = 2
        self.view.layer.addSublayer(videoPlaybackAsset!)
    }

    func playerDidFinishPlaying(note: NSNotification){
        videoPlaybackAsset?.removeFromSuperlayer()
        videoPlaybackAsset = nil
//        AudioOutputUnitStop()
//        AudioUnitUninitialize(<#T##inUnit: AudioUnit##AudioUnit#>)
//        print("playback layer removed and nilled")
//        sleep(5)
//        asset3?.cancelPendingPrerolls()
//        asset3 = nil
//        asset2?.cancelPendingSeeks()
//        asset2 = nil
//        asset1?.cancelLoading()
//        asset1 = nil
//        var success = false
//        var iteration = 1
//        while(!success && iteration < 500){
//            do{
//                try AVAudioSession.sharedInstance().setActive(false)
//                print("--Audio Session successfully destroyed.")
//                success = true
//            } catch{
//                print("**ERROR\(iteration): Could not deactivate audio session.")
////                print(">>ASSET1: \(asset1)")
////                print(">>ASSET2: \(asset2)")
////                print(">>ASSET3: \(asset3)")
////                print(">>videoPlaybackAsset: \(videoPlaybackAsset)")
////                print(">>Number of audio output channels: \(asset5.outputNumberOfChannels)")
////                print(">>Number of MAX audio output channels: \(asset5.maximumOutputNumberOfChannels)")
////                print(">>Number of audio Input channels: \(asset5.inputNumberOfChannels)")
////                print(">>Number of MAX audio input channels: \(asset5.maximumInputNumberOfChannels)")
//                iteration = iteration + 1
//                sleep(1)
//            }
//        }
        print("--Finished Playing video, going to camera")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsTwoController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
}