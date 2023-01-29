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
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        let range = email?.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
        return email?.isEmpty == false && password?.isEmpty == false && range != nil
    }
}

//struct SNSInfo {
//    let token: String
//    let provider: String
//}

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
    let totalFine, attendedCount, absentCount, totalStudyHeldCount, lateCount, allowedCount: Int
    let studySchedule: StudyScheduleComing?
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
    let content: String?
    let date: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "scheduleId"
        case content = "scheduleName"
        case date = "scheduleDate"
    }
}

typealias StudyID = String
typealias AllStudyAllSchedule = [StudyID: [StudyScheduleComing]]

struct StudyScheduleComing: Codable {
    let studyName: String?
    let studyScheduleID: Int?
    var studyID: StudyID?
    
    var topic: String?
    var place: String?
    
    var startDateAndTime: Date
    var endDateAndTime: Date
    
    var repeatOption: String? = "" // domb: repeatOption을 받아야 스케쥴셀의 상단부 "매달", "매일"과 같은 요소를 보여줄 수 있음. 현재는 옵션으로 표시
    var bookMarkColor: UIColor? {
        guard let studyID = studyID else { return nil }
        switch Int(studyID)! % 10 {
        case (let number):
            return UIColor(named: "randomColor\(number)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case studyScheduleID = "studyScheduleId"
        case startDateAndTime = "studyScheduleStartDateTime"
        case endDateAndTime = "studyScheduleEndDateTime"
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        case studyName
        case studyID
    }
}

struct StudyScheduleGoing: Codable {
    var studyID: Int?
    var studyScheduleID: Int?
    var topic: String?
    var place: String?
    
    var startDate: String = DateFormatter.dashedDateFormatter.string(from: Date())
    var repeatEndDate: String = ""
    
    var startTime: String?
    var endTime: String?
    
    var repeatOption: String = ""
    
    var periodFormIsFilled: Bool {
        if repeatOption == "" {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil
        } else {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil && repeatEndDate != ""
        }
    }
    var repeatOptionFormIsFilled: Bool {
        if repeatOption != "" {
            return repeatEndDate != ""
        } else {
            return true
        }
    }
    var contentFormIsFilled: Bool {
        return topic != nil && topic != "" && place != nil && place != ""
    }
    
    enum CodingKeys: String, CodingKey {
        case studyID = "studyId"
        case studyScheduleID = "studyScheduleId"
        
        case topic = "studyScheduleName"
        case place = "studySchedulePlace"
        case startTime = "studyScheduleStart"
        case endTime = "studyScheduleEnd"
        case repeatOption = "repeatDay"
        case startDate = "studyScheduleDate"
        case repeatEndDate = "targetDate"
    }
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
        case oneTimeAttendanceInformation = "attendanceDetail"
        case totalFine
    }
}

struct OneTimeAttendanceInformation: Codable {
    let fine, attendanceID: Int
    let attendanceStatus: Attendance
    let userID: String
    let studyScheduleDateAndTime: Date
    
    enum CodingKeys: String, CodingKey {
        case studyScheduleDateAndTime = "studyScheduleDateTime"
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

typealias AllUsersAttendacneForADay = [Time: [SingleUserAnAttendanceInformation]]

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 id 이외의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
typealias Members = [Member]
typealias DashedDate = String
typealias DottedDate = String
typealias Time = String
typealias Deposit = Int
