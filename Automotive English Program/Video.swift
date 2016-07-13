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
    
    var URL: NSURL
    var name : String
    
    
    init (videoURL: String, videoName: String){
        print("ITITNG WITH \(videoURL) and \(videoName)")
        self.URL = NSURL(fileURLWithPath: videoURL)
        self.name = videoName
        print("Video object Initialized with \(self.URL) and \(self.name)")
    }
    
    // function will send this video to S3 bucket
    func uploadVideo(){
        print("Upload video method called.")
        // setup variables for s3 upload request
        let s3bucket = "osuhondaaep"
        let fileType = "png"
        //next done in AppDelegate
//        let cognitoPoolID = "us-east-1:356286dd-f7c3-4c64-91f6-f8a7b77cc746"
//        let region = AWSRegionType.USEast1
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: cognitoPoolID)
//        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
//        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        print("variables setup and awsServiceManager configuration set.")
        
        //prepare upload request
        print("preparing upload request...")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = s3bucket
        uploadRequest.key = self.name + "." + fileType
        uploadRequest.body = self.URL
        uploadRequest.uploadProgress = { (bytesSent:Int64, totalBytesSent:Int64,  totalBytesExpectedToSend:Int64) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                print("SENT: \(bytesSent)\tTOTAL: \(totalBytesSent)\t/\(totalBytesExpectedToSend)")
            })
        }
        uploadRequest.contentType = "image/" + fileType
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
        
        
//        // use request to send video to server
//        AWSS3TransferManager.registerS3TransferManagerWithConfiguration(configuration, forKey: uploadRequest.key)//"USEast1S3TransferManager")
//        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
//        transferManager.upload(uploadRequest).continueWithBlock{ (task) -> AnyObject! in
//            if let error = task.error{
//                print("Upload failed (\(error)")
//            }
//            if let exception = task.exception{
//                print("Upload failed (\(exception)")
//            }
//            if task.result != nil {
//                let s3URL = NSURL(string: "http://s3.amazonaws.com/\(s3bucket)/\(uploadRequest.key!)")!
//                print("Uploaded to: \n\(s3URL)")
//            } else {
//                print("Unexpected empty result.")
//            }
//            
//            return nil
//        }

        

       
            
        
    }
    
    // function will download a video from the S3 bucket
    func downloadVideo(){
        
    }
    
    
}


