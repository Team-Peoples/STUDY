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
    var baseUrl: String { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

let accessToken = "accessToken"
let refreshToken = "refreshToken"
let tokenHeaders: HTTPHeaders = [
    "AccessToken": "Bearer \(accessToken)",
    "RefreshToken": "Bearer \(refreshToken)"
]

enum HeaderContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

enum RequestPurpose: Requestable {

    //    HTTPMethod: POST
    case signUp   ////1
    case emailCheck(UserID) ////2
    case signIn(UserID, Password) ////4
    case refreshToken ////9
    case createStudy(Study) //11
    case createAnnouncement(Title, Content, ID) //15
    case createSchedule(Schedule) //21
    
    //    HTTPMethod: PUT
    case updateUser   //6
    case updateAnnouncement(Title, Content, ID) //16
    case updatePinnedAnnouncement(ID, Bool)   //17
    case updateScheduleStatus(ID)  //22
    case updateSchedule(ID)    //23
    
    
    //    HTTPMethod: DELETE
    case deleteUser(UserID) ////10
    case deleteAnnouncement(Title, Content, ID)  //18
    
    //    HTTPMethod: GET
    case getNewPassord(UserID)  //3
    case getMyInfo    //5
    case getJWTToken(SNSToken, SNS)   //7
    case resendEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllAnnouncements(ID)   //14
    case getAllSchedule ////19
    case getUserSchedule    ////20
    case getStudyLog    //24
}

extension RequestPurpose {
    var baseUrl: String {
        return "http://13.209.99.229:8082/api/v1"
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
            return  "/user/schedule"
             
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

        //    HTTPMethod: DEL
        case .deleteUser(let id):
            return "/user/\(id)"
        case .deleteAnnouncement(_,_,let id):
            return "/noti/\(id)"
            
        //    HTTPMethod: GET
        case .getNewPassord:
            return "/user/password"
        case .getMyInfo:
            return "/user"
        case .getJWTToken(_, let sns):
            return "/login/oauth2/\(sns.rawValue)"
        case .resendEmail:
            return "/user/email/auth"
        case .getAllStudy:
            return "/study"
        case .getStudy(let id):
            return "/study/\(id)"
        case .getAllAnnouncements(let id):
            return "/noti/\(id)"
        case .getAllSchedule:
            return "/study/schedule"
        case .getUserSchedule:
            return "/user/schedule"
        case .getStudyLog:
            return "/user/history"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailCheck, .signIn, .refreshToken, .createStudy, .createAnnouncement, . createSchedule: return .post
            
        case .updateUser, .updateAnnouncement, .updatePinnedAnnouncement, .updateScheduleStatus, .updateSchedule: return .put
            
        case .deleteUser, .deleteAnnouncement: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendEmail, .getAllStudy, .getStudy, .getAllAnnouncements, .getAllSchedule, .getUserSchedule, .getStudyLog : return .get
        }
    }
    
    var parameters: RequestParameters {
        switch self {
            
//    HTTPMethod: POST
        case .emailCheck(let id):
            return .body(["userId": id])
        case .signIn(let id, let pw):
            return .body(["userId" : id,
                          "password" : pw])
        case .createStudy(let study):
            return .encodableBody(study)
        case .createAnnouncement(let title, let content, let id):
            return .body(["notificationSubject" : title,
                          "notificationContents" : content,
                          "studyId" : id])
            
//    HTTPMethod: PUT
        case .updateAnnouncement(let title, let content, let id):
            return .body(["notificationSubject": title,
                          "notificationContents": content,
                          "notificationId": id])
        case .updatePinnedAnnouncement(let id, let isPinned):
            return .body(["notificationId": id,
                          "pin": isPinned])
        case .updateSchedule(let id):
            return .body(["scheduleId" : id])
            
//    HTTPMethod: DEL
        case .deleteAnnouncement(let title, let content, let id):
            return .body(["notificationSubject" : title,
                          "notificationContents" : content,
                          "notificationId" : id])
            
//            HTTPMethod: GET
        case .getNewPassord(let id):
            return .queryString(["userId" : id])
        default:
            return .none
        }
    }
    
//            기본 헤더라고 해야하나 나머지 것들도 다 넣어줘야하나
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path).absoluteString.removingPercentEncoding!, method: method)  //🤔.absoluteString.removingPercentEncoding! 이부분 없어도 될지 확인해보자 나중에
    
        switch self {
        case .signUp:
            urlRequest.headers.add(HTTPHeader.contentType(HeaderContentType.multipart.rawValue))
            
        case .refreshToken, .updateScheduleStatus, .deleteUser :
            urlRequest.headers = tokenHeaders
            
        case .emailCheck, .signIn: break
            
        case .updateUser:
            urlRequest.headers = tokenHeaders
            urlRequest.headers.add(HTTPHeader.contentType(HeaderContentType.multipart.rawValue))
            
        default:
            urlRequest.headers = tokenHeaders
        }
        
        switch parameters {
        case .queryString(let query):
            
            return try URLEncoding.default.encode(urlRequest, with: query)
            
        case .body(let params):
            
            let data = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            guard let json = json else { return urlRequest }
            
            urlRequest.httpBody = json.data(using: String.Encoding.utf8.rawValue)
            
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
        completion(.success(urlRequest))
        let accessToken = ""
        let refreshToken = ""
        var request = urlRequest
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "AccessToken")
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "RefreshToken")
        
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

// MARK: - Model
///네트워크에서 쓰이는 모델
///


struct User: Codable {
    var id: String
    let oldPassword: String?
    let password: String?
    let passwordCheck: String?
    let nickName: String?
    let image: String?
    let isEmailAuthorized, isBlocked, isPaused, isFirstLogin: Bool
//    let userStats:

    enum CodingKeys: String, CodingKey {

        case password
        case id = "userId"
        case oldPassword = "old_password"
        case passwordCheck = "password_check"
        case nickName = "nickname"
        case image = "img"
//        case userStats = "userStats"
        case isFirstLogin = "firstLogin"
        case isEmailAuthorized = "emailAuthentication"
        case isBlocked = "userBlock"
        case isPaused = "userPause"
    }
}
