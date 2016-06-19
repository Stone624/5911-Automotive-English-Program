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
    var conversation = [String]()
    
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
    func setConversationImageLink(name:String){conversationImageLink = name}
    func getConversationImageLink()-> String{return conversationImageLink}
    
    //func addConversationSentence(sentence:String){conversation.append(sentence)}
    //func clearConversations() -> Void{conversation.removeAll()}
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
}
let globalUtility = GlobalUtility()