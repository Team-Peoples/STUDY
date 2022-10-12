//
//  Network.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/14.
//

import UIKit
import Alamofire


struct Network {
    
    static let shared = Network()
    
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
    
//    func signUp(userID: String, image: UIImage?) {
//        var value: String?
//        lazy var user1 = User(userId: value, oldPassword: nil, password: nil, passwordCheck: nil, nickName: nil)
//        
//        value = userID
//        guard let jsonData = try? JSONEncoder().encode(user1) else { return }
//        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
//        
//        AF.upload(multipartFormData: { data in
//            data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
//            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
//        }, with: RequestPurpose.signUp(user)).responseData { response in
//            switch response.result {
//                case .success(let data):
//                    let response = data.toDictionary()
//                    print(response)
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
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
    
    func createStudy(_ study: Study, completion: @escaping (Result<Study?, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createStudy(study)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let body = jsonDecode(type: ResponseResult<Study>.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
//                        completion(.failure(.notServerError(message)))
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
    let message: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
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
