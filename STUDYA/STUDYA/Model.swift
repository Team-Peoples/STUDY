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
    let imageURL: String?
    let isEmailCertificated, isBlocked, isPaused, isFirstLogin, isNaverLogin, isKakaoLogin, userStats, pushStart, pushImminent, pushDayAgo: Bool?
    
    init(id: String?, oldPassword: String? = nil, password: String?, passwordCheck: String?, nickName: String?, imageURL: String? = nil, isEmailCertificated: Bool? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, isFirstLogin: Bool? = nil, isNaverLogin: Bool? = nil, isKakaoLogin: Bool? = nil, userStats: Bool? = nil, pushStart: Bool? = nil, pushImminent: Bool? = nil, pushDayAgo: Bool? = nil) {
        self.id = id
        self.oldPassword = oldPassword
        self.password = password
        self.passwordCheck = passwordCheck
        self.nickName = nickName
        self.imageURL = imageURL
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
        case imageURL = "img"
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
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        let range = email?.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
        return email?.isEmpty == false && password?.isEmpty == false && range != nil
    }
}

enum SNS: String {
    case kakao = "kakao"
    case naver = "naver"
}

struct SNSInfo {
    let token: String
    let provider: String
}

struct Study: Codable, Equatable {
    var id: ID?
    var studyOn, studyOff: Bool
    var studyName, category, studyIntroduction, freeRule: String?
    let isBlocked, isPaused: Bool?
    var generalRule: GeneralStudyRule?
    
    var formIsFilled: Bool {
        return category != nil && studyName != nil && studyName != "" && (studyOn != false || studyOff != false) && studyIntroduction != nil && studyIntroduction != ""
    }
    
    var isGeneralFormFilled: Bool {
        // domb: 스터디 규칙쪽 필수 입력 값 시나리오 수정되면 이부분도 수정해야함.
        return generalRule?.absence.time != nil || generalRule?.lateness.time != nil || generalRule?.excommunication.lateness != nil || generalRule?.excommunication.absence != nil || generalRule?.deposit != nil
    }
    var isFreeFormFilled: Bool {
        return freeRule != "" && freeRule != nil
    }

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

    init(id: Int? = nil, studyName: String? = nil, studyOn: Bool = false, studyOff: Bool = false, category: StudyCategory? = nil, studyIntroduction: String? = nil, freeRule: String? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, generalRule: GeneralStudyRule? = GeneralStudyRule(lateness: Lateness(time: nil, count: nil, fine: nil), absence: Absence(time: nil, fine: nil), deposit: nil, excommunication: Excommunication(lateness: nil, absence: nil))) {
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
    
    static func == (lhs: Study, rhs: Study) -> Bool {
        return lhs.generalRule?.lateness == rhs.generalRule?.lateness && lhs.generalRule?.absence == rhs.generalRule?.absence && lhs.generalRule?.deposit == rhs.generalRule?.deposit && lhs.generalRule?.excommunication == rhs.generalRule?.excommunication
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

struct GeneralStudyRule: Codable, Equatable {
    
    var lateness: Lateness
    var absence: Absence
    var deposit: Deposit?
    var excommunication: Excommunication

    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
    }
    
    init(lateness: Lateness = Lateness(), absence: Absence = Absence(), deposit: Deposit? = nil, excommunication: Excommunication = Excommunication()) {
        self.lateness = lateness
        self.absence = absence
        self.deposit = deposit
        self.excommunication = excommunication
    }
}

struct Absence: Codable, Equatable {
    var time, fine: Int?
}

struct Lateness: Codable, Equatable {
    var time, count, fine: Int?
}

struct Excommunication: Codable, Equatable {
    var lateness, absence: Int?

    enum CodingKeys: String, CodingKey {
        case lateness
        case absence = "absent"
    }
}

struct StudyOverall: Codable {
    let announcement: Announcement?
    let study: Study
    let isManager: Bool
    let totalFine, attendedCount, absentcount, totalStudyHeldCount, lateCount, allowedCount: Int
    let studySchedule: StudySchedule?
    let isOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case announcement = "notification"
        case isManager = "manager"
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentcount = "absentCnt"
        case totalStudyHeldCount = "dayCnt"
        case isOwner = "master"
        case study, studySchedule, totalFine
    }
}

struct Announcement: Codable {

    let id: ID?
    let title: String?
    let content: String?
    let createdDate: Date?
    var isPinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case title = "notificationSubject"
        case content = "notificationContents"
        case createdDate = "createdAt"
        case isPinned = "pin"
    }
    
    init(id: Int? = nil, title: String?, content: String?, createdDate: Date?, isPinned: Bool? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.isPinned = isPinned
    }
}

struct Schedule: Codable {
    
    let id: Int?
    let name: String?
    let date: Date?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "scheduleId"
        case name = "scheduleName"
        case date = "scheduleDate"
    }
}

typealias StudyAllSchedule = [String: [StudySchedule]]

struct StudySchedule: Codable {
    let studyName: String?
    
    let studyScheduleID: Int?
    
    var topic: String?
    var place: String?
    
    var startDate: Date?
    var endDate: Date?
    var repeatOption: String? = ""
    // domb: repeatOption을 받아야 스케쥴셀의 상단부 "매달", "매일"과 같은 요소를 보여줄 수 있음. 현재는 옵션으로 표시 
    
    enum CodingKeys: String, CodingKey {
        case studyScheduleID = "studyScheduleId"
        case startDate = "studyScheduleStartDateTime"
        case endDate = "studyScheduleEndDateTime"
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        case studyName
    }
}

struct StudyScheduleGoing: Codable {
    var studyId: Int?
    
    var topic: String?
    var place: String?
    
    var openDate: String? = Date().formatToString(format: .studyScheduleFormat)
    var deadlineDate: String? = ""
    
    var startTime: String?
    var endTime: String?
    var repeatOption: String? = ""
    
    var periodFormIsFilled: Bool {
        if repeatOption == "" {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil
        } else {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil && deadlineDate != ""
        }
    }
    
    var contentFormIsFilled: Bool {
        return topic != nil && topic != "" && place != nil && place != ""
    }
    
    enum CodingKeys: String, CodingKey {
        case studyId
        
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        case startTime = "studyScheduleStart"
        case endTime = "studyScheduleEnd"
        case repeatOption = "repeatDay"
        case openDate = "studyScheduleDate"
        case deadlineDate = "targetDate"
    }
}

//enum RepeatOption: String, Codable {
//    case everyDay = "매일"
//    case everyWeek = "매주"
//    case everyTwoWeeks = "2주 마다"// domb: git book에는 everyTwoWeek으로 되어있어 수정요청
//    case everyMonth = "매달"
//
//    enum CodingKeys: String, CodingKey {
//        case everyDay, everyMonth, everyWeek
//        case everyTwoWeeks = "everyTwoWeek"
//    }
    
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
//}

struct ScheduleAttendanceInformation: Codable {
    let userID: UserID
    let attendanceStatus, reason: String
    let fine: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case attendanceStatus = "attendStatus"
        case reason, fine
    }
}

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 이외에 id가 있는 것들의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
typealias Deposit = Int
