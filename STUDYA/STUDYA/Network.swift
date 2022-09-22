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
                guard let result = decodedData?.result else { return }
                
                completion(result)
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
//    func signIn(credential: Credential) {
//        AF.request(RequestPurpose.signIn(credential)).validate().responseData { response in
//            switch response.result {
//                case .success(let data):
//                    let dic = data.toDictionary()
//                    guard let result = dic["result"] as? [String: Any] else { return }
//                    guard let img = result["img"] else { return }
//                    AF.download("http:/\(img)").responseData { response in
//                        print(response.result)
//                    }
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
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
