//
//  StudySchedule.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import UIKit

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
