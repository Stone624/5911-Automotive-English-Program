//
//  ViewController.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 5/18/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "outputVideo.mov"
    @IBOutlet weak var CaptureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CaptureButtonPressed(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(/*UIImagePickerControllerSourceType*/.Camera){
            print("Camera Available.")
            imagePicker.sourceType = .Camera
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil{
                print("Front camera available")
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
            
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else{
            print("Camera Unavailable.")
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Video Recording Finished. Got a Video!!!")
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            print("Got a URL! It is: \(pickedVideo)")
            // Save video to the main photo album
            //let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
            //UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            videoData?.writeToFile(dataPath, atomically: false)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        /*imagePicker.dismissViewControllerAnimated(true, completion: {
            /* Anything you want to happen when the user saves an video*/
            print("DISMISSED CONTROLLER.")
        })*/
    }

}

