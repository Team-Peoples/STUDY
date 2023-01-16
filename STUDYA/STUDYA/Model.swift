//
//  Model.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/08.
//

import UIKit

// MARK: - Model

struct Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    mutating func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

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

struct Study: Codable, Equatable {
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
    var deposit: Int?
    var excommunication: Excommunication

    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
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
    let totalFine, attendedCount, absentCount, totalStudyHeldCount, lateCount, allowedCount: Int
    let studySchedule: StudySchedule?
    let isOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case announcement = "notification"
        case isManager = "manager"
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentCount = "absentCnt"
        case totalStudyHeldCount = "dayCnt"
        case isOwner = "master"
        case study, studySchedule, totalFine
    }
}

struct Announcement: Codable {

    let id: Int?
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

struct StudySchedule: Codable {
    
    let studyID: Int?
    let studyName: String?
    
    let studyScheduleID: Int?
    
    var topic: String? // domb: gitbook에는 studyScheduleName: 모임이름이라고 되어있어 수정요청.
    var place: String?
    
    var startTime: Date?
    var endTime: Date?
    var repeatOption: RepeatOption?
    
    enum CodingKeys: String, CodingKey {
        
        case studyID = "studyId"
        case studyName // domb: 전체 스터디 일정조회에는 어떤 스터디인지 알려주는 기능이 있기때문에 스터디 이름도 받아야함.
        
        case studyScheduleID = "studyScheduleId"
        
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        
        case startTime = "studyScheduleStartDateTime"
        case endTime = "studyScheduleEndDateTime"
        case repeatOption = "repeatDay"
    }
}

struct StudyScheduleGoing: Codable {
    
    let studyId: Int?
    let studyName: String?
    
    let studyScheduleID: Int?
    
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
        
        case studyScheduleID = "studyScheduleId"
        
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
    case noRepeat
    
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
        case .noRepeat:
            return ""
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

struct ScheduleAttendanceInformation: Codable {
    let userID: UserID
    let attendanceStatus: Attendance
    let reason: String
    let fine: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case attendanceStatus = "attendStatus"
        case reason, fine
    }
}

struct MyAttendanceOverall: Codable {
    let totalFine, attendedCount, lateCount, allowedCount, absentCount: Int
    let oneTimeAttendanceInformation: [OneTimeAttendanceInformation]
    
    enum CodingKeys: String, CodingKey {
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentCount = "absentCnt"
        case totalFine, oneTimeAttendanceInformation
    }
}

struct OneTimeAttendanceInformation: Codable {
    let fine, attendanceID: Int
    let attendanceStatus: Attendance
    let userID: String
    let studyScheduleDate: Date
    
    enum CodingKeys: String, CodingKey {
        case studyScheduleDate = "studyScheduleDateTime"
        case attendanceStatus = "attendStatus"
        
        case attendanceID = "attendanceId"
        case userID = "userId"
        case fine
    }
}

struct SingleUserAnAttendanceInformation: Codable {
    var fine: Int
    var attendanceStatus: Attendance
    let userID: String
    let attendanceID: Int
//    let nickName: String?
//    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case fine
        case attendanceStatus = "attendance"
        case userID = "userId"
        case attendanceID = "attendanceId"
    }
}

enum Attendance: Codable {
    case attended
    case late
    case absent
    case allowed
    
    enum CodingKEys: String, CodingKey {
        case attended = "ATTENDANCE"
        case late = "LATENESS"
        case absent = "ABSENT"
        case allowed = "HOLD"
    }
    
    var korean: String {
        switch self {
        case .attended:
            return "출석"
        case .late:
            return "지각"
        case .absent:
            return "결석"
        case .allowed:
            return "사유"
        }
    }
    
    var color: AssetColor {
        switch self {
            case .attended:
                return .attendedMain
            case .late:
                return .lateMain
            case .absent:
                return .absentMain
            case .allowed:
                return .allowedMain
        }
    }
    
    var priority: Int {
        switch self {
        case .attended:
            return 1
        case .late:
            return 2
        case .absent:
            return 3
        case .allowed:
            return 4
        }
    }
}

typealias AllUsersAttendacneForADay = [Time: [SingleUserAnAttendanceInformation]]

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 이외에 id가 있는 것들의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
typealias DashedDate = String
typealias DottedDate = String
typealias Time = String

