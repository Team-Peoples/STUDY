//
//  Attendance.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

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

struct AttendanceInformation: Codable {
    let userID, attendanceStatus, reason: String?
    let fine: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case attendanceStatus = "attendStatus"
        case reason, fine
    }
}
