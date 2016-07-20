//
//  Video.swift
//  Automotive English Program
//
//  Created by Justin Gregorio on 7/7/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

// Model class to manage any video manipulation and sending/retrieving from AWS S3.

import Foundation
import AWSS3

class Video {
    
    //URL of LOCAL video to upload
    var URL: NSURL
    //Name of REMOTE destination the file gets written to
    var s3destination : String
    
    
    init (videoURL: String, s3destination: String){
        print("ITITNG WITH \(videoURL) and \(s3destination)")
        self.URL = NSURL(fileURLWithPath: videoURL)
        self.s3destination = s3destination
        print("Video object Initialized with \(self.URL) and \(self.s3destination)")
    }
    
    init (videoURL: NSURL, s3destination: String){
        print("ITITNG WITH \(videoURL) and \(s3destination)")
        self.URL = videoURL
        self.s3destination = s3destination
        print("Video object Initialized with \(self.URL) and \(self.s3destination)")
    }
    
    // function will send this video to S3 bucket
    func uploadVideo(){
        print("Upload video method called.")
        // setup variables for s3 upload request
        let s3bucket = "osuhondaaep"
        let fileType = "mov"
        
        //prepare upload request
        print("preparing upload request...")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = s3bucket
        uploadRequest.key = self.s3destination
        uploadRequest.body = self.URL
        uploadRequest.uploadProgress = { (bytesSent:Int64, totalBytesSent:Int64,  totalBytesExpectedToSend:Int64) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                print("SENT: \(bytesSent)\tTOTAL: \(totalBytesSent)\t/\(totalBytesExpectedToSend)")
            })
        }
        uploadRequest.contentType = "video/" + fileType
        print("upload request preparation complete.")
        AWSS3TransferManager.defaultS3TransferManager().upload(uploadRequest).continueWithBlock{ (task) -> AnyObject! in
            if let error = task.error{
                print("Upload failed (\(error)")
            }
            if let exception = task.exception{
                print("Upload failed (\(exception)")
            }
            if task.result != nil {
                let s3URL = NSURL(string: "http://s3.amazonaws.com/\(s3bucket)/\(uploadRequest.key!)")!
                print("Uploaded to: \n\(s3URL)")
            } else {
                print("***AWS S3 UPLOAD FAILED.")
            }
            
            return nil
        }
        
    }
    
    // function will download a video from the S3 bucket
    // Given the string for the name of the file in the s3 bucket,
    // it returns an NSURL pointing to the downloaded resource.
    class func downloadVideo(downloadName: String) -> NSURL{
        print("Download video method called.")
//        let sema: dispatch_semaphore_t = dispatch_semaphore_create(0)
        // setup variables for s3 upload request
        let s3bucket = "osuhondaaep"
        // prepare download URL
        let downloadPath: NSString = NSTemporaryDirectory().stringByAppendingString("FROMAWS\(Int(NSDate().timeIntervalSince1970)).mp4")//downloadName
        let downloadURL: NSURL = NSURL(fileURLWithPath: downloadPath as String)
        print("DOWNLOAD URL: \(downloadURL.absoluteString), DOWNLOAD PATH: \(downloadPath as String)")
        
        //prepare upload request
        print("preparing download request...")
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = s3bucket
        downloadRequest.key = downloadName
        downloadRequest.downloadingFileURL = downloadURL
        downloadRequest.downloadProgress = { (bytesSent:Int64, totalBytesSent:Int64,  totalBytesExpectedToSend:Int64) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                print("DOWNLOADED: \(bytesSent)\tTOTAL: \(totalBytesSent)\t/\(totalBytesExpectedToSend)")
            })
        }
        print("download request preparation complete.")
        AWSS3TransferManager.defaultS3TransferManager().download(downloadRequest)//.continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock:{ (task) -> AnyObject! in
            .continueWithBlock{ (task) -> AnyObject! in
            if let error = task.error{
                print("Download failed (\(error)")
            }
            if let exception = task.exception{
                print("Download failed (\(exception)")
            }
            if task.result != nil {
               print("Downloaded to: \n\(downloadURL)")
            } else {
                print("***AWS S3 DOWNLOAD FAILED.")
            }
//            dispatch_semaphore_signal(sema)
//            globalUtility.setAWSResourceDownloadComplete(true)
            
            return nil
        }
        
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        
        return downloadURL

    }
    
    
}