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
