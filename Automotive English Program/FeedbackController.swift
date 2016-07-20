//
//  FeedbackController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 7/18/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class FeedbackController: UIViewController{
    
    var videoPlaybackAsset:AVPlayerLayer?
    let movieURL = Video.downloadVideo("someFolder/TestVideo1.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Feedback page Loaded.")
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("--Audio Session set to playback.")
        } catch{print("**ERROR: Could not set audio session to playback.")}
        
    }
    
    @IBAction func ButtonPressed(sender: AnyObject) {
        print("Button Pressed.")
        globalUtility.requestAudioSession(true)
        initVideos()
        videoPlaybackAsset?.player?.play()
    }
    func initVideos(){
        
        
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
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    
    
}