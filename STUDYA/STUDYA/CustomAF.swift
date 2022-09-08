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

enum RequestPurpose: Requestable {
    case signIn(Credential)
    case signUp
    case emailCheck(Id)
    case create(Object)
    case issued
    
    case nicknameChange(String) // nickname
    case profileImageChange(Id)
    case scheduleStatusChange(String) // study Id
    
    case delete(Id)
    
    case getStudy(Id)
    case getAllSchedule
    case getUserSchedule
    case getStudyLog
}

extension RequestPurpose {
    var baseUrl: String {
        return "http://13.209.99.229:8082/api/v1"
    }
    
    var path: String {
        switch self {
            case .signUp:
                return "/signup"
            case .emailCheck:
                return "/signup/verification"
            case .signIn:
                return "/signin"
            case .create(let object):
                if type(of: object) == Study.self {
                    return "/study"
                } else {
                    return  "/user/schedule"
                }
            case .issued:
                return "/issued"
                
            case .nicknameChange:
                return "/nickname"
            case .profileImageChange:
                return "/user/profile/img"
            case .scheduleStatusChange(let studyId):
                return "/user/schedule/\(studyId)"
            
            case .delete(let id):
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .signIn, .signUp, .emailCheck,.create, .issued: return .post
                
            case .nicknameChange, .profileImageChange, .scheduleStatusChange: return .put
                
            case .delete(_): return .delete
                
            case .getStudy(_), .getStudyLog, .getAllSchedule, .getUserSchedule: return .get
        }
    }
    
    var parameters: RequestParameters {
        switch self {
            case .signIn(let credential):
                return .body(credential)
            case .signUp:
                return .none
            case .emailCheck(let email):
                return .body(["userId": email])
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
                
            case .delete:
                return .none
            default:
                return .none
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
            case .profileImageChange(_):
                urlRequest.headers.add(HTTPHeader.contentType("multipartFormData"))
            case .signUp:
                return urlRequest
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

typealias Id = String? //스터디 아이디 또는 사용자의 아이디

