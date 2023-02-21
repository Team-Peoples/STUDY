//
//  Study.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

struct Study: Codable, Equatable {
    var id: ID?
    var studyOn, studyOff: Bool
    var ownerNickname: String?
    var studyName, category, studyIntroduction, freeRule: String?
    let isBlocked, isPaused: Bool?
    var generalRule: GeneralStudyRule?
    
    var formIsFilled: Bool {
        return category != nil && studyName != nil && studyName != "" && (studyOn != false || studyOff != false) && studyIntroduction != nil && studyIntroduction != ""
    }
    var generalRuleIsEmpty: Bool {
        return !timeSectionIsFilled || !fineSectionIsFilled || !excommunicationSectionIsFilled
    }
    
    var timeSectionIsFilled: Bool {
        return generalRule?.lateness != nil || generalRule?.absence.time != nil
    }
    
    var fineSectionIsFilled: Bool {
        return generalRule?.lateness.count != nil || generalRule?.lateness.fine != 0 || generalRule?.absence.fine != 0
    }
    
    var depositSectionIsFilled: Bool {
        return generalRule?.deposit != 0
    }
    
    var excommunicationSectionIsFilled: Bool {
        return generalRule?.excommunication.lateness != nil || generalRule?.excommunication.absence != nil
    }
    
    var freeRuleIsEmpty: Bool {
        return freeRule == "" || freeRule == nil
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

    init(id: Int? = nil, studyName: String? = nil, studyOn: Bool = false, studyOff: Bool = false, category: StudyCategory? = nil, studyIntroduction: String? = nil, freeRule: String? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, generalRule: GeneralStudyRule? = GeneralStudyRule(lateness: Lateness(time: nil, count: nil, fine: 0), absence: Absence(time: nil, fine: 0), deposit: 0, excommunication: Excommunication(lateness: nil, absence: nil))) {
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
    var deposit: Deposit
    var excommunication: Excommunication

    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
    }
    
    init(lateness: Lateness = Lateness(), absence: Absence = Absence(), deposit: Deposit = 0, excommunication: Excommunication = Excommunication()) {
        self.lateness = lateness
        self.absence = absence
        self.deposit = deposit
        self.excommunication = excommunication
    }
}

struct Absence: Codable, Equatable {
    var time: Int?
    var fine: Int = 0
}

struct Lateness: Codable, Equatable {
    var time, count: Int?
    var fine: Int = 0
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
    let ownerNickname: String
    let study: Study
    let isManager: Bool
    let totalFine, attendedCount, absentCount, totalStudyHeldCount, lateCount, allowedCount: Int
    let studySchedule: StudyScheduleComing?
    let isOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case announcement = "notification"
        case isManager = "manager"
        case ownerNickname = "masterNickname"
        case attendedCount = "attendanceCnt"
        case lateCount = "latenessCnt"
        case allowedCount = "holdCnt"
        case absentCount = "absentCnt"
        case totalStudyHeldCount = "dayCnt"
        case isOwner = "master"
        case study, studySchedule, totalFine
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
    
    var translatedKorean: String {
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
    
    var translatedKorean: String {
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

enum UserTaskInStudyInfo: String {
    
    case leave = "스터디 탈퇴" // 스터디 탈퇴(나가기) - 재가입 가능
    case ownerClose = "스터디 종료"// 스터디 종료 - 재가입 불가능
    case resignMaster = "스터디 양도"
    
    var translatedKorean: String {
        return self.rawValue
    }
}
