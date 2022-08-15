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
    
    func signUp(user: User, imageData: UIImage) {
        let imageData = imageData.jpegData(compressionQuality: 1)!
        AF.upload(multipartFormData: { data in
            data.append(imageData, withName: "profile_Image", fileName: nil, mimeType: nil)
            
        }, with: RequestPurpose.signUp(user)).validate().responseData { response in
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
                    let response = data.toDictionary()
                    print(response)
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
