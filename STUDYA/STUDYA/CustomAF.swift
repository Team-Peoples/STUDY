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
    case token
    case json
    case multipart
    case none
}

enum RequestPurpose: Requestable {

    //    HTTPMethod: POST
    case signUp   ////1
    case emailCheck(UserID) ////2
    case signIn ////4
    case refreshToken ////9
    case createStudy(MockStudy) //11
    case createAnnouncement(Title, Content, ID) //15
    case createSchedule(Schedule) //21
    case createStudySchedule(StudySchedule)
    
    //    HTTPMethod: PUT
    case updateUser(User)   //6
    case updateAnnouncement(Title, Content, ID) //16
    case updatePinnedAnnouncement(ID, Bool)   //17
    case updateScheduleStatus(ID)  //22
    case updateSchedule(ID)    //23
    case updateStudySchedule(StudySchedule)
    
    //    HTTPMethod: DELETE
    case deleteUser(UserID) ////10
    case deleteAnnouncement(Title, Content, ID)  //18
    case deleteStudySchedule(ID, Bool)
    
    //    HTTPMethod: GET
    case getNewPassord(UserID)  //3
    case getMyInfo    //5
    case getJWTToken(SNSToken, SNS)   //7
    case resendAuthEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllAnnouncements(ID)   //14
    case getAllStudySchedule ////19
    case getUserSchedule    ////20
    case getStudyLog    //24
    case checkEmailCertificated
}

extension RequestPurpose {
    var baseURL: String {
        return "http://13.209.99.229:8082/api/v1"
    }
    
    var header: RequestHeaders {
        
        switch self {
        case .getNewPassord, .getJWTToken, .deleteUser, .getMyInfo, .getAllStudy, .getStudy, .getAllAnnouncements, .getAllStudySchedule, .getUserSchedule, .updateScheduleStatus, .getStudyLog, .createStudy, .checkEmailCertificated:
            return .none
        case .signUp, .updateUser:
            return .multipart
        case .refreshToken:
            return .token
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
            
        //    HTTPMethod: PUT
        case .updateUser:
            return "/user"
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

        //    HTTPMethod: DEL
        case .deleteUser(let id):
            return "/user/\(id)"
        case .deleteAnnouncement(_,_,let id):
            return "/noti/\(id)"
        case .deleteStudySchedule:
            return "/study/schedule" //domb: gitbook에서 studyschedule id를 바디로 줄게 아니라 path에 넣어주어야하는건 아닌지.
            
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
        case .getAllStudySchedule:
            return "/study/schedule"
        case .getUserSchedule:
            return "/user/schedule"
        case .getStudyLog:
            return "/user/history"
        case .checkEmailCertificated:
            return "/signup/email/auth"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailCheck, .signIn, .refreshToken, .createStudy, .createAnnouncement, .createSchedule, .createStudySchedule: return .post
            
        case .updateUser, .updateAnnouncement, .updatePinnedAnnouncement, .updateScheduleStatus, .updateSchedule, .updateStudySchedule: return .put
            
        case .deleteUser, .deleteAnnouncement, .deleteStudySchedule: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendAuthEmail, .getAllStudy, .getStudy, .getAllAnnouncements, .getAllStudySchedule, .getUserSchedule, .getStudyLog, .checkEmailCertificated : return .get
        }
    }
    
    var parameters: RequestParameters {
        switch self {
// Body
            
///    HTTPMethod: POST
        case .emailCheck(let id):
            return .body(["userId": id])
        case .createAnnouncement(let title, let content, let id):
            return .body(["notificationSubject" : title,
                          "notificationContents" : content,
                          "studyId" : id])
            
///    HTTPMethod: PUT
        case .updateAnnouncement(let title, let content, let id):
            return .body(["notificationSubject": title,
                          "notificationContents": content,
                          "notificationId": id])
        case .updatePinnedAnnouncement(let id, let isPinned):
            return .body(["notificationId": id,
                          "pin": isPinned])
        case .updateSchedule(let id):
            return .body(["scheduleId" : id])
            
///    HTTPMethod: DELETE
        case .deleteAnnouncement(let title, let content, let id):
            return .body(["notificationSubject": title,
                          "notificationContents": content,
                          "notificationId": id])
        case .deleteStudySchedule(let studyScheduleID, let deleteRepeatSchedule):
            return .body(["studyScheduleId": studyScheduleID,
                          "repeatDelete": deleteRepeatSchedule])
            
// EndodableBody
        case .updateUser(let user):
            return .encodableBody(user)
        case .createStudy(let study):
            return .encodableBody(study)
        case .createStudySchedule(let studySchedule):
            return .encodableBody(studySchedule)
        case .updateStudySchedule(let studySchedule):
            return .encodableBody(studySchedule)
            
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
    
// EHD: 기본 헤더라고 해야하나 나머지 것들도 다 넣어줘야하나
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path).absoluteString.removingPercentEncoding!, method: method)  //🤔.absoluteString.removingPercentEncoding! 이부분 없어도 될지 확인해보자 나중에

        var headers = HTTPHeaders()
        
        switch header {
        case .json:
            headers = [Header.contentType.type : Header.json.type]
        case .multipart:
            headers = [Header.contentType.type : Header.multipart.type]
//        case .token:
//            headers = [Header.accessToken.type : accessToken, Header.refreshToken.type : refreshToken]
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
        
        let accessToken = KeyChain.read(key: Const.accessToken) ?? ""
        let refreshToken = KeyChain.read(key: Const.refreshToken) ?? ""
        
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
