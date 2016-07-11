//
//  ViewController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/18/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

// justin made a commit
//THING TO NOTE: Make sure your're connected to the internet (wifi or ceullular),
//make sure capturesession is stopped (not just output session)

//things tried to fix audio issue:
////        asset3.cancelPendingPrerolls()//will this do anything?
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationsTwoController.itemDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3)//added end notif
//  programatically skipping

// FIXED(sort of): AVAudioSession use.
// FIXED: Minimise global reference for proper deallocation.

import UIKit
import AVKit
import MobileCoreServices
import Foundation
import AVFoundation

class ConversationsTwoController: UIViewController, AVCaptureFileOutputRecordingDelegate {
//Delcare Class-wide Variables
    @IBOutlet weak var SentenceLabel: UILabel!
    var redirectToHome:Bool = false
    //button stuff
    var buttonStart: UIButton!
    var buttonStop: UIButton!
    var buttonRerecord: UIButton!
    var buttonPlayback: UIButton!
    var buttonSubmit: UIButton!
    //video stuff
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDeviceVideo : AVCaptureDevice?
    var captureDeviceAudio : AVCaptureDevice?
    var videoPlaybackAsset : AVPlayerLayer?
    
    //Function to redirect when completed.
    override func viewDidAppear(animated: Bool) {
        if(redirectToHome){
            print("Length of conversations is now 0 Merging and expoerting videos then Exiting back to home.")
            globalUtility.requestAudioSession(false)
            globalUtility.mergeAndSend()
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        }
    }
    
//Functions for initialisation of video capture block
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set sentence overlay
        if(globalUtility.getConversationsLength() != 0){
            var sentence = ""
            sentence = globalUtility.getAndRemoveHeadConversationSentence()
            SentenceLabel.text = sentence
            // Create capture session and find camera
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            captureSession.usesApplicationAudioSession = true
            captureSession.automaticallyConfiguresApplicationAudioSession = true
            getVideoInputs()
            if(captureDeviceAudio != nil && captureDeviceVideo != nil){
                do{
                    try beginSession()
                } catch {print("Caught an exception in beginSession().")}
            } else {
                print("ERROR: Could not find both front camera and microphone.")
                redirectToHome = true
            }
        } else {redirectToHome = true}
    }
    
    func getVideoInputs(){
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the front camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDeviceVideo = device as? AVCaptureDevice
                    if captureDeviceVideo != nil {
                        print("USING VIDEO DEVICE: \(device)")
                    }
                }
            }
            if (device.hasMediaType(AVMediaTypeAudio)){
                captureDeviceAudio = device as? AVCaptureDevice
                if(captureDeviceAudio != nil){
                    print("USING AUDIO DEVICE: \(device)")
                }
            }
        }

    }
    
    func configureDevice() throws {
        if let device = captureDeviceVideo {
            try device.lockForConfiguration()
            if(device.isFlashModeSupported(AVCaptureFlashMode.Off)){
                device.focusMode = .Locked
            }
            device.unlockForConfiguration()
        }
        if let device = captureDeviceAudio {
            try device.lockForConfiguration()
            //could do configuration for audio here...
            device.unlockForConfiguration()
        }

    }
    
    func beginSession() throws {
        print("Beginning Session...")
        //configure device (flash)
        try configureDevice()
        do {
            //setup device input/output/preview
            print("Creating input/output and adding to capture session.")
            let inputVideo = try AVCaptureDeviceInput(device: captureDeviceVideo)
            captureSession.addInput(inputVideo)
            let inputAudio = try AVCaptureDeviceInput(device: captureDeviceAudio)
            captureSession.addInput(inputAudio)
            let output = AVCaptureMovieFileOutput()
            output.maxRecordedDuration = CMTimeMakeWithSeconds(20, 1)
            output.minFreeDiskSpaceLimit = 100000000
            //changing movieFragmentInterval doesn't effect anything. Tried 1 and 300 and Invalid.
                //let fragmentInterval:CMTime = CMTimeMake(300, 1)
                //output.movieFragmentInterval = fragmentInterval//kCMTimeInvalid
            captureSession.addOutput(output)
            print("creating preview layer and adding it to the page.")
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.view.layer.addSublayer(previewLayer!)
            previewLayer?.frame = CGRectMake(20, 130, 260, 250)//self.view.layer.frame
            
            //Add UI buttons
            print("Creating and adding Buttons to the page. ")
            buttonStart = UIButton(frame: CGRect(x: 120, y: 400, width: 100, height: 50))
            buttonStart.backgroundColor = .greenColor()
            buttonStart.setTitle("Start", forState: .Normal)
            buttonStart.addTarget(self, action: #selector(ConversationsTwoController.StartButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(buttonStart)
            buttonPlayback = UIButton(frame: CGRect(x: 20, y: 400, width: 100, height: 50))
            buttonPlayback.backgroundColor = .greenColor()
            buttonPlayback.setTitle("Playback", forState: .Normal)
            buttonPlayback.addTarget(self, action: #selector(ConversationsTwoController.PlaybackButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            buttonPlayback.hidden = true
            self.view.addSubview(buttonPlayback)
            buttonSubmit = UIButton(frame: CGRect(x: 220, y: 400, width: 100, height: 50))
            buttonSubmit.backgroundColor = .greenColor()
            buttonSubmit.setTitle("Submit", forState: .Normal)
            buttonSubmit.addTarget(self, action: #selector(ConversationsTwoController.SubmitButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            buttonSubmit.hidden = true
            self.view.addSubview(buttonSubmit)
            buttonStop = UIButton(frame: CGRect(x: 120, y: 400, width: 100, height: 50))
            buttonStop.backgroundColor = .redColor()
            buttonStop.setTitle("Stop", forState: .Normal)
            buttonStop.addTarget(self, action: #selector(ConversationsTwoController.StopButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            buttonStop.hidden = true
            self.view.addSubview(buttonStop)
            buttonRerecord = UIButton(frame: CGRect(x: 120, y: 400, width: 100, height: 50))
            buttonRerecord.backgroundColor = .greenColor()
            buttonRerecord.setTitle("Redo", forState: .Normal)
            buttonRerecord.addTarget(self, action: #selector(ConversationsTwoController.RerecordButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            buttonRerecord.hidden = true
            self.view.addSubview(buttonRerecord)
            //begin capture
            print("Begin Running Capture Session.")
            globalUtility.requestAudioSession(false) // turn off any current audio session for capturesession configuration.
            captureSession.startRunning() // configures audio recording here.
        } catch {print("EXPLOSION! (video attempt blew up.")}
    }
    func StartButtonPressed(sender: UIButton!) {
        print("Start button Pressed! :)")
        buttonStart.hidden = true
        buttonStop.hidden = false
        let str = NSTemporaryDirectory().stringByAppendingString("CCV\(Int(NSDate().timeIntervalSince1970)).mp4")//was just str
        globalUtility.addOutputVideo(str)//videoOutputStrings.append(str)
        print("capture session currently using INPUTS: \(captureSession.inputs)")
        //no need to mess with audio session here. Capturesesion configured it for us.
        captureSession.outputs[0].startRecordingToOutputFileURL(NSURL(fileURLWithPath: str), recordingDelegate: self)
    }
    func StopButtonPressed(sender: UIButton!) {
        print("STOP button pressed")
        captureSession.outputs[0].stopRecording()
        captureSession.stopRunning() // audio session auto-deconfigured
        
        previewLayer?.hidden = true
        buttonStop.hidden = true
        buttonRerecord.hidden = false
        buttonPlayback.hidden = false
        buttonSubmit.hidden = false
        
        let filePath = globalUtility.getLastOutputVideo()//"/tmp/\(videoOutputStrings[videoOutputStrings.count-1])"
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {print("FILE \(filePath) EXISTS")} else {print("FILE DNE")}
        let movieURL = NSURL(fileURLWithPath: filePath/*"/tmp/\(videoOutputStrings[videoOutputStrings.count-1])"*/)
        print("INIT AVASSET WITH: \(movieURL)")
        let asset3 = AVPlayer(URL: movieURL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: asset3.currentItem)
//        asset3.seekToTime(kCMTimeZero)
        asset3.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
        videoPlaybackAsset!.frame = CGRectMake(20, 130, 260, 250)
        videoPlaybackAsset!.backgroundColor = UIColor.orangeColor().CGColor
        videoPlaybackAsset?.videoGravity = AVLayerVideoGravityResizeAspect
        self.view.layer.addSublayer(videoPlaybackAsset!)
    }
    func PlaybackButtonPressed(sender: UIButton!) {
        print("Playback button Pressed! :)")
        globalUtility.requestAudioSession(true)
        videoPlaybackAsset?.player!.seekToTime(kCMTimeZero)
        videoPlaybackAsset?.player!.play()
    }
    func SubmitButtonPressed(sender: UIButton!) {
        print("Submit button Pressed! :)")
        EndVideoPlaybackSession()
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsOneController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        let testVideo: Video = Video(videoURL: "/Users/jmgregorio10/CapstoneProject/5911-Automotive-English-Program/Automotive English Program/TestVideo1.mp4", videoName: "TestVideo1.mp4");
        testVideo.uploadVideo()
    }
    func RerecordButtonPressed(sender: UIButton!){
        print("Rerecord Button Pressed")
        EndVideoPlaybackSession()
        globalUtility.removeLastOutputVideo()
        buttonRerecord.hidden = true
        buttonPlayback.hidden = true
        videoPlaybackAsset?.hidden = true
        buttonSubmit.hidden = true
        buttonStart.hidden = false
        previewLayer?.hidden = false
        captureSession.startRunning() // sound fucks off for some reason... SOLVED: Due to global reference.
    }
    
    //Delegate methods
    func captureOutput(captureOutput: AVCaptureFileOutput!,
                         didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
                                                             fromConnections connections: [AnyObject]!,
                                                                             error: NSError!){
        if(error == nil){
        print("Finished Recording. File successfully created. Link should be \(globalUtility.getLastOutputVideo()), is actually \(outputFileURL)")
            print("USED CONNECTIONS: \(connections)")
        } else {
            print("File NOT written successfully. Something exploded along the way. ERROR: \(error)")
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification){
        print("Item Finished Playing.")
    }
    
    func EndVideoPlaybackSession(){
        print("deallocating video playback items and turning off associated audio session")
        videoPlaybackAsset?.player?.pause()
        videoPlaybackAsset?.player = nil
        videoPlaybackAsset?.removeFromSuperlayer()
        videoPlaybackAsset = nil
        globalUtility.requestAudioSession(false)

    }
    
    
}

