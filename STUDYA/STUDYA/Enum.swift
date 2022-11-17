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
