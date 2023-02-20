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
    case createSchedule(Schedule) //21
    case createStudySchedule(StudyScheduleGoing)
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
    case updateStudySchedule(StudyScheduleGoing)
    case closeStudy(ID)
    case toggleManagerAuth(ID)
    case updateUserRole(ID, String)
    case update(SingleUserAnAttendanceInformation)
    case toggleMyScheduleStatus(ID)
    case updateMySchedule(ID, String)
    
    //    HTTPMethod: DELETE
    case deleteUser(UserID) ////10
    case deleteAnnouncement(ID)  //18
    case deleteStudySchedule(ID, Bool)
    case deleteMember(ID)
    case leaveStudy(ID)
    
    //    HTTPMethod: GET
    case getNewPassord(UserID)  //3
    case getMyInfo    //5
    case getJWTToken(SNSToken, SNS)   //7
    case resendAuthEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllAnnouncements(ID)   //14
    case getStudyAllSchedule ////19
    case getStudyLog    //24
    case checkEmailCertificated
    case getAllStudyMembers(ID)
    case getAttendanceCertificactionCode(ID)
    case getMyAttendanceBetween(DashedDate, DashedDate, ID)
    case getAllMembersAttendanceOn(DashedDate, ID)
    case getAllMySchedules
}

extension RequestPurpose {
    var baseURL: String {
        return "http://13.209.99.229:8082/api/v1"
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
            return "/join/\(id)"
        case .attend:
            return "/attendance"
        case .createMySchedule:
            return "/user/schedule"
            
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
            
            //    HTTPMethod: DEL
        case .deleteUser(let id):
            return "/user/\(id)"
        case .deleteAnnouncement(let id):
            return "/noti/\(id)"
        case .deleteStudySchedule:
            return "/study/schedule"
        case .leaveStudy(let studyID):
            return "/studyMember/leave/\(studyID)"
        case .deleteMember(let id):
            return "/studyMember/\(id)"
            
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
        case .getStudyAllSchedule:
            return "/study/schedule"
        case .getStudyLog:
            return "/user/history"
        case .checkEmailCertificated:
            return "/signup/email/auth"
        case .getAllStudyMembers(let studyID):
            return "/studyMember/\(studyID)"
        case .getAttendanceCertificactionCode:
            return "/attendance/checkNumber"
        case .getMyAttendanceBetween:
            return "/attendance"
        case .getAllMembersAttendanceOn:
            return "/attendance/master"
        case .getAllMySchedules:
            return "/user/schedule"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailCheck, .signIn, .checkOldPassword, .refreshToken, .createStudy, .joinStudy, .createAnnouncement, .createSchedule, .createStudySchedule, .attend, .createMySchedule: return .post
            
        case .updateUser, .updateStudy, .updateAnnouncement, .updatePinnedAnnouncement, .updateScheduleStatus, .updateSchedule, .updateStudySchedule, .closeStudy, .toggleManagerAuth, .updateUserRole, .update, .toggleMyScheduleStatus, .updateMySchedule: return .put
            
        case .deleteUser, .deleteAnnouncement, .deleteStudySchedule, .deleteMember, .leaveStudy: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendAuthEmail, .getAllStudy, .getStudy, .getAllAnnouncements, .getStudyLog, .checkEmailCertificated, .getAllStudyMembers, .getAttendanceCertificactionCode, .getMyAttendanceBetween, .getAllMembersAttendanceOn, .getStudyAllSchedule, .getAllMySchedules : return .get
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
        case .getAttendanceCertificactionCode(let id):
            return .body(["studyScheduleId" : id])
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
            
///    HTTPMethod: DELETE
        case .deleteStudySchedule(let studyScheduleID, let deleteRepeatSchedule):
            return .body(["studyScheduleId": studyScheduleID,
                          "repeatDelete": deleteRepeatSchedule])
            
///    HTTPMethod: GET
        case .getMyAttendanceBetween(let beginningDate, let endDate, let studyID):
            return .body(["studyId": studyID,
                          "searchDateStart": beginningDate,
                          "searchDateEnd": endDate])
        case .getAllMembersAttendanceOn(let date, let studyID):
            return .body(["studyId": studyID,
                          "searchDate": date])
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
        case .getNewPassord(let id):
            return .queryString(["userId": id])
        case .getJWTToken(let SNSToken, _):
            return .queryString(["token": SNSToken])
            
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
        case .queryString(let query):
            
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
    case queryString([String : String])
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
