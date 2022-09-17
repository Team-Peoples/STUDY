////
////  Model.swift
////  STUDYA
////
////  Created by 서동운 on 2022/09/08.
////
//
//import Foundation
//
//// MARK: - Model
//
//protocol Object: Encodable {
//    
//}
//
//struct Study: Object  {
//    
//}
//
//struct Schedule: Object {
//    
//}
//
//struct UserProfile: Codable {
//    let nickname: String
//    let img: Data
//}
//
//struct User: Codable {
//    let userId: String?
//    let password: String?
//    let password_check: String?
//    let nickname: String?
//}
//
//struct Credential: Encodable {
//    let userId: String
//    let password: String?
//}
//
//struct GeneralStudyRule {
//    let attendanceRule: AttendanceRule?
//    let excommunicationRule: ExcommunicationRule?
//}
//
//struct FreeStudyRule {
//    let content: String?
//}
//
//struct ExcommunicationRule {
//    var lateNumber: String?
//    var absenceNumber: String?
//}
//
//struct AttendanceRule {
//    var lateRuleTime: String?
//    var absenceRuleTime: String?
//    var perLateMinute: String?
//    var latePenalty: String?
//    var absentPenalty: String?
//    var deposit: String?
//}
