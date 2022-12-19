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
    var header: RequestHeaders { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

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
    case resendAuthEmail    //8
    case getAllStudy    //12
    case getStudy(ID)  //13
    case getAllAnnouncements(ID)   //14
    case getUserAllStudySchedule ////19
    case getUserSchedule    ////20
    case getStudyLog    //24
    case checkEmailCertificated
}

extension RequestPurpose {
    var baseUrl: String {
        return "http://13.209.99.229:8082/api/v1"
    }
    
    var header: RequestHeaders {
        
        switch self {
        case .getNewPassord, .getJWTToken, .deleteUser, .getMyInfo, .getAllStudy, .getStudy, .getAllAnnouncements, .getUserAllStudySchedule, .getUserSchedule, .updateScheduleStatus, .getStudyLog, .createStudy, .checkEmailCertificated:
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
        case .resendAuthEmail:
            return "/user/email/auth"
        case .getAllStudy:
            return "/study"
        case .getStudy(let id):
            return "/study/\(id)"
        case .getAllAnnouncements(let id):
            return "/noti/\(id)"
        case .getUserAllStudySchedule:
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
        case .signUp, .emailCheck, .signIn, .refreshToken, .createStudy, .createAnnouncement, . createSchedule: return .post
            
        case .updateUser, .updateAnnouncement, .updatePinnedAnnouncement, .updateScheduleStatus, .updateSchedule: return .put
            
        case .deleteUser, .deleteAnnouncement: return .delete
            
        case .getNewPassord, .getMyInfo, .getJWTToken, .resendAuthEmail, .getAllStudy, .getStudy, .getAllAnnouncements, .getUserAllStudySchedule, .getUserSchedule, .getStudyLog, .checkEmailCertificated : return .get
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
        case .refreshToken:
            return .none
            
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
        case .getJWTToken(let SNSToken, _):
            return .queryString(["token" : SNSToken])
        default:
            return .none
        }
    }
    
//            기본 헤더라고 해야하나 나머지 것들도 다 넣어줘야하나
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path).absoluteString.removingPercentEncoding!, method: method)  //🤔.absoluteString.removingPercentEncoding! 이부분 없어도 될지 확인해보자 나중에

        var headers = HTTPHeaders()
        
        let accessToken = KeyChain.read(key: Header.accessToken.type) ?? ""
        let refreshToken = KeyChain.read(key: Header.refreshToken.type) ?? ""
        
        switch header {
        case .json:
            headers = [Header.contentType.type : Header.json.type]
        case .multipart:
            headers = [Header.contentType.type : Header.multipart.type]
        case .token:
            headers = [Header.accessToken.type : accessToken, Header.refreshToken.type : refreshToken]
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

enum RequestHeaders {
    case token
    case json
    case multipart
    case none
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
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: Const.accessToken)
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: Const.refreshToken)
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 else {
                   completion(.doNotRetryWithError(error))
                   return
               }
        
        Network.shared.refreshToken { result in
            switch result {
            case .success:
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
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
    var id: String?
    let oldPassword: String?
    let password: String?
    let passwordCheck: String?
    let nickName: String?
    let image: String?
    let isEmailAuthorized, isBlocked, isPaused, isFirstLogin, isNaverLogin, isKakaoLogin, userStats, pushStart, pushImminent, pushDayAgo: Bool?
    
    init(id: String?, oldPassword: String? = nil, password: String?, passwordCheck: String?, nickName: String?, image: String? = nil, isEmailAuthorized: Bool? = nil, isBlocked: Bool? = nil, isPaused: Bool? = nil, isFirstLogin: Bool? = nil, isNaverLogin: Bool? = nil, isKakaoLogin: Bool? = nil, userStats: Bool? = nil, pushStart: Bool? = nil, pushImminent: Bool? = nil, pushDayAgo: Bool? = nil) {
        self.id = id
        self.oldPassword = oldPassword
        self.password = password
        self.passwordCheck = passwordCheck
        self.nickName = nickName
        self.image = image
        self.isEmailAuthorized = isEmailAuthorized
        self.isBlocked = isBlocked
        self.isPaused = isPaused
        self.isFirstLogin = isFirstLogin
        self.isNaverLogin = isNaverLogin
        self.isKakaoLogin = isKakaoLogin
        self.userStats = userStats
        self.pushStart = pushStart
        self.pushImminent = pushImminent
        self.pushDayAgo = pushDayAgo
    }

    enum CodingKeys: String, CodingKey {

        case password, pushStart, pushImminent, pushDayAgo
        case id = "userId"
        case oldPassword = "old_password"
        case passwordCheck = "password_check"
        case nickName = "nickname"
        case image = "img"
        case isFirstLogin = "firstLogin"
        case isEmailAuthorized = "emailAuthentication"
        case isBlocked = "userBlock"
        case isPaused = "userPause"
        case isNaverLogin = "sns_naver"
        case isKakaoLogin = "sns_kakao"
        case userStats = "userStats"
    }
}

