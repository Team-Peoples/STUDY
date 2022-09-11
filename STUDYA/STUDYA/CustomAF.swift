//
//  CustomAF.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/15.
//

import Foundation
import Alamofire

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
//    case signUp(User)   ////1
    case emailCheck(ID) ////2
    case signIn(Credential) ////4
    case issued ////9
    case create(Object) ////11
//    case postNotice(Notice)   //15
//    case postNewSchedule(Schedule)  //21
    
    //    HTTPMethod: PUT
//    case updateUser(User)   //6
//    case updateStudyNotice(Notice) //16
    case updatePinned(Notice)   //17
    case update(Object)
    case updateScheduleStatus(Int)  //22
    case updateSchedule(Int)    //23
    
    
    //    HTTPMethod: DELETE
    case deleteUser(ID) ////10
    case deleteStudyNotice(Notice)  //18
    
    //    HTTPMethod: GET
    case getNewPassord(ID)  //3
    case getUserInfo    //5
    case getSNSToken(SNSInfo)   //7
    case resendEmail(ID)    //8
    case getAllStudy    //12
    case getStudy(StudyID)  //13
    case getAllStudyNotices(StudyID)   //14
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
        case .emailCheck:
            return "/signup/verification"
        case .signIn:
            return "/signin"
        case .issued:
            return "/issued"
        case .create(let object):
            if type(of: object) == Study.self {
                return "/study"
            } else if type(of: object) == Schedule.self {
                return  "/user/schedule"
            } else if type(of: object) == Notice.self {
                return "/noti"
            } else {
                return "/signup"
            }
             
        //    HTTPMethod: PUT
        case .update(let object):
            if type(of: object) == User.self {
                return "/user"
            } else {
                return "/noti"
            }
        case .updatePinned(_):
            return "/noti/pin"
        case .updateScheduleStatus(let id):
            return "/user/schedule/\(id)"
        case .updateSchedule(_):
            return "/user/schedule"

        case .deleteUser(let id):
            guard let id = id else { return "/user/"}
            return "/user/\(id)"
            
        case .getStudy(let id):
            guard let id = id else { return "/study"}
            return "/study/\(id)"
        case .getStudyLog:
            return "/user/history"
        case .getAllSchedule:
            return "/study/schedule"
        case .getUserSchedule:
            return "/user/schedule"
        case .getNewPassord:
            return "/user/password"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .emailCheck,.create, .issued: return .post
            
        case .nicknameChange, .profileImageChange, .scheduleStatusChange: return .put
            
        case .deleteUser(_): return .delete
            
        case .getStudy(_), .getStudyLog, .getAllSchedule, .getUserSchedule, .getNewPassord: return .get
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .signIn(let credential):
            return .body(credential)
        case .emailCheck(let id):
            return .body(["userId": id])
        case .create(let object):
            return .body(object)
        case .issued:
            return .none
            
        case .nicknameChange(let nickName):
            return .body(["nickname": nickName])
        case .profileImageChange(let email):
            return .body(["userId": email])
        case .scheduleStatusChange:
            return .none
            
        case .deleteUser:
            return .none
        default:
            return .none
        }
    }
    

    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
//        case .profileImageChange(_):
//            urlRequest.headers.add(HTTPHeader.contentType("multipartFormData"))
        case .issued:
//            기본 헤더라고 해야하나 나머지 것들도 다 넣어줘야하나
            urlRequest.headers = tokenHeaders
        case .create(let object):
            if type(of: object) == User.self {
                
                urlRequest.headers.add(HTTPHeader.contentType(HeaderContentType.multipart.rawValue))
            } else {
                
                urlRequest.headers = tokenHeaders
                urlRequest.headers.add(HTTPHeader.contentType(HeaderContentType.json.rawValue))
            }
        default:
            urlRequest.headers.add(HTTPHeader.contentType("application/json"))
        }
        
        switch parameters {
        case .body(let parameter):
            let jsonParameter = parameter.toJSONData()
            urlRequest.httpBody = jsonParameter
            return urlRequest
        case .none:
            return urlRequest
        }
    }
}

enum RequestParameters {
    case body(_ parameter: Encodable)
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
protocol Object: Codable {
    
}

struct Schedule: Object  {
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

struct UserProfile: Codable {
    let nickname: String
    let img: Data
}

struct User: Object {
    let userId: String?
    let oldPassword: String?    //
    let password: String?
    let passwordCheck: String?
    let nickName: String?
    
    enum CodingKeys: String, CodingKey {
        case userId, password
        case oldPassword = "old_password"
        case nickName = "nickname"
        case passwordCheck = "password_check"
    }
}

struct Credential: Encodable {
    let userId: String
    let password: String?
}

struct SNSInfo {
    let token: String
    let provider: String
}

struct Notice: Object {
    let title: String?
    let content: String?
    let studyID: Int?
    let noticeID: Int?
    let date: Date?
    var isPinned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title = "notificationSubject"
        case content = "notificationContents"
        case studyID = "studyId"
        case noticeID = "notificationId"
        case date = "createdAt"
        case isPinned = "pin"
    }
}

struct Study: Object {
    let studyName, onoff, studyCategory, studyDescription: String?
    let studyID: Int?
    let studyBlock, studyPause: Bool?
    let studyRule: StudyRule?
    let studyFlow: String?
    
    enum CodingKeys: String, CodingKey {
        case studyID = "studyId"
        case studyDescription = "studyInfo"
        case studyName, onoff, studyCategory, studyBlock, studyPause, studyRule, studyFlow
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

struct Absence: Codable {
    let time, fine: Int
}

struct Lateness: Codable {
    let time, count, fine: Int
}

struct Excommunication: Codable {
    let lateness, absent: Int
}

typealias ID = String? //스터디 아이디 또는 사용자의 아이디
typealias StudyID = Int?
