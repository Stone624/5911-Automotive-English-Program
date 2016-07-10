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
        self.URL = NSBundle.mainBundle().URLForResource("TestVideo1", withExtension: "mp4")!
        self.name = videoName
    }
    
    // function will send this video to S3 bucket
    func uploadVideo(){
        // setup variables for s3 upload request
        let s3bucket = "osuhondaaep"
        let fileType = "mp4"
        let cognitoPoolID = ""
        let region = AWSRegionType.APNortheast1
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: cognitoPoolID)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        //prepare upload request
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = self.URL
        uploadRequest.key = "TestVideo1." + fileType
        uploadRequest.bucket = s3bucket
        uploadRequest.contentType = "video/" + fileType
        
        // use request to send video to server
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.upload(uploadRequest).continueWithBlock{ (task) -> AnyObject! in
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
                print("Unexpected empty result.")
            }
            
            return nil
        }

        

       
            
        
    }
    
    // function will download a video from the S3 bucket
    func downloadVideo(){
        
    }
    
    
}


