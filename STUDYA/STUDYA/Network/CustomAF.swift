//
//  CustomAF.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/15.
//

import Foundation
import Alamofire
import UIKit

protocol Requestable: URLRequestConvertible {
    var baseURL: String { get }
    var header: RequestHeaders { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

enum Header: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case accessToken = "AccessToken"
    case refreshToken = "RefreshToken"
    
    case json = "application/json"
    case multipart = "multipart/form-data"
    
    var type: String {
        return self.rawValue
    }
}

enum RequestHeaders {
    case json
    case multipart
    case none
}

enum RequestPurpose: Requestable {

    //    HTTPMethod: POST
    case signUp   ////1
    case emailCheck(UserID) ////2
    case signIn ////4
    case checkOldPassword(UserID, Password)
    case refreshToken ////9
    case createStudy(Study) //11
    case createAnnouncement(Title, Content, ID) //15
    case createSchedule(MySchedule) //21
    case createStudySchedule(StudySchedulePosting)
    case joinStudy(ID)
    case attend(ID, Int)
    case createMySchedule(String, DashedDate)
    
    //    HTTPMethod: PUT
    case updateUser(User)//6
    case updateStudy(ID, Study)
    case updateAnnouncement(Title, Content, ID) //16
    case updatePinnedAnnouncement(ID, Bool)   //17
    case updateScheduleStatus(ID)  //22
    case updateSchedule(ID)    //23
    case updateStudySchedule(StudySchedulePosting)
    case closeStudy(ID)
    case toggleManagerAuth(ID)
    case updateUserRole(ID, String)
    case update(SingleUserAnAttendanceInformation)
    case toggleMyScheduleStatus(ID)
    case updateMySchedule(ID, String)
    case turnOverStudyOwnerTo(ID)
    
    //    HTTPMethod: DELETE
    case deleteUser(UserID) ////10
    case deleteAnnouncement(ID)  //18
    case deleteStudySchedule(ID, Bool)
    case deleteMember(ID)
    case leaveFromStudy(ID)
    
    //    HTTPMethod: GET
    case getNewPassord(UserID)  //3
    case getMyInfo    //5
    case getJWTToken(SNSToken, SNS)   //7
    case resendAuthEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllAnnouncements(ID)   //14
    case getAllStudyScheduleOfAllStudy ////19
    case getStudyLog    //24
    case checkEmailCertificated
    case getAllStudyMembers(ID)
    case getAttendanceCertificactionCode(ID)
    case getUserAttendanceBetween(DashedDate, DashedDate, ID, UserID)
    case getAllMembersAttendanceOn(DashedDate, ID)
    case getAllMySchedules
    case getImminentScheduleAttendnace(ID)
    case getAllNotifications
    case getAttendanceStats(ID)
}

extension RequestPurpose {
    var baseURL: String {
        return "https://www.peoplesofficial.com/api/v1"
    }
    
    var header: RequestHeaders {
        
        switch self {
        case .signUp, .updateUser, .signIn:
            return .multipart
        default:
            return .json
        }
    }
    
    var path: String {
        switch self {
            
//    HTTPMethod: POST
        case .signUp:
            return "/signup"
        case .emailCheck:
            return "/signup/verification"
        case .signIn:
            return "/signin"
        case .checkOldPassword:
            return "/user/password/confirm"
        case .refreshToken:
            return "/issued"
        case .createStudy:
            return "/study"
        case .createAnnouncement:
            return "/noti"
        case .createSchedule:
            return "/user/schedule"
        case .createStudySchedule:
            return "/study/schedule"
        case .joinStudy(let id):
            return "/study/join/\(id)"
        case .attend:
            return "/attendance"
        case .createMySchedule:
            return "/user/schedule"
        case .getImminentScheduleAttendnace(let id):
            return "/study/schedule/\(id)"
            
            //    HTTPMethod: PUT
        case .updateUser:
            return "/user"
        case .updateStudy(let studyID, _):
            return "/study/\(studyID)"
        case .updateUserRole:
            return "/studyMember/memberRole"
            
            
        case .updateAnnouncement:
            return "/noti"
        case .updatePinnedAnnouncement:
            return "/noti/pin"
        case .updateScheduleStatus(let id):
            return "/user/schedule/\(id)"
        case .updateSchedule:
            return "/user/schedule"
        case  .updateStudySchedule:
            return "/study/schedule" //domb: gitbook에서 studyschedule id를 바디로 줄게 아니라 path에 넣어주어야하는건 아닌지.
        case .closeStudy(let studyID):
            return "/study/end/\(studyID)"
        case .toggleManagerAuth:
            return "/studyMember/manager"
        case .update:
            return "/attendance/master"
        case .toggleMyScheduleStatus(let scheduleID):
            return "/user/schedule/\(scheduleID)"
        case .updateMySchedule:
            return "/user/schedule"
        case .turnOverStudyOwnerTo:
            return "/studyMember/master"
            
            //    HTTPMethod: DEL
        case .deleteUser(let id):
            return "/user/\(id)"
        case .deleteAnnouncement(let id):
            return "/noti/\(id)"
        case .deleteStudySchedule:
            return "/study/schedule"
        case .deleteMember(let id):
            return "/studyMember/\(id)"
        case .leaveFromStudy(let id):
            return "/studyMember/leave/\(id)"
            
            //    HTTPMethod: GET
        case .getNewPassord:
            return "/user/password"
        case .getMyInfo:
            return "/user"
        case .getJWTToken(_, let sns):
            return "/login/oauth2/\(sns.rawValue)"
        case .resendAuthEmail:
            return "/user/email/auth"
        case .getAllStudy:
            return "/study"
        case .getStudy(let id):
            return "/study/\(id)"
        case .getAllAnnouncements(let id):
            return "/noti/\(id)"
        case .getAllStudyScheduleOfAllStudy:
            return "/study/schedule"
        case .getStudyLog:
            return "/user/history"
        case .checkEmailCertificated:
            return "/signup/email/auth"
        case .getAllStudyMembers(let studyID):
            return "/studyMember/\(studyID)"
        case .getAttendanceCertificactionCode(let scheduleID):
            return "/attendance/checkNumber/\(scheduleID)"
        case .getUserAttendanceBetween(_,_,_, let userID):
            return "/attendance/\(userID)"
        case .getAllMembersAttendanceOn(_, let studyID):
            return "/attendance/master/\(studyID)"
        case .getAllMySchedules:
            return "/user/schedule"
        case .getAllNotifications:
            return "/alarm"
        case .getAttendanceStats:
            return "/attendance/statistics"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailCheck, .signIn, .checkOldPassword, .refreshToken, .createStudy, .joinStudy, .createAnnouncement, .createSchedule, .createStudySchedule, .attend, .createMySchedule: return .post
            
        case .updateUser, .updateStudy, .updateAnnouncement, .updatePinnedAnnouncement, .updateScheduleStatus, .updateSchedule, .updateStudySchedule, .closeStudy, .toggleManagerAuth, .updateUserRole, .update, .toggleMyScheduleStatus, .updateMySchedule, .turnOverStudyOwnerTo: return .put
            
        case .deleteUser, .deleteAnnouncement, .deleteStudySchedule, .deleteMember, .leaveFromStudy: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendAuthEmail, .getAllStudy, .getStudy, .getAllAnnouncements, .getStudyLog, .checkEmailCertificated, .getAllStudyMembers, .getAttendanceCertificactionCode, .getUserAttendanceBetween, .getAllMembersAttendanceOn, .getAllMySchedules, .getImminentScheduleAttendnace, .getAllStudyScheduleOfAllStudy, .getAllNotifications, .getAttendanceStats : return .get
        }
    }
    
    var parameters: RequestParameters {
        switch self {
            
// Body
            
///    HTTPMethod: POST
        case .emailCheck(let userID):
            return .body(["userId": userID])
        case  .checkOldPassword(let userID, let password):
            return .body(["userId": userID,
                          "password": password])
        case .createAnnouncement(let title, let content, let id):
            return .body(["notificationSubject" : title,
                          "notificationContents" : content,
                          "studyId" : id])
        case .attend(let scheduleID, let checkCode):
            return .body(["studyScheduleId" : scheduleID,
                          "checkNumber" : checkCode])
        case .createMySchedule(let content, let date):
            return .body(["scheduleName": content,
                          "scheduleDate": date])
            
///    HTTPMethod: PUT
        case .updateAnnouncement(let title, let content, let id):
            return .body(["notificationSubject": title,
                          "notificationContents": content,
                          "notificationId": id])
        case .updatePinnedAnnouncement(let id, let isPinned):
            return .body(["notificationId": id,
                          "pin": isPinned])
        case .updateSchedule(let id):
            return .body(["scheduleId": id])
        case .toggleManagerAuth(let id):
            return .body(["studyMemberId": id])
        case .updateUserRole(let memberID, let role):
            return .body(["studyMemberId": memberID,
                          "userRole": role])
        case .updateMySchedule(let scheduleID, let content):
            return .body(["scheduleId": scheduleID,
                          "scheduleName": content])
        case .turnOverStudyOwnerTo(let memberID):
            return .body(["studyMemberId": memberID])
            
///    HTTPMethod: DELETE
        case .deleteStudySchedule(let studyScheduleID, let deleteRepeatSchedule):
            return .body(["studyScheduleId": studyScheduleID,
                          "repeatDelete": deleteRepeatSchedule])
            
///    HTTPMethod: GET
// EndodableBody
        case .updateUser(let user):
            return .encodableBody(user)
        case .createStudy(let study):
            return .encodableBody(study)
        case .updateStudy(_, let study):
            return .encodableBody(study)
        case .createStudySchedule(let studySchedule):
            return .encodableBody(studySchedule)
        case .updateStudySchedule(let studySchedule):
            return .encodableBody(studySchedule)
        case .update(let attendanceInformation):
            return .encodableBody(attendanceInformation)
            
// Query
        case .getUserAttendanceBetween(let beginningDate, let endDate, let studyID, _):
            return .query(["studyId": studyID,
                          "searchDateStart": beginningDate,
                          "searchDateEnd": endDate])
        case .getNewPassord(let id):
            return .query(["userId": id])
        case .getJWTToken(let SNSToken, _):
            return .query(["token": SNSToken])
        case .getAttendanceStats(let studyID):
            return .query(["studyId": studyID])
        case .getAllMembersAttendanceOn(let date, _):
            return .query(["searchDate": date])
// None
        default:
            return .none
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path).absoluteString.removingPercentEncoding!, method: method)  //🤔.absoluteString.removingPercentEncoding! 이부분 없어도 될지 확인해보자 나중에

        var headers = HTTPHeaders()
        
        switch header {
        case .json:
            headers = [Header.contentType.type : Header.json.type]
        case .multipart:
            headers = [Header.contentType.type : Header.multipart.type]
        default: break
        }
        
        urlRequest.headers = headers
        
        switch parameters {
        case .query(let query):
            
            return try URLEncoding.default.encode(urlRequest, with: query)
            
        case .body(let params):
            
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            
            return urlRequest
            
        case .encodableBody(let parameter):
            
            let jsonParameter = parameter.toJSONData()
            
            urlRequest.httpBody = jsonParameter
            
            return urlRequest
            
        case .none:
            return urlRequest
        }
    }
}

enum RequestParameters {
    case query([String : Any])
    case body([String : Codable])
    case encodableBody(_ parameter: Encodable)
    case none
}

struct TokenRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        let accessToken = KeyChain.read(key: Constant.accessToken) ?? ""
        let refreshToken = KeyChain.read(key: Constant.refreshToken) ?? ""
        
        var request = urlRequest
        
        request.headers.add(.bearerAccessToken(accessToken))
        request.headers.add(.bearerRefreshToken(refreshToken))
        
        completion(.success(request))
    }
}

// MARK: - Helpers

extension Encodable {
    func toJSONData() -> Data? {
        let jsonData = try? JSONEncoder().encode(self)
        return jsonData
    }
}

extension Data {
    func toDictionary() -> [String: Any] {
        guard let dictionaryData = try? JSONSerialization.jsonObject(with: self) as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
