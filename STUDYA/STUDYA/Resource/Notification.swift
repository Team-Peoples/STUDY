//
//  Notification.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/04.
//

import Foundation

extension Notification.Name {
    static let categoryDidChange = Notification.Name(rawValue: "categoryDidChange")
    static let NecessaryNumFieldFilled = Notification.Name(rawValue: "NecessaryNumFieldFilled")
    static let NecessaryNumFieldEmpty = Notification.Name(rawValue: "NecessaryNumFieldEmpty")
    static let loginSuccess = Notification.Name(rawValue: "loginSuccess")
    static let decodingError = Notification.Name(rawValue: "decodingError")
    static let serverError = Notification.Name(rawValue: "serverError")
    static let unknownError = Notification.Name(rawValue: "unknowError")
    static let authStateDidChange = Notification.Name(rawValue: "authStateDidChange")
    static let tokenExpired = Notification.Name(rawValue: "tokenExpired")
    static let unauthorizedUser = Notification.Name(rawValue: "unauthorizedUser")
    static let mainCalenderDateTapped = Notification.Name(rawValue: "mainCalenderDateTapped")
    static let mainCalendarAppear = Notification.Name(rawValue: "mainCalendarAppear")
    static let myScheduleCellRemoved = Notification.Name(rawValue: "myScheduleCellRemoved")
    static let updateAnnouncement = Notification.Name("updateAnnouncement")
    static let updateStudySchedule = Notification.Name(rawValue: "updateStudySchedule")
    static let calendarShouldUpdate = Notification.Name(rawValue: "calendarShouldUpdate")
    static let reloadScheduleTableView = Notification.Name(rawValue: "reloadScheduleTableView")
    static let bottomSheetSizeChanged = Notification.Name(rawValue: "bottomSheetSizeChanged")
    static let studyInfoShouldUpdate = Notification.Name(rawValue: "studyInfoShouldUpdate")
    static let reloadStudyList = Notification.Name(rawValue: "reloadStudyList")
    static let reloadCurrentStudy = Notification.Name(rawValue: "reloadCurrentStudy")
}
