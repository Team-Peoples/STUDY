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
    
    func signUp(userID: String, image: UIImage?) {
        var value: String?
        lazy var user1 = User(userId: value, oldPassword: nil, password: nil, passwordCheck: nil, nickName: nil)
        
        value = userID
        guard let jsonData = try? JSONEncoder().encode(user1) else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        AF.upload(multipartFormData: { data in
            data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
        }, with: RequestPurpose.signUp(user)).responseData { response in
            switch response.result {
                case .success(let data):
                    let response = data.toDictionary()
                    print(response)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func signIn(credential: Credential) {
        AF.request(RequestPurpose.signIn(credential)).validate().responseData { response in
            switch response.result {
                case .success(let data):
                    let dic = data.toDictionary()
                    guard let result = dic["result"] as? [String: Any] else { return }
                    guard let img = result["img"] else { return }
                    AF.download("http:/\(img)").responseData { response in
                        print(response.result)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func check(email: String) {
        AF.request(RequestPurpose.emailCheck(email)).validate().responseData { response in
            switch response.result {
                case .success(let data):
                    let response = data.toDictionary()
                    print(response)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
