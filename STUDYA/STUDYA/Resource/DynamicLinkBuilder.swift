//
//  DynamicLinkBuilder.swift
//  STUDYA
//
//  Created by 서동운 on 3/18/23.
//

import Foundation
import FirebaseDynamicLinks

struct DynamicLinkBuilder {
    
    func getURL(studyID: ID, completion: @escaping (URL?, [String]?, Error?) -> Void) {
        guard let link = URL(string: "https://www.notion.so/f5a505a1caa6442ca6dde83ee3a7017c?pvs=4&\(studyID)") else { return }
        let dynamicLinksDomainURIPrefix = "https://peoplesofficial.page.link"
        guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else { return }
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        linkBuilder.iOSParameters?.appStoreID = "6446140352"
        
//        linkBuilder.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
//        linkBuilder.navigationInfoParameters?.isForcedRedirectEnabled = true
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "피플즈"
        linkBuilder.socialMetaTagParameters?.descriptionText = "스터디 모임 간편하게 관리해요~!"
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string:  "https://i.ibb.co/BnZfdvd/Group-7189.png")
        
        linkBuilder.shorten(completion: completion)
    }
}
