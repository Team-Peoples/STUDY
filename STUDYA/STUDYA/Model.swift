//
//  Model.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/08.
//

import Foundation

// MARK: - Model

struct User: Codable {
    var id: String?
    let oldPassword: String?
    let password: String?
    let passwordCheck: String?
    let nickName: String?
    let image: String?
    let isEmailCertificated, isBlocked, isPaused, isFirstLogin, isNaverLogin, isKakaoLogin, userStats, pushStart, pushImminent, pushDayAgo: Bool?
    
    init(id: String?, oldPassword: String? = nil, password: String?, passwordCheck: String?, nickName: String?, image: String? = nil, isEmailCertificated: Bool? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, isFirstLogin: Bool? = nil, isNaverLogin: Bool? = nil, isKakaoLogin: Bool? = nil, userStats: Bool? = nil, pushStart: Bool? = nil, pushImminent: Bool? = nil, pushDayAgo: Bool? = nil) {
        self.id = id
        self.oldPassword = oldPassword
        self.password = password
        self.passwordCheck = passwordCheck
        self.nickName = nickName
        self.image = image
        self.isEmailCertificated = isEmailCertificated
        self.isBlocked = isBlocked
        self.isPaused = isPaused
        self.isFirstLogin = isFirstLogin
        self.isNaverLogin = isNaverLogin
        self.isKakaoLogin = isKakaoLogin
        self.userStats = userStats
        self.pushStart = pushStart
        self.pushImminent = pushImminent
        self.pushDayAgo = pushDayAgo
    }

    enum CodingKeys: String, CodingKey {

        case password, pushStart, pushImminent, pushDayAgo
        case id = "userId"
        case oldPassword = "old_password"
        case passwordCheck = "password_check"
        case nickName = "nickname"
        case image = "img"
        case isFirstLogin = "firstLogin"
        case isEmailCertificated = "emailAuthentication"
        case isBlocked = "userBlock"
        case isPaused = "userPause"
        case isNaverLogin = "sns_naver"
        case isKakaoLogin = "sns_kakao"
        case userStats = "userStats"
    }
}



struct Credential: Encodable {
    let userID: String
    let password: String?
}

enum SNS: String {
    case kakao = "kakao"
    case naver = "naver"
}

struct SNSInfo {
    let token: String
    let provider: String
}

struct Study: Codable {
    let id: Int?
    var studyOn, studyOff: Bool
    var studyName, category, studyIntroduction, freeRule, po: String?
    let isBlocked, isPaused: Bool?
    var generalRule: GeneralStudyRule?
    let startDate: Date?
    let endDate: Date?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "studyId"
        case studyName = "studyName"
        case category = "studyCategory"
        case studyIntroduction = "studyInfo"
        case freeRule = "studyFlow"
        case isBlocked = "studyBlock"
        case isPaused = "studyPause"
        case generalRule = "studyRule"
        case startDate = "start"
        case endDate = "end"
        case studyOn, studyOff, po
    }
    
    init(id: Int?, studyName: String? = nil, studyOn: Bool = false, studyOff: Bool = false, category: StudyCategory? = nil, studyIntroduction: String? = nil, freeRule: String? = nil, po: String? = nil, isBlocked: Bool?, isPaused: Bool?, generalRule: GeneralStudyRule? = GeneralStudyRule(lateness: Lateness(), absence: Absence(), deposit: nil, excommunication: Excommunication()), startDate: Date?, endDate: Date?) {
        self.id = id
        self.studyName = studyName
        self.studyOn = studyOn
        self.studyOff = studyOff
        self.category = category?.rawValue
        self.studyIntroduction = studyIntroduction
        self.freeRule = freeRule
        self.po = po
        self.isBlocked = isBlocked
        self.isPaused = isPaused
        self.generalRule = generalRule
        self.startDate = startDate
        self.endDate = endDate
    }
}

enum OnOff: String {
    case on
    case off
    case onoff
    
    var eng: String {
        return self.rawValue
    }
    
    var kor: String {
        switch self {
            case .on:
                return "온라인"
            case .off:
                return "오프라인"
            case .onoff:
                return "온라인/오프라인"
        }
    }
}

struct GeneralStudyRule: Codable {
    var lateness: Lateness?
    var absence: Absence?
    var deposit: Int?
    var excommunication: Excommunication?
    
    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
    }
}

struct Announcement: Codable {
    let id: Int?
    let studyID: Int?
    let title: String?
    let content: String?
    let createdDate: Date?
    var isPinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case studyID = "studyId"
        case title = "notificationSubject"
        case content = "notificationContents"
        case createdDate = "createdAt"
        case isPinned = "pin"
    }
}

struct Schedule: Codable {
    
    let id: Int?
    let name: String?
    let date: Date?
    let status: String? //상태가 머머 있는거지?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "scheduleId"
        case name = "scheduleName"
        case date = "scheduleDate"
    }
}

struct StudySchedule: Decodable {
    
    var studyName: String?
    var openDate: Date?
    var deadlineDate: Date?
    var startTime: Date?
    var endTime: Date?
    var repeatOption: RepeatOption?
    var topic: String?
    var place: String?
}

struct Absence: Codable {
    var time, fine: Int?
}

struct Lateness: Codable {
    var time, count, fine: Int?
}

struct Excommunication: Codable {
    var lateness, absence: Int?
}

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 이외에 id가 있는 것들의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
