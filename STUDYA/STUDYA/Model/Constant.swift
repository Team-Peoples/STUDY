//
//  Constant.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import UIKit

enum Constant {
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let userId = "userId"
    static let studyID = "studyID"
    static let isEmailCertificated = "isEmailCertificated"
    static let nickName = "nickName"
    static let profileImageURL = "profileImageURL"
    static let accessToken = "accesstoken"
    static let refreshToken = "refreshtoken"
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
    static let attendance = "ATTENDANCE"
    static let late = "LATENESS"
    static let absent = "ABSENT"
    static let allowed = "HOLD"
    static let delete = "삭제"
    static let edit = "수정"
}
