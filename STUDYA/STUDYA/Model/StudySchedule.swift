//
//  StudySchedule.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import UIKit

struct StudySchedule: Codable {
    let studyName: String?
    let studyScheduleID: Int?
    var studyID: StudyID?
    
    var topic: String?
    var place: String?
    
    var startDateAndTime: Date
    var endDateAndTime: Date
    
    var repeatOption: RepeatOption?
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
        case repeatOption = "repeatType"
        case studyName
        case studyID
    }
    
    func convertStudySchedulePosting() -> StudySchedulePosting {
        let studyScheduleID = self.studyScheduleID
        let topic = self.topic
        let place = self.place
        
        let repeatOption = self.repeatOption
    
        let startDate = DateFormatter.dashedDateFormatter.string(from: self.startDateAndTime)
        let startTime = DateFormatter.timeFormatter.string(from: self.startDateAndTime)
        let endDate = DateFormatter.dashedDateFormatter.string(from: self.endDateAndTime)
        let endTime = DateFormatter.timeFormatter.string(from: self.endDateAndTime)

        return StudySchedulePosting(studyID: nil, studyScheduleID: studyScheduleID, topic: topic, place: place, startDate: startDate, repeatEndDate: endDate, startTime: startTime, endTime: endTime, repeatOption: repeatOption ?? .norepeat)
    }
}

struct StudySchedulePosting: Codable {
    var studyID: Int?
    var studyScheduleID: Int?
    var topic: String?
    var place: String?
    
    var startDate: String = DateFormatter.dashedDateFormatter.string(from: Date())
    var repeatEndDate: String = ""
    
    var startTime: String?
    var endTime: String?
    
    var repeatOption: RepeatOption = .norepeat
    
    var periodFormIsFilled: Bool {
        if repeatOption == .norepeat {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil
        } else {
            return startTime != nil && startTime != "" && endTime != "" && endTime != nil && repeatEndDate != ""
        }
    }
    var repeatOptionFormIsFilled: Bool {
        if repeatOption != .norepeat {
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

enum RepeatOption: String, Codable {
    case everyDay
    case everyWeek
    case everyTwoWeeks
    case everyMonth
    case norepeat = ""
    
    enum CodingKeys: String, CodingKey {
        case everyDay
        case everyWeek
        case everyTwoWeeks = "everyTwoWeek"
        case everyMonth
    }
    
    var translatedKorean: String {
        switch self {
        case .everyDay: return "매일"
        case .everyWeek: return "매주"
        case .everyTwoWeeks: return "2주 마다"
        case .everyMonth: return "매달"
        case .norepeat: return ""
        }
    }
}
