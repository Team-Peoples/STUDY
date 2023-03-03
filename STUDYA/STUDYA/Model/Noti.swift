//
//  Notification.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/03/03.
//

import Foundation

struct Noti: Codable {
    let contents: String
    let studyName: String?
    let createdDate: Date
    
    enum CodingKeys: String, CodingKey {
        case contents, studyName
        case createdDate = "createdAt"
    }
}
