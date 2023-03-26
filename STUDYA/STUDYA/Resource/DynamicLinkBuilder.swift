//
//  DynamicLinkBuilder.swift
//  STUDYA
//
//  Created by 서동운 on 3/18/23.
//

import Foundation
import FirebaseDynamicLinks

struct DynamicLinkBuilder {
    
    func getURL(study: Study, memberCount: Int, completion: @escaping (URL?, [String]?, Error?) -> Void) {
        
        guard let studyID = study.id,
              let studyName = study.studyName,
              let studyCategory = study.category,
              let studyMasterNickname = study.ownerNickname,
              let studyInfo = study.studyIntroduction else { return }
        let studyOn = study.studyOn.description
        let studyOff = study.studyOff.description
        let memberCount = memberCount
              

        guard let baseURL = URL(string: "https://www.notion.so/f5a505a1caa6442ca6dde83ee3a7017c") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
          URLQueryItem(name: "studyId", value: "\(studyID)"),
          URLQueryItem(name: "studyName", value: studyName),
          URLQueryItem(name: "studyCategory", value: studyCategory),
          URLQueryItem(name: "masterNickname", value: studyMasterNickname),
          URLQueryItem(name: "studyInfo", value: studyInfo),
          URLQueryItem(name: "studyOn", value: studyOn),
          URLQueryItem(name: "studyOff", value: studyOff),
          URLQueryItem(name: "memberCnt", value: "\(memberCount)")
        ]
        guard let link = components?.url else { return }
        let dynamicLinksDomain = "https://peoplesofficial.page.link"
        
        guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomain) else { return }
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        linkBuilder.iOSParameters?.appStoreID = "6446140352"
        
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.room8.peoples")
        
        // 데스크탑을 위한 링크 없이 바로 앱스토어로 리다이렉트 연결하도록 만들어 주는 것.
//        linkBuilder.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
//        linkBuilder.navigationInfoParameters?.isForcedRedirectEnabled = true
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "피플즈"
        linkBuilder.socialMetaTagParameters?.descriptionText = "스터디 모임 간편하게 관리해요~!"
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string:  "https://i.ibb.co/BnZfdvd/Group-7189.png")
        
        linkBuilder.shorten(completion: completion)
    }
}
