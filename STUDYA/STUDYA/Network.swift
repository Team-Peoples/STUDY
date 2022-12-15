//
//  Network.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/14.
//

import UIKit
import Alamofire

enum PeoplesError: Error {
    case alreadyExistingEmail
    case alreadySNSSignUp
    case notAuthEmail
    
    case unknownError(Int?)
    case serverError
    case notServerError(String)
    case badRequest(ResponseResult<Bool>)
}

struct Network {
    
    static let shared = Network()
    
    func checkEmail(email: String, completion: @escaping (PeoplesError?) -> Void) {
        AF.request(RequestPurpose.emailCheck(email)).response { response in

            if let _ = response.error { completion(.serverError) }
            guard let httpResponse = response.response, let _ = response.data else { completion(.serverError); return }

            switch httpResponse.statusCode {
            case (200...299):
                completion(nil)
            default: completion(.serverError)
            }
        }
    }

    func SNSSignIn(token: String, sns: SNS, completion: @escaping (User) -> Void) {
        AF.request(RequestPurpose.getJWTToken(token, sns)).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decodedData = jsonDecode(type: ResponseResult<User>.self, data: data)
                guard let user = decodedData?.result else { return }
                print(user)
                completion(user)
            case .failure(let error):
                print(error)
            }
        }
    }


    func signUp(userId: String, pw: String, pwCheck: String?, nickname: String?, image: UIImage?, completion: @escaping (Result<ResponseResult<Bool>, PeoplesError>) -> Void) {

        let user = User(id: userId, password: pw, passwordCheck: pwCheck, nickName: nickname)

        guard let jsonData = try? JSONEncoder().encode(user) else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

        AF.upload(multipartFormData: { data in
            data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
        }, with: RequestPurpose.signUp).response { response in

            guard let httpResponse = response.response else { return }

            switch httpResponse.statusCode {
            case 200:
//                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else {
//                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
//                    completion(.failure(.notServerError(message)))
//                    return
//                }
//                completion(.success(body))
                
                guard let data = response.data else { fatalError() }
                print(data)
            case 400:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else {
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
                completion(.failure(.badRequest(body)))
            case 500:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownError(response.response?.statusCode)))
            }
        }
    }

    func signIn(id: String, pw: String, completion: @escaping (Result<User,PeoplesError>) -> Void) {
        AF.request(RequestPurpose.signIn(id, pw)).validate().response { response in
            switch response.result {
            case .success(let data):
    
                guard let accessToken = response.response?.allHeaderFields["AccessToken"] as? String else {
                    completion(.failure(.serverError))
                    return
                }
                guard let refreshToken = response.response?.allHeaderFields["RefreshToken"] as? String else { completion(.failure(.serverError))
                    return
                }
                guard let data = data, let user = jsonDecode(type: User.self, data: data) else {
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
                
                guard let userId = user.id else { fatalError() }
                
                UserDefaults.standard.removeObject(forKey: Const.userId)
                UserDefaults.standard.set(userId, forKey: Const.userId)
                KeyChain.create(key: userId, token: accessToken)
                KeyChain.create(key: accessToken, token: refreshToken)

                completion(.success(user))
            case .failure:
                completion(.failure(.unknownError(response.response?.statusCode)))
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
    
    func getNewPassword(id: UserID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getNewPassord(id)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data), let result = body.result else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    
                completion(.success(result))
                default:
                    completion(.failure(.unknownError(response.response?.statusCode)))
            }
        }
    }
    
    func getUserInfo(completion: @escaping (Result<User, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getMyInfo, interceptor: TokenRequestInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
                completion(.success(user))
            default:
                // domb: token 인증실패
                completion(.failure(.unknownError(response.response?.statusCode)))
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
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
                completion(.success(user))
            default:
                // domb: token 인증실패
                completion(.failure(.unknownError(response.response?.statusCode)))
            }
        }
    }
    
    
    
    func refreshToken(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.refreshToken).validate().response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data), let isSuccessed = body.result else {
                    let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                    completion(.failure(.notServerError(message)))
                    return
                }
            
                if isSuccessed {
                    
                    guard let accesToken = response.response?.allHeaderFields["AccessToken"] as? String else { completion(.failure(.serverError)); return }
                    guard let refreshToken = response.response?.allHeaderFields["RefreshToken"] as? String else { completion(.failure(.serverError)); return }
                    
                    // 엑세스 토큰 비교해서 저장하기
                    // User Id는 어디서 가져올 것인가.
                    UserDefaults.standard.removeObject(forKey: Const.userId)
                    UserDefaults.standard.set("", forKey: Const.userId)
                    KeyChain.create(key: Const.userId, token: accesToken)
                    KeyChain.create(key: accesToken, token: refreshToken)
                }
                
            default:
                
                //리프레시 토큰도 만료되었을 경우 로그아웃 시킨다.
                completion(.failure(.serverError))
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
    let message: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
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
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
    }
}

struct Dummy<U: Codable, W: Codable, Z: Codable>: Codable {
    let noti: U
    let study: W
    let schedule: Z
}

