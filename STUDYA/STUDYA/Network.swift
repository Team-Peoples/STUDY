//
//  Network.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/14.
//

import UIKit
import Alamofire

enum PeoplesError: Error {
    case duplicatedEmail
    case alreadySNSSignUp
    case notAuthEmail
    case wrongPassword
    case loginInformationSavingError
    case unauthorizedUser
    case expiredToken
}

enum ErrorCode {
    static let duplicatedEmail = "DUPLICATE_EMAIL"
    static let wrongPassword = "PASSWORD_MISMATCH"
}

struct Network {
    
    static let shared = Network()
    
    private init() {
        self.init()
    }

    private func sendDecodingErrorNotification() {
        NotificationCenter.default.post(Notification.Name.decodingError)
    }
    
    private func sendServerErrorNotification() {
        NotificationCenter.default.post(Notification.Name.serverError)
    }
    
    private func sendUnknownErrorNotification(statusCode: Int?) {
        guard let statusCode = statusCode else { return }
        NotificationCenter.default.post(name: Notification.Name.unknownError, object: nil, userInfo: [htttpStatusCode: statusCode])
    }

    private func saveLoginformation(urlResponse: HTTPURLResponse, user: User, completion: (Result<User, PeoplesError>) -> Void) {
        if let accesToken = urlResponse.allHeaderFields[Const.accessToken] as? String,
           let refreshToken = urlResponse.allHeaderFields[Const.refreshToken] as? String {
            KeyChain.create(key: Const.accessToken, value: accesToken)
            KeyChain.create(key: Const.refreshToken, value: refreshToken)
            KeyChain.create(key: Const.userId, value: user.id)
        } else {
            completion(.failure(.loginInformationSavingError))
        }
    }
    
    func checkIfDuplicatedEmail(email: String, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.emailCheck(email)).validate().responseData { response in
            switch response.result {
            case .success(let data):
                
                guard let decodedData = jsonDecode(type: Bool.self, data: data) else {
                    sendDecodingErrorNotification()
                    return
                }
                completion(.success(decodedData))
                
            case .failure:
                sendUnknownErrorNotification(statusCode: response.response?.statusCode)
            }
        }
    }
    
    func SNSSignIn(token: String, sns: SNS, completion: @escaping (Result<User,PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getJWTToken(token, sns)).response { response in
            
            guard let urlResponse = response.response,
                  let data = response.data else { completion(.failure(.serverError)); return }
            let httpStatus = urlResponse.statusCode
            
            switch httpStatus {
            case 200:
                guard let user = jsonDecode(type: User.self, data: data) else { sendDecodingErrorNotification(); return }
                saveLoginformation(urlResponse: urlResponse, user: user, completion: completion)
                
                completion(.success(user))
            default:
                sendServerErrorNotification()
            }
        }
    }
    
//    회원가입시 사진 선택 안하면 이미지에 nil을 보내게할 수는 없는건가
    func signUp(userId: String, pw: String, pwCheck: String, nickname: String?, image: UIImage?, completion: @escaping (Result<User, PeoplesError>) -> Void) {
            
            let user = User(id: userId, oldPassword: nil, password: pw, passwordCheck: pwCheck, nickName: nickname, image: nil, isEmailAuthorized: nil, isBlocked: nil, isPaused: nil, isFirstLogin: nil, pushStart: nil, pushImmininet: nil, pushDayAgo: nil, userStats: nil)

            guard let jsonData = try? JSONEncoder().encode(user),
                  let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

            AF.upload(multipartFormData: { data in
                data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
                data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
            }, with: RequestPurpose.signUp).response { response in
                
                guard let urlResponse = response.response,
                      let data = response.data else { sendServerErrorNotification(); return }
                guard let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else { sendDecodingErrorNotification(); return }
                
                switch urlResponse.statusCode {
                case 200:
                    saveLoginformation(urlResponse: urlResponse, user: user, completion: completion )
                    
                    completion(.success(user))
                case 400:
                    
                    switch body.code {
                    case ErrorCode.duplicatedEmail: completion(.failure(.duplicatedEmail))
                    case ErrorCode.wrongPassword: completion(.failure(.wrongPassword))
                    default: sendUnknownErrorNotification(statusCode: 400)
                    }
                case 500:
                    sendServerErrorNotification()
                default:
                    sendUnknownErrorNotification(statusCode: urlResponse.statusCode)
                }
            }
        }
    
    func signIn(id: String, pw: String, completion: @escaping (Result<User,PeoplesError>?) -> Void) {
        AF.request(RequestPurpose.signIn(id, pw)).response { response in
            switch response.result {
            case .success(let data):
                guard let urlResponse = response.response, let data = response.result else {
                    sendServerErrorNotification()
                    return
                }
                guard let user = jsonDecode(type: User.self, data: data) else {
                    sendDecodingErrorNotification()
                    return
                }
                
                saveLoginformation(urlResponse: HTTPURLResponse, user: user, completion: completion)
                completion(.success(user))
            case .failure:
                sendServerErrorNotification()
            }
        }
    }
    
    func resendEmail(completion: @escaping (PeoplesError?) -> Void) {
        AF.request(RequestPurpose.resendEmail).response { response in
            if let _ = response.error { completion(.serverError) }
            guard let httpResponse = response.response,let _ = response.data else { completion(.serverError); return }

            switch httpResponse.statusCode {
            case (200...299):
                completion(nil)
            default: completion(.serverError)
            }
        }
    }
    
    func getNewPassword(id: UserID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {        AF.request(RequestPurpose.getNewPassord(id)).response { response in
            
            guard let httpResponse = response.response else {
                sendServerErrorNotification()
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data), let user = body.result else {
                    sendDecodingErrorNotification()
                    return
                }
                
                completion(.success(user))
            default:
                sendUnknownErrorNotification(statusCode: response.response?.statusCode)
            }
        }
    }
    
    func getUserInfo(completion: @escaping (Result<User, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getMyInfo, interceptor: TokenRequestInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                sendServerErrorNotification()
                return
            }
            
            switch httpResponse.statusCode {
                case 200:
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    sendDecodingErrorNotification()
                    return
                }
                
                completion(.success(user))
            default:
                sendUnknownErrorNotification(statusCode: response.response?.statusCode)
            }
        }
    }
    
    func updateUserInfo(oldPassword: String?, password: String?, passwordCheck: String?, nickname: String?, image: UIImage?, completion: @escaping (Result<User, PeoplesError>) -> Void) {
        
        let user = User(id: nil, oldPassword: oldPassword, password: password, passwordCheck: passwordCheck, nickName: nickname)

        guard let jsonData = try? JSONEncoder().encode(user) else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

        AF.upload(multipartFormData: { data in
            data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
        }, with: RequestPurpose.updateUser, interceptor: TokenRequestInterceptor()).response { response in
            
            switch response.response?.statusCode {
            case 200:
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    sendDecodingErrorNotification()
                    return
                }
                completion(.success(user))
            default:
                // domb: token 인증실패
                sendUnknownErrorNotification(statusCode: response.response?.statusCode)
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.refreshToken).validate().response { response in
            guard let httpResponse = response.response else {
                sendServerErrorNotification()
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data), let isSuccessed = body.result else {
                    sendDecodingErrorNotification()
                    return
                }
            
                guard isSuccessed else { return }
                
                if let accesToken = urlResponse.allHeaderFields[Const.accessToken] as? String,
                   let refreshToken = urlResponse.allHeaderFields[Const.refreshToken] as? String {
                    KeyChain.create(key: Const.accessToken, value: accesToken)
                    KeyChain.create(key: Const.refreshToken, value: refreshToken)
                } else {
                    completion(.failure(.loginInformationSavingError))
                }
                
            default:
                
                //리프레시 토큰도 만료되었을 경우 로그아웃 시킨다.
                sendServerErrorNotification()
            }
        }
    }
    
    // MARK: - Study
    
    func createStudy(_ study: Study, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createStudy(study)).validate().response { response in
            guard let httpResponse = response.response else {
                sendServerErrorNotification()
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Study>.self, data: data), let study = body.result else {
                    sendDecodingErrorNotification()
                    return
                }
                
                completion(.success(study))
            case 401:
                completion(.failure(.))
            default:
                // domb: 토큰 인증 실패
                sendUnknownErrorNotification(statusCode: httpResponse.statusCode)
            }
        }
    }
    
    func jsonDecode<T: Codable>(type: T.Type, data: Data) -> T? {
        
        let jsonDecoder = JSONDecoder()
        let result: Codable?
        
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
        
        do {
            
            result = try jsonDecoder.decode(type, from: data)
            
            return result as? T
        } catch {
            
            print(error)
            
            return nil
        }
    }
}

extension DateFormatter {
    
    static let myDateFormatter: DateFormatter  = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
}

struct ResponseResult<T: Codable>: Codable {
    let result: T?
    let status: Int?
    let error: String?
    let code: String?
    let message: String?
    let timestamp: String?
    let studyMemberList: [Study]?
    
    enum CodingKeys: String, CodingKey {
        case result, status, error, code, message, timestamp, studyMemberList
    }
}

struct ResponseResults<T: Codable>: Codable {
    let result: [T?]
    let message: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
    }
}

struct ResponseResultTypes<T: Codable, S: Codable, X: Codable>: Codable {
    let result: Dummy<T, S, X>?
    let message: String?
    let timestamp: String?
    let message: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
    }
}

struct Dummy<U: Codable, W: Codable, Z: Codable>: Codable {
    let noti: U
    let study: W
    let schedule: Z
}

