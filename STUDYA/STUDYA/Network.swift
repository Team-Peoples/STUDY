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
    
    func signUp(user: User, image: UIImage) {
        guard let jsonData = try? JSONEncoder().encode(user) else { return }
        guard let stringData = String(data: jsonData, encoding: .utf8) else { return }
    
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        
        ["param", "file"].forEach {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\($0)\""
            if $0 == "param" {
                body += "\r\nContent-Type: \("application/json")"
                body += "\r\n\r\n\(stringData)\r\n"
            } else {
                guard let fileData = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() else { fatalError() }
                // png 또는 jpg 어떻게 구분?
                body += "; filename=\"\($0)\"\r\n" + "Content-Type: \"content-type header\"\r\n\r\n\(fileData)\r\n"
            }
        }
        
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: (RequestPurpose.signUp(user).urlRequest?.url!)!)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
//        AF.upload(multipartFormData: { data in
//            data.append(imageData, withName: "profile_Image", fileName: nil, mimeType: nil)
//
//        }, with: RequestPurpose.signUp(user)).validate().responseData { response in
//            switch response.result {
//                case .success(let data):
//                    let response = data.toDictionary()
//                    print(response)
//                case .failure(let error):
//                    print(error)
//            }
//        }
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
