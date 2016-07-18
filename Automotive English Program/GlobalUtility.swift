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
        print("Merging videos...")
        let completeMovie = mergeVideos()
        print("Finished merged movie at: \(completeMovie)")
        print("Uploading Video...")
        let testVideo:Video = Video(videoURL: completeMovie,videoName: "TEST\(Int(NSDate().timeIntervalSince1970))")
        testVideo.uploadVideo()
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