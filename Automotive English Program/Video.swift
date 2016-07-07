//
//  Video.swift
//  Automotive English Program
//
//  Created by Justin Gregorio on 7/7/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

// Model class to manage any video manipulation and sending/retrieving from AWS S3.

import Foundation

class Video {
    
    var URL: String
    var name : String
    
    init (videoURL: String, videoName: String){
        self.URL = videoURL
        self.name = videoName
    }
    
    func sendVideoToS3(){
        /*
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new]
        uploadRequest.bucket = "osuhondaaep"
        uploadRequest.key = self.name
        uploadRequest.body = testFileURL
        
        [[transferManager, upload:uploadRequest] continueWithExecutor,:[AWSExecutor mainThreadExecutor]
            withBlock:^id(AWSTask *task) {
            if (task.error) {
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    break;
                    
                    default:
                    NSLog(@"Error: %@", task.error);
                    break;
                    }
                    } else {
                    // Unknown error.
                    NSLog(@"Error: %@", task.error);
                    }
                    }
                    
                    if (task.result) {
                    AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
                    // The file uploaded successfully.
                }
            return nil;
        }];
 */
    }
    
    
}


