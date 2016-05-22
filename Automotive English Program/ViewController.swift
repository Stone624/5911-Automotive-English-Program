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
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var password = ""
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "outputVideo.mov"
    @IBOutlet weak var CaptureButton: UIButton!
    @IBOutlet weak var PasswordField: UITextField!
    
    
    @IBAction func PasswordEntered(sender: AnyObject) {
        password = PasswordField.text!
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Code that runs when the Capture Button is pressed. Should alert if the camera is unavailable, or open the camera, preferrebly in the front, if the camera is available. (2/3)
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
            print("ERROR: Camera Unavailable.")
        }
    }
    
    //Code that runs when the "use video" button is pressed after taking a video. Should get the temporary file URL of the video, and send it to a server for teachers to be able to view.
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
            videoData?.writeToFile(dataPath, atomically: false) // << Could replace
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Send video (via url) to FTP server
            let username = "" // <<MUST BE HARD CODED
            //password = "123"
            let ip = "" // <<MUST BE HARD CODED
            let fileName = "/Users/TylerStone/FtpFiles/5911AEP\(Int(NSDate().timeIntervalSince1970)).mov"
            let FTPString = NSURL(string: "ftp://\(username):\(password)@\(ip):21/\(fileName)")
            let FTPStream = CFWriteStreamCreateWithFTPURL(nil,FTPString!).takeUnretainedValue()
            let cfstatus    = CFWriteStreamOpen(FTPStream)
            // connection fail
            print("VALUE OF FTPSTRING: \(FTPString)")
            print("VALUE OF CFSTATUS: \(cfstatus)")
            if cfstatus == false {
                print("ERROR: Failed to connect to FTP server.")
            }else{
                let buf:UnsafePointer<UInt8>! = UnsafePointer<UInt8>((videoData?.bytes)!)
                let buf2:UnsafePointer<UInt8>! = UnsafePointer<UInt8>((videoData?.bytes)!)
                let buf3:UnsafeMutablePointer<Void>! = UnsafeMutablePointer(videoData!.bytes)
                print("\(buf)\(buf2)\(buf3)")
                
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
                    }else{
                        bytesLeft = 0
                    }
                    print("Bytes Left: \(bytesLeft)")
                    if CFWriteStreamCanAcceptBytes(FTPStream) == false{
                        sleep(1)
                    }
                    
                    
                }while((totalBytesWritten < fileLength && bytesWritten >= 0) /*|| (bytesLeft != 0)*/)
                
                
                if totalBytesWritten == fileLength{
                    print("Files Successfully transferred!")
                }else{
                    print("ERROR: File did not transfer successfully (bytes written != video length)")
                }
                print("Closing Stream...")
                CFWriteStreamClose(FTPStream)
            }
            
        } else {
            print("ERROR: Failed to get video URL")
        }
        
        /*imagePicker.dismissViewControllerAnimated(true, completion: {
            /* Anything you want to happen when the user saves an video*/
            print("DISMISSED CONTROLLER.")
        })*/
    }

}

