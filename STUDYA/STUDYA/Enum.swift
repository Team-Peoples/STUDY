//
//  Enum.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/06.
//

import UIKit

enum Const {
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let userId = "userId"
    static let studyID = "studyID"
    static let isEmailCertificated = "isEmailCertificated"
    static let nickName = "nickName"
    static let profileImageURL = "profileImageURL"
    static let accessToken = "AccessToken"
    static let refreshToken = "RefreshToken"
    static let tempIsFirstSNSLogin = "tempIsFirstSNSLogin"
    static let tempUserId = "tempUserId"
    static let tempPassword = "tempPassword"
    static let tempPasswordCheck = "tempPasswordCheck"
    static let tempNickname = "tempNickname"
    static let unknownErrorMessage = "알 수 없는 에러가 발생했습니다. 이용에 불편을 드려 죄송합니다. 빠르게 복구하겠습니다."
    static let serverErrorMessage = "서버에 에러가 발생했어요. 이용에 불편을 드려 죄송합니다. 빠르게 복구하겠습니다."
    static let statusCode = "statusCode"
    static let isLoggedin = "isLoggedin"
    static let OK = "확인"
    static let cancel = "취소"
    static let done = "완료"
    static let defaultProfile = "defaultProfile"
}

enum StudyExitBottomSheetTask {
    case exit
    case close
    case resignMaster
}

enum Task {
    case creating
    case editing
    case viewing
}

enum Viewer {
    case manager
    case user
}

enum AttendanceBottomViewType {
    case daySearchSetting
    case individualUpdate
    case membersPeriodSearchSetting
    case individualPeriodSearchSetting
    
    var view: FullDoneButtonButtomView {
        switch self {
            case .daySearchSetting: return AttendanceBottomDaySearchSettingView(doneButtonTitle: "조회")
            case .individualUpdate: return AttendanceBottomIndividualUpdateView(doneButtonTitle: Const.done)
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

enum PopUpCalendarType {
    case open
    case deadline
}
