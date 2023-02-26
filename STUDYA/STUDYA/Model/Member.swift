//
//  Member.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

struct MemberListResponse: Codable {
    let memberList: [Member]
    let isUserManager: Bool
    let isUserOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case memberList
        case isUserManager = "manager"
        case isUserOwner = "master"
    }
}

struct Member: Codable {
    let memberID, deposit: Int
    let nickName, profileImageURL, role: String?
    let isManager: Bool
//    let isOwner: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "studyMemberId"
        case nickName = "userNickname"
        case profileImageURL = "img"
        case isManager = "userManager"
//        case isOwner = "userMaster"
        case role = "userRole"
        case deposit
    }
}
