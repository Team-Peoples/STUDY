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
    
    case unknownError(Int?)
    case serverError
    case notServerError(String)
    case badRequest(ResponseResult<Bool>)
}

struct Network {
    
    static let shared = Network()
    
    func checkEmail(email: String, completion: @escaping (PeoplesError?) -> ()) {
        AF.request(RequestPurpose.emailCheck(email)).response { response in
            
            if let _ = response.error { completion(.serverError) }
            guard let httpResponse = response.response,let data = response.data else { completion(.serverError); return }
            
            switch httpResponse.statusCode {
            case (200...299):
                completion(nil)
            default: completion(.serverError)
            }
        }
    }
    
    func SNSSignIn(token: String, sns: SNS, completion: @escaping (User) -> () ) {
        AF.request(RequestPurpose.getJWTToken(token, sns)).validate().responseData { response in
            switch response.result {
            case .success(let data):
                
                let decodedData = jsonDecode(type: ResponseResult<User>.self, data: data)
                guard let user = decodedData?.result else { return }
                
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
                    guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(body))
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
//    
    func signIn(id: String, pw: String, completion: @escaping (User?) -> Void) {
        AF.request(RequestPurpose.signIn(id, pw)).validate().responseData { response in
            switch response.result {
                case .success(let data):
                    
                    let decodedData = jsonDecode(type: ResponseResult<User>.self, data: data)
                    guard let user = decodedData?.result else { return }
                    guard let message = decodedData?.message else { return }
                    let arry = message.components(separatedBy: ",")
                    let loginSuccess = arry[0]
                    let accessToken = arry[1]
                    let refreshToken = arry[2]
                    print(loginSuccess, accessToken, refreshToken)
                    
                    AF.download(user.image!).responseData { response in
                        print(response.result)
                    }
                    
                    completion(user)
                case .failure(let error):
                    print(error)
            }
        }
    }
//    
//    func check(email: String) {
//        AF.request(RequestPurpose.emailCheck(email)).validate().responseData { response in
//            switch response.result {
//                case .success(let data):
//                    let response = data.toDictionary()
//                    print(response)
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
    
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
    let message: String
    let timestamp: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp, code
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
