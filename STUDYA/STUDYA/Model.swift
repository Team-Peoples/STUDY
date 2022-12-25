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
    var studyName, category, studyIntroduction, freeRule: String?
    let isBlocked, isPaused: Bool?
    var generalRule: GeneralStudyRule?

    enum CodingKeys: String, CodingKey {

        case id = "studyId"
        case studyName = "studyName"
        case category = "studyCategory"
        case studyIntroduction = "studyInfo"
        case freeRule = "studyFlow"
        case isBlocked = "studyBlock"
        case isPaused = "studyPause"
        case generalRule = "studyRule"
        case studyOn, studyOff
    }

    init(id: Int? = nil, studyName: String? = nil, studyOn: Bool = false, studyOff: Bool = false, category: StudyCategory? = nil, studyIntroduction: String? = nil, freeRule: String? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, generalRule: GeneralStudyRule? = GeneralStudyRule(lateness: Lateness(time: nil, count: nil, fine: nil), absence: Absence(time: nil, fine: nil), deposit: 0, excommunication: Excommunication(lateness: nil, absence: nil))) {
        self.id = id
        self.studyName = studyName
        self.studyOn = studyOn
        self.studyOff = studyOff
        self.category = category?.rawValue
        self.studyIntroduction = studyIntroduction
        self.freeRule = freeRule
        self.isBlocked = isBlocked
        self.isPaused = isPaused
        self.generalRule = generalRule
    }
}

enum StudyCategory: String, CaseIterable {
    case language = "LANGUAGE"
    case dev_prod_design = "DEVELOPED"
    case project = "PROJECT"
    case getJob = "EMPLOYMENT"
    case certificate = "CERTIFICATE"
    case pastime = "HOBBY"
    case etc = "ETC"
    
    var rawValueWithKorean: String {
        switch self {
        case .language:
            return "어학"
        case .dev_prod_design:
            return "개발/기획/디자인"
        case .project:
            return "프로젝트"
        case .getJob:
            return "취업"
        case .certificate:
            return "자격시험/자격증"
        case .pastime:
            return "자기계발/취미"
        case .etc:
            return "그 외"
        }
    }
    
    var indexPath: IndexPath {
        switch self {
            case .language:
                return IndexPath(item: 0, section: 0)
            case .dev_prod_design:
                return IndexPath(item: 1, section: 0)
            case .project:
                return IndexPath(item: 2, section: 0)
            case .getJob:
                return IndexPath(item: 3, section: 0)
            case .certificate:
                return IndexPath(item: 4, section: 0)
            case .pastime:
                return IndexPath(item: 5, section: 0)
            case .etc:
                return IndexPath(item: 6, section: 0)
        }
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
    var lateness: Lateness
    var absence: Absence
    var deposit: Int?
    var excommunication: Excommunication

    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
    }
}

struct Absence: Codable {
    var time, fine: Int?
}

struct Lateness: Codable {
    var time, count, fine: Int?
}

struct Excommunication: Codable {
    var lateness, absence: Int?

    enum CodingKeys: String, CodingKey {
        case lateness
        case absence = "absent"
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

struct StudySchedule: Codable {
    
    let studyId: String? = nil
    let studyName: String?
    
    var topic: String? // domb: gitbook에는 studyScheduleName: 모임이름이라고 되어있어 수정요청.
    var place: String?
    
    var openDate: String?
    var deadlineDate: String?
    var startTime: String?
    var endTime: String?
    var repeatOption: RepeatOption?
    
    enum CodingKeys: String, CodingKey {
        
        case studyId
        case studyName // domb: 전체 스터디 일정조회에는 어떤 스터디인지 알려주는 기능이 있기때문에 스터디 이름도 받아야함.
        
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        
        case openDate = "studyScheduleDate"
        case deadlineDate = "targetDate"
        case startTime = "studyScheduleStart"
        case endTime = "studyScheduleEnd"
        case repeatOption = "repeatDay"
    }
}

enum RepeatOption: String, Codable {
    case everyDay
    case everyWeek
    case everyTwoWeeks // domb: git book에는 everyTwoWeek으로 되어있어 수정요청
    case everyMonth
//    case unknown
    
    var kor: String {
        switch self {
        case .everyDay:
            return "매일"
        case .everyWeek:
            return "매주"
        case .everyTwoWeeks:
            return "2주 마다"
        case .everyMonth:
            return "매달"
//        case .unknown:
//            return "반복 설정 오류"
        }
    }
    
//    public init(from decoder: Decoder) throws {
//        self = try RepeatOption(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
//    }
//
//    public init(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: )
////            try container.encode(id, forKey: .id)
////            try container.encode(name, forKey: .name)
////            try container.encode(birth, forKey: .birth)
////            try container.encode(phoneNum, forKey: .phoneNum)
//        }
}

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 이외에 id가 있는 것들의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
