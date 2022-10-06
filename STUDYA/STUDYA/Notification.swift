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
}
