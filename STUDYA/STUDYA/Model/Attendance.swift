//
//  Attendance.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

struct UserAttendanceOverall: Codable {
    let totalFine, attendedCount, lateCount, allowedCount, absentCount: Int
    let oneTimeAttendanceInformations: [OneTimeAttendanceInformation]
    
    enum CodingKeys: String, CodingKey {
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentCount = "absentCnt"
        case oneTimeAttendanceInformations = "attendanceDetail"
        case totalFine
    }
}

struct AttendanceStats: Codable {
    let attendedCount, lateCount, allowedCount, absentCount, totalCount, totalFine: Int
    
    enum CodingKeys: String, CodingKey {
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentCount = "absentCnt"
        case totalCount = "totalAttendCnt"
        case totalFine
    }
}

struct OneTimeAttendanceInformation: Codable {
    let fine: Int?
    let attendanceID: Int?
    let attendanceStatus: String?
    let userID: String?
    let studyScheduleDateAndTime: Date
    
    enum CodingKeys: String, CodingKey {
        case studyScheduleDateAndTime = "studyScheduleDateTime"
        case attendanceStatus = "attendance"        
        case attendanceID = "attendanceId"
        case userID = "userId"
        case fine
    }
}

struct AttendanceSeperator {
    var inputString: String
    var attendance: Attendance {
        switch inputString {
        case "ATTENDANCE":
            return .attended
        case "LATENESS":
            return .late
        case "ABSENT":
            return .absent
        case "HOLD":
            return .allowed
        default:
            return .allowed
        }
    }
}

enum Attendance: Codable {
    case attended
    case late
    case absent
    case allowed
    
    var english: String {
        switch self {
        case .attended:
            return "ATTENDANCE"
        case .late:
            return "LATENESS"
        case .absent:
            return "ABSENT"
        case .allowed:
            return "HOLD"
        }
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

struct SingleUserAnAttendanceInformation: Codable {
    var fine: Int
    var attendanceStatus: String
    let userID: String
    let attendanceID: Int
    let nickName: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case fine, nickName
        case attendanceStatus = "attendance"
        case userID = "userId"
        case attendanceID = "attendanceId"
        case imageURL = "img"
    }
}

struct SingleUserAnAttendanceInformationForPut: Codable {
    var fine: Int
    var attendanceStatus: String
    let userID: String
    let attendanceID: Int

    enum CodingKeys: String, CodingKey {
        case fine
        case attendanceStatus = "attendStatus"
        case userID = "userId"
        case attendanceID = "attendanceId"
    }
}

struct AttendanceInformation: Codable {
    let userID, attendanceStatus, reason: String?
    let fine: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case attendanceStatus = "attendStatus"
        case reason, fine
    }
}
