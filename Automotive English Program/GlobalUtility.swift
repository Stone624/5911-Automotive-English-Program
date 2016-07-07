//
//  GlobalUtility.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/6/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import Foundation
import AVFoundation

class GlobalUtility {
    //Fields
    ////Language Settings
    var currentLanguageIsEnglish:Bool = true
    ////Unit Page Settings
    var unitNumber:Int = 0
    var unitName:String = ""
    var unitImageLink:String = ""
    ////Conversation Page settings
    var conversationImageLink:String = ""
    var conversationAudioLink:String = ""
    var conversation = [String]()
    var conversationVideos = [String]()
    var outputVideos = [String]()
    
    //Methods
    ////Language Settings
    func getIsEnglishLanguageSetting() -> Bool{
        return currentLanguageIsEnglish
    }
    func switchLanguageSetting(){
        currentLanguageIsEnglish = !currentLanguageIsEnglish
    }
    ////Unit Page Settings
    func setUnitNumber(number:Int){unitNumber = number}
    func getUnitNumber() -> Int{return unitNumber}
    
    func setUnitName(name:String){unitName = name}
    func getUnitName() -> String{return unitName}
    
    func setUnitImageLink(name:String){unitImageLink = name}
    func getUnitImageLink()-> String{return unitImageLink}
    
    ////Conversation page settings
    //Image
    func setConversationImageLink(name:String){conversationImageLink = name}
    func getConversationImageLink()-> String{return conversationImageLink}
    //Audio
    func setConversationAudioLink(name:String){conversationAudioLink = name}
    func getConversationAudioLink()-> String{return conversationAudioLink}
    //Sentences
    func addConversationSentences(sentences:[String]){
        conversation.removeAll()
        for sentence in sentences{
            conversation.append(sentence)
        }
    }
    func getAndRemoveHeadConversationSentence() -> String{
        let sentence = conversation.removeFirst()
        return sentence
    }
    func getConversationsLength() -> Int{return conversation.count}
    //Video
    func addConversationVideos(sentences:[String]){
        conversationVideos.removeAll()
        for sentence in sentences{
            conversationVideos.append(sentence)
        }
    }
    func getAndRemoveHeadConversationVideos() -> String{
        let sentence = conversationVideos.removeFirst()
        outputVideos.append(sentence)
        return sentence
    }
    func getConversationVideosLength() -> Int{return conversationVideos.count}
    func addOutputVideo(video:String){outputVideos.append(video)}
    func removeLastOutputVideo(){outputVideos.removeLast()}
    func getLastOutputVideo()->String{return outputVideos[outputVideos.count-1]}
    func getAndRemoveHeadOutputVideos() -> String{
        let sentence = outputVideos.removeFirst()
        return sentence
    }
    func getOutputVideosLength() -> Int{return outputVideos.count}
    
    //////////////////////////////////////////////////////////////
    //            ^^^ Object fields and methods ^^^             //
    //----------------------------------------------------------//
    //  vvv common functions for both conversation pages vvv    //
    //////////////////////////////////////////////////////////////
    
    //AUDIO
    func requestAudioSession(setting:Bool){
        var success = false
        var iteration = 1
        while(!success && iteration < 500){
            do{
                try AVAudioSession.sharedInstance().setActive(setting)
                print("Audio Session successfully turned \(setting).")
                success = true
            } catch{
                print("ERROR\(iteration): Could not deactivate audio session.")
                iteration = iteration + 1
                sleep(1)
            }
        }
    }
    
    //Merge videos together and send via FTP to server
    func mergeAndSend(){
        let completeMovie = mergeVideos()
        print("Waiting for merge to be completed...")
        //        return sendVideoDataViaFTP("TylerStone", password: "", ip: "192.168.1.102", fileName: completeMovie)
        globalUtility.addConversationVideos([completeMovie])
    }
    
    //Merge videos
    func mergeVideos() -> String{
        let composition = AVMutableComposition()
        let trackVideo:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let trackAudio:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime = kCMTimeZero
        repeat{
            let moviePath = globalUtility.getAndRemoveHeadOutputVideos()
            let moviePathUrl = NSURL(fileURLWithPath: moviePath)
            let sourceAsset = AVURLAsset(URL: moviePathUrl, options: nil)
            
            let tracks = sourceAsset.tracksWithMediaType(AVMediaTypeVideo)
            let audios = sourceAsset.tracksWithMediaType(AVMediaTypeAudio)
            
            if tracks.count > 0{
                let assetTrack:AVAssetTrack = tracks[0] as AVAssetTrack
                do{
                    try trackVideo.insertTimeRange(CMTimeRangeMake(kCMTimeZero,sourceAsset.duration), ofTrack: assetTrack, atTime: insertTime)
                }catch{print("ERROR: Failed to insert time range when Merging Videos (video)!")}
                let assetTrackAudio:AVAssetTrack = audios[0] as AVAssetTrack
                do{
                    try trackAudio.insertTimeRange(CMTimeRangeMake(kCMTimeZero,sourceAsset.duration), ofTrack: assetTrackAudio, atTime: insertTime)
                }catch{print("ERROR: Failed to insert time range when Merging Videos (audio)!")}
                insertTime = CMTimeAdd(insertTime, sourceAsset.duration)
            }
        }while(globalUtility.getOutputVideosLength() > 0)
        
        var completeMovie = NSTemporaryDirectory().stringByAppendingString("MERGED\(Int(NSDate().timeIntervalSince1970)).mp4")
        let completeMovieUrl = NSURL(fileURLWithPath: completeMovie)
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter!.outputURL = completeMovieUrl
        exporter!.outputFileType = AVFileTypeMPEG4 //AVFileTypeQuickTimeMovie
        var complete:Bool = false
        exporter!.exportAsynchronouslyWithCompletionHandler({
            switch exporter!.status{
            case  AVAssetExportSessionStatus.Failed:
                print("failed \(exporter!.error)")
                completeMovie=""
                complete=true
            case AVAssetExportSessionStatus.Cancelled:
                print("cancelled \(exporter!.error)")
                completeMovie=""
                complete=true
            default:
                print("complete")
                complete=true
            }
        })
        print("FILE SUCCESSFULLY COMPLETED AT \(completeMovie).")
        globalUtility.addConversationVideos([completeMovie])
        repeat{print("WAITING FOR COMPLETE...");sleep(1)}while(!complete)
        return completeMovie
    }
    
    //FTP Send Data Method
    func sendVideoDataViaFTP(username:String,password:String,ip:String,fileName:String){
        print("DOING AN FTP!!")
        let videoData = NSData(contentsOfURL: NSURL(fileURLWithPath: fileName))
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
let globalUtility = GlobalUtility()