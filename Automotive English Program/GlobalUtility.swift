//
//  GlobalUtility.swift
//  Automotive English Program
//
//  Created by Tyler Stone on 6/6/16.
//  Copyright © 2016 Honda+OSU. All rights reserved.
//

import Foundation

class GlobalUtility {
    var currentLanguageIsEnglish:Bool = true
    
    func getIsEnglishLanguageSetting() -> Bool{
        return currentLanguageIsEnglish
    }
    
    func switchLanguageSetting(){
        currentLanguageIsEnglish = !currentLanguageIsEnglish
    }
}
let globalUtility = GlobalUtility()