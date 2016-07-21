//
//  GlobalUtility.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/6/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//
//  GlobalUtility (and instance globalUtility) is a class that provides
//  app-wide global utility functions for various cases. This includes
//  dynamic information that is generated in one view, meant for another
//  view. The current uses (field/method pairs) that exist are:
//
//  Current User        -- storing the name of the user for user-specific data
//  Language Settings   -- Switch between Japanese and English for text
//  Unit Page           -- Data for a specific Unit view
//  Conversations       -- data necessary for a conversation flow 
//
//  Audio Session       -- Proper function for turning Audio Session on/off
//  Video Merge         -- functions for merging the conversation videos, and uploading to S3




import Foundation
import AVFoundation

class GlobalUtility {

    //// Current User
    var username:String = "nil.-1"
    func getUsername() -> String{return username}
    func setUsername(Username:String){self.username = Username}
    
    //// Language Settings
    var currentLanguageIsEnglish:Bool = true
    func getIsEnglishLanguageSetting() -> Bool{return currentLanguageIsEnglish}
    func switchLanguageSetting(){currentLanguageIsEnglish = !currentLanguageIsEnglish}
    
    ////Unit Page Settings
    var unitNumber:Int = 0
    var unitName:String = ""
    var unitImageLink:NSURL?
    func setUnitNumber(number:Int){unitNumber = number}
    func getUnitNumber() -> Int{return unitNumber}
    
    func setUnitName(name:String){unitName = name}
    func getUnitName() -> String{return unitName}
    
    func setUnitImageLink(name:NSURL){unitImageLink = name}
    func getUnitImageLink()-> NSURL{return unitImageLink!}
    
    ////Conversation Page settings
    var conversationImageLink:NSURL?
    var conversationAudioLink:NSURL?
    var conversationVideoLink:NSURL?
    var conversation = [String]()
    var conversationVideos = [NSURL]()
    var outputVideos = [NSURL]()
    //OverallImage
    func setConversationImageLink(name:NSURL){conversationImageLink = name}
    func getConversationImageLink()-> NSURL{return conversationImageLink!}
    //OverallAudio
    func setConversationAudioLink(name:NSURL){conversationAudioLink = name}
    func getConversationAudioLink()-> NSURL{return conversationAudioLink!}
    //OverallVideo
    func setConversationVideoLink(name:NSURL){conversationVideoLink = name}
    func getConversationVideoLink()-> NSURL{return conversationVideoLink!}
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
    func addConversationVideos(sentences:[NSURL]){
        conversationVideos.removeAll()
        for sentence in sentences{
            conversationVideos.append(sentence)
        }
    }
    func getAndRemoveHeadConversationVideos() -> NSURL{
        let sentence = conversationVideos.removeFirst()
        outputVideos.append(sentence)
        return sentence
    }
    func getConversationVideosLength() -> Int{return conversationVideos.count}
    func addOutputVideo(video:NSURL){outputVideos.append(video)}
    func removeLastOutputVideo(){outputVideos.removeLast()}
    func getLastOutputVideo()->NSURL{return outputVideos[outputVideos.count-1]}
    func getAndRemoveHeadOutputVideos() -> NSURL{
        let sentence = outputVideos.removeFirst()
        return sentence
    }
    func getOutputVideosLength() -> Int{return outputVideos.count}
    
    
    //AWS S3 download synchronous key
    var AWSResourceDownloadComplete: Bool = false
    func IsAWSResourceDownloadComplete()->Bool{
        if(AWSResourceDownloadComplete){
            AWSResourceDownloadComplete = false
            return true
        }else{
            return false
        }
    }
    func setAWSResourceDownloadComplete(complete:Bool){
        AWSResourceDownloadComplete = complete
    }
    
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
        print("Merging videos...")
        let completeMovie = mergeVideos()
        print("Finished merged movie at: \(completeMovie)")
        print("Uploading Video...")
        let testVideo:Video = Video(videoURL: completeMovie,s3destination: "\(username)/\(Int(NSDate().timeIntervalSince1970)).mov")
        testVideo.uploadVideo()
    }
    
    //Merge videos
    func mergeVideos() -> String{
        let composition = AVMutableComposition()
        let trackVideo:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let trackAudio:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime = kCMTimeZero
        repeat{
            let moviePathUrl = globalUtility.getAndRemoveHeadOutputVideos()
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
        
        //Default video is rotated 90 degrees after mergings for some reason. This line re-oriantates correctly.
        trackVideo.preferredTransform = CGAffineTransformMake(0, 1.0, 1.0, 0, 0, 0)
        
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
        var i = 0
        repeat{print("WAITING FOR EXPORT TO COMPLETE... \(i)");sleep(1);i=i+1;}while(!complete)
        print("FILE SUCCESSFULLY COMPLETED AT \(completeMovie).")
        return completeMovie
    }

}
let globalUtility = GlobalUtility()