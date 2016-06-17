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
    var currentLanguageIsEnglish:Bool = true
    var unitName:String = ""
    var unitImageLink:String = ""
    var conversationImageLink:String = ""
    var conversation = [String]()
    //Methods
    ////Language Setting
    func getIsEnglishLanguageSetting() -> Bool{
        return currentLanguageIsEnglish
    }
    func switchLanguageSetting(){
        currentLanguageIsEnglish = !currentLanguageIsEnglish
    }
    ////Unit Page Stuff
    func setUnitName(name:String){unitName = name}
    func getUnitName() -> String{return unitName}
    
    func setUnitImageLink(name:String){unitImageLink = name}
    func getUnitImageLink()-> String{return unitImageLink}
    
    ////Conversation page stuff
    func setConversationImageLink(name:String){conversationImageLink = name}
    func getConversationImageLink()-> String{return conversationImageLink}
    
    func addConversationSentence(sentence:String){conversation.append(sentence)}
    func getAndRemoveHeadConversationSentence() -> String{
        let sentence = conversation.removeAtIndex(0)
        return sentence
    }
    func getConversationsLength() -> Int{return conversation.count}
}
let globalUtility = GlobalUtility()