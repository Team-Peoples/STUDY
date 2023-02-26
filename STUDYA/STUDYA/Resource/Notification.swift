//
//  Notification.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/04.
//

import Foundation

extension Notification.Name {
    static let categoryDidChange = Notification.Name(rawValue: "categoryDidChange")
    static let authStateDidChange = Notification.Name(rawValue: "authStateDidChange")
    static let attendanceManagerTableViewsReloaded = Notification.Name(rawValue: "attendanceManagerTableViewsReloaded")
    static let tokenExpired = Notification.Name(rawValue: "tokenExpired")
    static let unauthorizedUser = Notification.Name(rawValue: "unauthorizedUser")
    static let mainCalenderDateTapped = Notification.Name(rawValue: "mainCalenderDateTapped")
    static let myScheduleCellRemoved = Notification.Name(rawValue: "myScheduleCellRemoved")
}
