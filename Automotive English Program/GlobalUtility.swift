//
//  GlobalUtility.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/6/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import Foundation

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
        let sentence = conversation.removeAtIndex(0)
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
        let sentence = conversationVideos.removeAtIndex(0)
        return sentence
    }
    func getConversationVideosLength() -> Int{return conversationVideos.count}
}
let globalUtility = GlobalUtility()