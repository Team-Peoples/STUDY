//
//  File.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/06.
//

import UIKit

enum Const {
    static let userId = "userId"
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
}

enum AttendanceStatus {
    case attended
    case late
    case absent
    case allowed
}

enum StudyExitViewBottomSheetType {
    case exit
    case close
    case resignMaster
}

enum Task {
    case creating
    case editing
    case viewing
}

enum AttendanceViewType {
    case detail
    case userMode
}

enum AttendanceBottomViewType {
    case daySearchSetting
    case individualUpdate
    case membersPeriodSearchSetting
    case individualPeriodSearchSetting
    
    var view: FullDoneButtonButtomView {
        switch self {
            case .daySearchSetting: return AttendanceBottomDaySearchSettingView(doneButtonTitle: "조회")
            case .individualUpdate: return AttendanceBottomIndividualUpdateView(doneButtonTitle: "완료")
            case .membersPeriodSearchSetting: return AttendanceBottomMembersPeriodSearchSettingView(doneButtonTitle: "조회")
            case .individualPeriodSearchSetting: return AttendanceBottomIndividualPeriodSearchSettingView(doneButtonTitle: "조회")
        }
    }
    
    var detent: CGFloat {
        switch self {
            case .daySearchSetting: return 316
            case .individualUpdate: return 316
            case .membersPeriodSearchSetting: return 381
            case .individualPeriodSearchSetting: return 291
        }
    }
}

enum StudyCategory: String, CaseIterable {
    case language = "어학"
    case dev_prod_design = "개발/기획/디자인"
    case project = "프로젝트"
    case getJob = "취업"
    case certificate = "자격시험/자격증"
    case pastime = "자기계발/취미"
    case etc = "그 외"
    
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

enum RepeatOption: String {
    case everyDay = "매일"
    case everyWeek = "매주"
    case everyTwoWeeks = "2주 마다"
    case everyMonth = "매달"
    
    var kor: String {
        return self.rawValue
    }
}

enum CalendarKind {
    case study
    case personal
}

enum PopUpCalendarType {
    case open
    case deadline
}
