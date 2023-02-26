//
//  MySchedule.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/23.
//

import Foundation

struct MySchedule: Codable {
    let id: Int?
    let content: String?
    let date: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "scheduleId"
        case content = "scheduleName"
        case date = "scheduleDate"
    }
}
