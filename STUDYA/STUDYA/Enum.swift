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

enum SceneType {
    case exit
    case close
    case resignMaster
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

enum CalendarKind {
    case study
    case personal
}
