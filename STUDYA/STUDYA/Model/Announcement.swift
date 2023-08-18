//
//  Announcement.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation


struct Announcement: Codable {
    let id: ID?
    let title: String?
    let content: String?
    let createdDate: Date
    var isPinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case title = "notificationSubject"
        case content = "notificationContents"
        case createdDate = "createdAt"
        case isPinned = "pin"
    }
    
    init(id: Int? = nil, title: String?, content: String?, createdDate: Date, isPinned: Bool? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.isPinned = isPinned
    }
}
