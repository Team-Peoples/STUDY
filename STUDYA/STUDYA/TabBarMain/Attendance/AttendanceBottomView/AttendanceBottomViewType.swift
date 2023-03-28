//
//  AttendanceBottomViewType.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

enum AttendanceBottomViewType {
//    case daySearchSetting
//    case individualUpdate
    case membersPeriodSearchSetting
    
    var view: FullDoneButtonButtomView {
        switch self {
//            case .daySearchSetting: return AttendanceBottomDaySearchSettingView(doneButtonTitle: "조회")
//            case .individualUpdate: return AttendanceBottomIndividualUpdateView(doneButtonTitle: Constant.done)
            case .membersPeriodSearchSetting: return AttendanceBottomMembersPeriodSearchSettingView(doneButtonTitle: "조회")
        }
    }
    
    var detent: CGFloat {
        switch self {
//            case .daySearchSetting: return 316
//            case .individualUpdate: return 316
            case .membersPeriodSearchSetting: return 381
        }
    }
}
