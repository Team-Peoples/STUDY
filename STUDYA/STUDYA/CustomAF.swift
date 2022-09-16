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
    case createNotice(Title, Content, ID) //15
    case createSchedule(Schedule) //21
    
    //    HTTPMethod: PUT
    case updateUser   //6
    case updateNotice(Title, Content, ID) //16
    case updatePinnedNotice(ID, Bool)   //17
    case updateScheduleStatus(ID)  //22
    case updateSchedule(ID)    //23
    
    
    //    HTTPMethod: DELETE
    case deleteUser(UserID) ////10
    case deleteStudyNotice(Title, Content, ID)  //18
    
    //    HTTPMethod: GET
    case getNewPassord(UserID)  //3
    case getMyInfo    //5
    case getJWTToken(SNSToken, SNS)   //7
    case resendEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllStudyNotices(ID)   //14
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
        case .createNotice:
            return "/noti"
        case .createSchedule:
            return  "/user/schedule"
             
        //    HTTPMethod: PUT
        case .updateUser:
            return "/user"
        case .updateNotice:
            return "/noti"
        case .updatePinnedNotice:
            return "/noti/pin"
        case .updateScheduleStatus(let id):
            return "/user/schedule/\(id)"
        case .updateSchedule:
            return "/user/schedule"

        //    HTTPMethod: DEL
        case .deleteUser(let id):
            return "/user/\(id)"
        case .deleteStudyNotice(_,_,let id):
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
        case .getAllStudyNotices(let id):
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
        case .signUp, .emailCheck, .signIn, .refreshToken, .createStudy, .createNotice, . createSchedule: return .post
            
        case .updateUser, .updateNotice, .updatePinnedNotice, .updateScheduleStatus, .updateSchedule: return .put
            
        case .deleteUser, .deleteStudyNotice: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendEmail, .getAllStudy, .getStudy, .getAllStudyNotices, .getAllSchedule, .getUserSchedule, .getStudyLog : return .get
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
        case .createNotice(let title, let content, let id):
            return .body(["notificationSubject" : title,
                          "notificationContents" : content,
                          "studyId" : id])
            
//    HTTPMethod: PUT
        case .updateNotice(let title, let content, let id):
            return .body(["notificationSubject": title,
                          "notificationContents": content,
                          "notificationId": id])
        case .updatePinnedNotice(let id, let isPinned):
            return .body(["notificationId": id,
                          "pin": isPinned])
        case .updateSchedule(let id):
            return .body(["scheduleId" : id])
            
//    HTTPMethod: DEL
        case .deleteStudyNotice(let title, let content, let id):
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



struct Credential: Encodable {
    let userId: String
    let password: String?
}

enum SNS: String {
    case kakao = "kakao"
    case naver = "naver"
}

struct SNSInfo {
    let token: String
    let provider: String
}

struct Study: Codable {
    let id: Int?
    let title, onoff, category, studyDescription, flow, po: String?
    let isBlocked, isPaused: Bool?
    let rule: StudyRule?
    let startDate: Date?
    let endDate: Date?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "studyId"
        case title = "studyName"
        case category = "studyCategory"
        case studyDescription = "studyInfo"
        case flow = "studyFlow"
        case isBlocked = "studyBlock"
        case isPaused = "studyPause"
        case rule = "studyRule"
        case startDate = "start"
        case endDate = "end"
        case onoff, po
    }
}

struct StudyRule: Codable {
    let lateness: Lateness?
    let absence: Absence?
    let deposit: Int?
    let excommunication: Excommunication?
    
    enum CodingKeys: String, CodingKey {
        case lateness, deposit
        case absence = "absent"
        case excommunication = "out"
    }
}

struct Announcement: Codable {
    let id: Int?
    let studyID: Int?
    let title: String?
    let content: String?
    let createdDate: Date?
    var isPinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case studyID = "studyId"
        case title = "notificationSubject"
        case content = "notificationContents"
        case createdDate = "createdAt"
        case isPinned = "pin"
    }
}

struct Schedule: Codable {
    
    let id: Int?
    let name: String?
    let date: Date?
    let status: String? //상태가 머머 있는거지?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "scheduleId"
        case name = "scheduleName"
        case date = "scheduleDate"
    }
}

struct Absence: Codable {
    let time, fine: Int?
}

struct Lateness: Codable {
    let time, count, fine: Int?
}

struct Excommunication: Codable {
    let lateness, absent: Int?
}

typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 이외에 id가 있는 것들의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
