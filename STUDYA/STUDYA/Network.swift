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
    
    case unknownError(Int?)
    case serverError
    case notServerError(String)
    case badRequest(ResponseResult<Bool>)
}

enum ErrorCode {
    static let duplicatedEmail = "DUPLICATE_EMAIL"
    static let wrongPassword = "PASSWORD_MISMATCH"
}

struct Network {
    
    static let shared = Network()
    
    func saveLoginformation(urlResponse: HTTPURLResponse, user: User,completion: (Result<User, PeoplesError>) -> Void) {
        guard let accesToken = urlResponse.allHeaderFields[Const.accessToken] as? String,
              let refreshToken = urlResponse.allHeaderFields[Const.refreshToken] as? String else { completion(.failure(.serverError)); return }
        
        KeyChain.create(key: Const.accessToken, value: accesToken)
        KeyChain.create(key: Const.refreshToken, value: refreshToken)
        KeyChain.create(key: Const.userId, value: user.id)
    }
    
    func checkIfDuplicatedEmail(email: String, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.emailCheck(email)).validate().responseData { response in
            switch response.result {
            case .success(let data):
                
                guard let decodedData = jsonDecode(type: Bool.self, data: data) else { completion(.failure(.unknownError(response.response?.statusCode))); return }
                completion(.success(decodedData))
                
            case .failure:
                completion(.failure(.unknownError(response.response?.statusCode)))
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
                guard let user = jsonDecode(type: User.self, data: data) else { completion(.failure(.serverError)); return }
                saveLoginformation(urlResponse: urlResponse, user: user, completion: completion)
                
                completion(.success(user))
            default:
                completion(.failure(.serverError))
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
                      let data = response.data,
                      let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else { completion(.failure(.unknownError(400))); return }
                
                switch urlResponse.statusCode {
                case 200:
                    saveLoginformation(urlResponse: urlResponse, user: user, completion: completion )
                    
                    completion(.success(user))
                case 400:
                    
                    switch body.code {
                    case  ErrorCode.duplicatedEmail: completion(.failure(.duplicatedEmail))
                    case ErrorCode.wrongPassword: completion(.failure(.wrongPassword))
                    default: completion(.failure(.unknownError(response.response?.statusCode)))
                    }
                case 401: break //🛑🛑🛑🛑🛑🛑🛑
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknownError(response.response?.statusCode)))
                }
            }
        }
    func signIn(id: String, pw: String, completion: @escaping (Result<User,PeoplesError>?) -> Void) {
        AF.request(RequestPurpose.signIn(id, pw)).validate().responseData { response in
            switch response.result {
            case .success(let data):
                
                guard let accesToken = response.response?.allHeaderFields[Const.accessToken] as? String else { completion(.failure(.serverError)); return }
                guard let refreshToken = response.response?.allHeaderFields[Const.refreshToken] as? String else { completion(.failure(.serverError)); return }
                guard let user = jsonDecode(type: ResponseResult<User>.self, data: data)?.result else { completion(.failure(.serverError)); return }
                
                KeyChain.create(key: Const.accessToken, value: accesToken)
                KeyChain.create(key: Const.refreshToken, value: refreshToken)
                KeyChain.create(key: Const.userId, value: user.id)
                
                completion(.success(user))
                //                    guard let message = decodedData?.message else { return }
                //                    let arry = message.components(separatedBy: ",")
                //                    let loginSuccess = arry[0]
                //                    let accessToken = arry[1]
                //                    let refreshToken = arry[2]
                //                    print(loginSuccess, accessToken, refreshToken)
                //                    AF.download(user.image!).responseData { response in
                //                        print(response.result)
                //                    }
            case .failure:
                completion(.failure(.serverError))
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
    
    func getNewPassword(id: UserID, completion: @escaping (Result<Bool?, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getNewPassord(id)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else {
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
                completion(.success(body.result))
            default:
                completion(.failure(.unknownError(response.response?.statusCode)))
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
    
    enum CodingKeys: String, CodingKey {
        case result, status, error, code, message, timestamp
    }
}

struct ResponseResults<T: Codable>: Codable {
    let result: [T?]
    let message: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
    }
}

struct ResponseResultTypes<T: Codable, S: Codable, X: Codable>: Codable {
    let result: Dummy<T, S, X>?
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
