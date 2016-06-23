//
//  ConversationsStartController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/8/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

//load the conversation image file into the image slot

import UIKit
import Foundation
import AVFoundation

class ConversationsStartController: UIViewController, AVAudioPlayerDelegate{
    
    @IBOutlet weak var ConversationImage: UIImageView!
//    var asset1:AVAsset?
//    var asset2: AVPlayerItem?
//    var asset3 = AVPlayer()
    var asset4:AVAudioPlayer?
    var asset5 = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Conversations Start Page loaded.")
        ConversationImage.image = UIImage.init(named: globalUtility.getConversationImageLink())
        print("Convo Image \(globalUtility.getConversationImageLink()) Posted.")
    
        //let AudioSession = AVAudioSession.sharedInstance()
        
        let URL1 = NSBundle.mainBundle().pathForResource(/*globalUtility.getConversationAudioLink()*/"TestAudioHaru", ofType: "mp3")
        let movieURL = NSURL(fileURLWithPath: URL1!)
//        asset1 = AVURLAsset(URL: movieURL)
//        print("ASSET1 TRACKS: \(asset1?.tracks)")
//        print("ASSET1 IS PLAYABLE: \(asset1?.playable)")
//        asset2 = AVPlayerItem(asset: asset1!)
//        asset3.replaceCurrentItemWithPlayerItem(asset2)
//        print("Created asset2 and 3. Playing 3.")
//        if(asset2?.status == AVPlayerItemStatus.ReadyToPlay){
//            asset3.play()
//            print("PLAYING...")
//        } else {
//            print("Not quite ready yet...")
//        }
        do{
            try asset4 = AVAudioPlayer(contentsOfURL: movieURL)
        } catch{print("AVAudioPlayer Init Failed.")}
        do{
            try asset5.setCategory(AVAudioSessionCategoryPlayback)
            try asset5.setActive(true)
        } catch{print("Could not activate audio session.")}
        asset4?.prepareToPlay()
        asset4?.delegate = self
        asset4?.volume = 0.5
        asset4?.play()

    }
    @IBAction func PlayConversationAudioButtonPressed(sender: AnyObject) {
        do{
            try asset5.setActive(true)
        } catch{print("Could not activate audio session.")}

        print("PLAY!!")
        asset4?.prepareToPlay()
        asset4?.play()
        print("asset 4 is playing?: \(asset4?.playing)")

    }
    
    //delegate methods
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        do{
            try asset5.setActive(false)
        } catch{print("Could not activate audio session.")}
        if flag {
            print("successfully finished playing")
        } else {
            print("ERROR: Failed playing")
        }
    }
}