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
    var videoOutputStrings : [String] = []
    var asset1: AVAsset?
    var asset2: AVPlayerItem?
    var asset3 = AVPlayer()
    var videoPlaybackAsset : AVPlayerLayer?
    //Function to redirect when completed.
    override func viewDidAppear(animated: Bool) {
        if(redirectToHome){
            print("Length of conversations is now 0, Exiting back to home.")
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageNavigationController")
            self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
        }
    }
//Functions for initialisation of video capture block
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set sentence overlay
        var sentence = ""
        if(globalUtility.getConversationsLength() != 0){
            sentence = globalUtility.getAndRemoveHeadConversationSentence()
            SentenceLabel.text = sentence
        } else {redirectToHome = true}
        // Create capture session and find camera
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        getVideoInputs()
        if(captureDeviceAudio != nil && captureDeviceVideo != nil){
            do{
                try beginSession()
            } catch {print("Caught an exception in beginSession().")}
        }
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
                        print("Video Capture device found")
                        print("USING DEVICE: \(device)")
                    }
                }
            }
            if (device.hasMediaType(AVMediaTypeAudio)){
                captureDeviceAudio = device as? AVCaptureDevice
                if(captureDeviceAudio != nil){
                    print("Audio Capture device found")
                    print("USING DEVICE: \(device)")
                }
            }
        }

    }
    
    func configureDevice() throws {
        print("Configuring Camera Device...")
        if let device = captureDeviceVideo {
            try device.lockForConfiguration()
            if(device.isFlashModeSupported(AVCaptureFlashMode.Off)){
                device.focusMode = .Locked
            }
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() throws {
        print("Beginning Session...")
        //configure device (flash)
        try configureDevice()
        do {
            //setup device input/output/preview
            print("Creating camera input and adding to session.")
            let inputVideo = try AVCaptureDeviceInput(device: captureDeviceVideo)
            captureSession.addInput(inputVideo)
            let inputAudio = try AVCaptureDeviceInput(device: captureDeviceAudio)
            captureSession.addInput(inputAudio)
            print("Creating video output and adding to session.")
            let output = AVCaptureMovieFileOutput()
            output.maxRecordedDuration = CMTimeMakeWithSeconds(20, 1)
            output.minFreeDiskSpaceLimit = 100000000
            output.movieFragmentInterval = kCMTimeInvalid//Will this fix sound??
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
            captureSession.startRunning()
        } catch {print("EXPLOSION! (video attempt blew up.")}
    }
    func StartButtonPressed(sender: UIButton!) {
        print("Start button Pressed! :)")
        buttonStart.hidden = true
        buttonStop.hidden = false
        let str = "CCV\(Int(NSDate().timeIntervalSince1970)).mov"
        videoOutputStrings.append(str)
        print("capturesession INPUTS: \(captureSession.inputs)")
        captureSession.outputs[0].startRecordingToOutputFileURL(NSURL(fileURLWithPath: "/tmp/\(str)"), recordingDelegate: self)
    }
    func StopButtonPressed(sender: UIButton!) {
        print("STOP button pressed")
        captureSession.outputs[0].stopRecording()
        captureSession.stopRunning()
        previewLayer?.hidden = true
        buttonStop.hidden = true
        buttonRerecord.hidden = false
        buttonPlayback.hidden = false
        buttonSubmit.hidden = false
        
        let filePath = "/tmp/\(videoOutputStrings[videoOutputStrings.count-1])"
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {print("FILE \(filePath) EXISTS")} else {print("FILE DNE")}
        let movieURL = NSURL(fileURLWithPath: filePath/*"/tmp/\(videoOutputStrings[videoOutputStrings.count-1])"*/)
        print("INIT AVASSET WITH: \(movieURL)")
        asset1 = AVAsset(URL: movieURL)
        print("ASSET1 TRACKS: \(asset1?.tracks)")
        print("ASSET1 IS PLAYABLE: \(asset1?.playable)")
        asset2 = AVPlayerItem(asset: asset1!)
        print("VIDEO DURATION: \(asset2?.duration)")
//        if(asset2?.status == AVPlayerItemStatus.ReadyToPlay){
//        asset3 = AVPlayer(playerItem: asset2!)
        asset3.replaceCurrentItemWithPlayerItem(asset2)
        asset3.seekToTime(kCMTimeZero)
        asset3.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        videoPlaybackAsset = AVPlayerLayer(player: asset3)
        videoPlaybackAsset!.frame = CGRectMake(20, 130, 260, 250)
        videoPlaybackAsset!.backgroundColor = UIColor.orangeColor().CGColor
        videoPlaybackAsset?.videoGravity = AVLayerVideoGravityResizeAspect
        self.view.layer.addSublayer(videoPlaybackAsset!)
//                if(videoPlaybackAsset?.readyForDisplay == true){
    }
    func PlaybackButtonPressed(sender: UIButton!) {
        print("Playback button Pressed! :)")
        asset3.seekToTime(kCMTimeZero)
        asset3.play()
    }
    func SubmitButtonPressed(sender: UIButton!) {
        print("Submit button Pressed! :)")
        sendVideoDataViaFTP("TylerStone",password: "",ip: "192.168.1.110",fileName: videoOutputStrings[videoOutputStrings.count-1])
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationsOneController")
        self.presentViewController(vc! as UIViewController, animated: true, completion: nil)
    }
    func RerecordButtonPressed(sender: UIButton!){
        print("Rerecord Button Pressed")
        buttonRerecord.hidden = true
        buttonPlayback.hidden = true
        videoPlaybackAsset?.hidden = true
        buttonSubmit.hidden = true
        buttonStart.hidden = false
        previewLayer?.hidden = false
        captureSession.startRunning() // sound fucks off for some reason...
    }
    
    //Delegate methods
    func captureOutput(captureOutput: AVCaptureFileOutput!,
                         didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
                                                             fromConnections connections: [AnyObject]!,
                                                                             error: NSError!){
        if(error == nil){
        print("Finished Recording. File successfully created. Link should be /tmp/\(videoOutputStrings[videoOutputStrings.count-1]), is actually \(outputFileURL)")
            print("USED CONNECTIONS: \(connections)")
        } else {
            print("File NOT written successfully. Something exploded along the way. ERROR: \(error)")
        }
    }
    
////////////////////////////////////////////////////////////////
    
    //FTP Send Data Method
    func sendVideoDataViaFTP(username:String,password:String,ip:String,fileName:String){
        print("DOING AN FTP!!")
        let videoData = NSData(contentsOfURL: NSURL(fileURLWithPath: "/tmp/\(fileName)"))
        print("got video data Length: \(videoData?.length)")
        let ServerLocation = "/Users/TylerStone/FtpFiles/5911\(fileName)"
        let FTPString = NSURL(string: "ftp://\(username):\(password)@\(ip):21/\(ServerLocation)")
        print("FTP Connecting with URL \(FTPString)")
        let FTPStream = CFWriteStreamCreateWithFTPURL(nil,FTPString!).takeUnretainedValue()
        print("FTPSTREAM: \(FTPStream)")
        let cfstatus    = CFWriteStreamOpen(FTPStream)
        print("CFSTATUS: \(cfstatus)") //<< REPLACE
        if cfstatus == false {print("ERROR: Failed to connect to FTP server.")}else{
            let buf:UnsafePointer<UInt8>! = UnsafePointer<UInt8>((videoData?.bytes)!)
            let buf2:UnsafePointer<UInt8>! = UnsafePointer<UInt8>((videoData?.bytes)!)
            let buf3:UnsafeMutablePointer<Void>! = UnsafeMutablePointer(videoData!.bytes)
            var totalBytesWritten = 0
            var bytesWritten = 0
            var bytesLeft = (videoData?.length)!
            let fileLength = (videoData?.length)!
            print("SENDING \(fileLength) BYTES:")
            repeat{
                bytesWritten = CFWriteStreamWrite(FTPStream, buf, bytesLeft)
                print("BytesWritten: \(bytesWritten)")
                totalBytesWritten += bytesWritten
                if (bytesWritten < fileLength) {
                    bytesLeft = fileLength - totalBytesWritten
                    memmove(buf3, buf2 + bytesWritten, bytesLeft)
                }else{bytesLeft = 0}
                print("Bytes Left: \(bytesLeft)")
                if CFWriteStreamCanAcceptBytes(FTPStream) == false{sleep(1)}
            }while((totalBytesWritten < fileLength && bytesWritten >= 0) /*|| (bytesLeft != 0)*/)
            if totalBytesWritten == fileLength{print("Files Successfully transferred!")}else{print("ERROR: File did not transfer successfully (bytes written != video length)")}
            print("Closing Stream...")
            CFWriteStreamClose(FTPStream)
        }
    }

}

