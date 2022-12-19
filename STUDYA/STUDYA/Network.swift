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
    case notFound
    case serverError
    case decodingError
    case unknownError(Int?)
    case tokenExpired
}

enum ErrorCode {
    static let duplicatedEmail = "DUPLICATE_EMAIL"
    static let wrongPassword = "PASSWORD_MISMATCH"
}

struct Network {
    
    static let shared = Network()
    
    private init() {
    }

    func saveLoginformation(httpResponse: HTTPURLResponse, user: User, completion: (Result<User, PeoplesError>) -> Void) {
        if let accesToken = httpResponse.allHeaderFields[Const.accessToken] as? String,
           let refreshToken = httpResponse.allHeaderFields[Const.refreshToken] as? String,
           let userID = user.id {
            KeyChain.create(key: Const.accessToken, value: accesToken)
            KeyChain.create(key: Const.refreshToken, value: refreshToken)
            KeyChain.create(key: Const.userId, value: userID)
        } else {
            completion(.failure(.loginInformationSavingError))
        }
    }
    
    func checkIfDuplicatedEmail(email: String, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.emailCheck(email)).response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return}
            let httpStatusCode = httpResponse.statusCode
            switch httpStatusCode {
            case 200:
                guard let data = response.data, let decodedData = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(decodedData))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func SNSSignIn(token: String, sns: SNS, completion: @escaping (Result<User,PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getJWTToken(token, sns)).response { response in

            guard let httpResponse = response.response,
                  let data = response.data else { completion(.failure(.serverError)); return }
            let httpStatusCode = httpResponse.statusCode

            switch httpStatusCode {
            case 200:
                guard let user = jsonDecode(type: User.self, data: data) else { completion(.failure(.decodingError)); return }
                saveLoginformation(httpResponse: httpResponse, user: user, completion: completion)

                completion(.success(user))
            default:
                seperateCommonErrors(statusCode: httpStatusCode) { result in
                    completion(result)
                }
            }
        }
    }

//    회원가입시 사진 선택 안하면 이미지에 nil을 보내게할 수는 없는건가
    func signUp(userId: String, pw: String, pwCheck: String, nickname: String?, image: UIImage?, completion: @escaping (Result<User, PeoplesError>) -> Void) {

        let user = User(id: userId, password: pw, passwordCheck: pwCheck, nickName: nickname)

            guard let jsonData = try? JSONEncoder().encode(user),
                  let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

            AF.upload(multipartFormData: { data in
                data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
                data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/formed-data")
            }, with: RequestPurpose.signUp).response { response in

                guard let httpResponse = response.response,
                      let data = response.data else { completion(.failure(.serverError)); return }
                guard let body = jsonDecode(type: ResponseResult<Bool>.self, data: data) else { completion(.failure(.decodingError)); return }

                switch httpResponse.statusCode {
                case 200:
                    saveLoginformation(httpResponse: httpResponse, user: user, completion: completion )

                    completion(.success(user))
                case 400:

                    switch body.code {
                    case ErrorCode.duplicatedEmail: completion(.failure(.duplicatedEmail))
                    case ErrorCode.wrongPassword: completion(.failure(.wrongPassword))
                    default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                    }
                default:
                    seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                        completion(result)
                    }
                }
            }
        }

    func signIn(id: String, pw: String, completion: @escaping (Result<User,PeoplesError>) -> Void) {
        AF.request(RequestPurpose.signIn(id, pw)).response { response in
            switch response.result {
            case .success(let data):
                guard let httpResponse = response.response else {
                    completion(.failure(.serverError))
                    return
                }
                guard let data = data, let user = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }

                saveLoginformation(httpResponse: httpResponse, user: user, completion: completion)
                completion(.success(user))
            case .failure:
                seperateCommonErrors(statusCode: response.response?.statusCode, completion: completion)
                seperateCommonErrors(statusCode: response.response?.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func resendAuthEmail(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.resendAuthEmail, interceptor: TokenRequestInterceptor()).response { response in
            guard let httpResponse = response.response, let _ = response.data else { completion(.failure(.serverError)); return }
            switch httpResponse.statusCode {
            case 200:
                completion(.success(true))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func checkIfEmailCertificated(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.checkEmailCertificated, interceptor: TokenRequestInterceptor()).response { response in
            guard let statusCode = response.response?.statusCode else { completion(.failure(.serverError)); return }
            
            switch statusCode {
            case 200:
                guard let data = response.data, let isEmailCertificated = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return }
                
                completion(.success(isEmailCertificated))
            default:
                seperateCommonErrors(statusCode: statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func getNewPassword(id: UserID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getNewPassord(id)).response { response in

            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data, let body = jsonDecode(type: ResponseResult<Bool>.self, data: data), let user = body.result else {
                    completion(.failure(.decodingError))
                    return
                }

                completion(.success(user))
            default:
                
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func getUserInfo(completion: @escaping (Result<User, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getMyInfo, interceptor: TokenRequestInterceptor()).response { response in
            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }

            switch httpResponse.statusCode {
                case 200:
                
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(user))
            default:
                
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
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

            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(user))
            default:
                
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func closeAccount(userID: UserID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteUser(userID), interceptor: TokenRequestInterceptor()).response { response in
            
            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data,
                      let body = jsonDecode(type: ResponseResult<Bool>.self, data: data),
                      let isNotManager = body.result else {
                    
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isNotManager))
            case 404:
                
                completion(.failure(.notFound))
            default:
                
                seperateCommonErrors(statusCode:  httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func refreshToken(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.refreshToken).response { response in
            
            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data,
                      let body = jsonDecode(type: ResponseResult<Bool>.self, data: data),
                      let isSuccessed = body.result else {
                    
                    completion(.failure(.decodingError))
                    return
                }
                
                guard isSuccessed else { return }
                
                if let accesToken = httpResponse.allHeaderFields[Const.accessToken] as? String,
                   let refreshToken = httpResponse.allHeaderFields[Const.refreshToken] as? String {
                    KeyChain.create(key: Const.accessToken, value: accesToken)
                    KeyChain.create(key: Const.refreshToken, value: refreshToken)
                } else {
                    completion(.failure(.loginInformationSavingError))
                }

            default:

                //리프레시 토큰도 만료되었을 경우 로그아웃 시킨다.
                completion(.failure(.tokenExpired))
//                🛑ehd: 여기서 무슨액션을 하면 retry에 failure쪽 코드가 정상 실행 되나?
            }
        }
    }

    // MARK: - Study

    func createStudy(_ study: Study, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createStudy(study), interceptor: TokenRequestInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { return }

            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data,
                      let body = jsonDecode(type: ResponseResult<Study>.self, data: data),
                      let study = body.result else {
                    
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(study))
            default:
                // domb: 토큰 인증 실패
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }

    func getAllStudy(completion: @escaping (Result<[Study?], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudy, interceptor: TokenRequestInterceptor()).response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }

            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let studies = jsonDecode(type: ResponseResults<Study>.self, data: data)?.result else { completion(.failure(.decodingError)); return }
//                🛑아무것도 없을 때 reponse에 data 계속 안넣어주면 옵셔널 바인딩 분리해서 if let 으로 해야함.
                completion(.success(studies))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
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
    
    func seperateCommonErrors<T: Decodable>(statusCode: Int?, completionType: T.Type = T.self, completion: @escaping (Result<T,PeoplesError>) -> Void) {
           
           guard let statusCode = statusCode else { return }
           
           switch statusCode {
           case 200: completion(.failure(.decodingError))
           case 500: completion(.failure(.serverError))
           case 401:completion(.failure(.unauthorizedUser))
           case 403: completion(.failure(.tokenExpired))
           default: completion(.failure(.unknownError(statusCode)))
           }
       }
}

extension UIAlertController {
    static func handleCommonErros(presenter: UIViewController, error: PeoplesError?) {
        DispatchQueue.main.async {
            
            var alert = SimpleAlert(message: "")
            guard let error = error else { return }
            
            switch error {
            case .serverError:
                alert = SimpleAlert(message: Const.serverErrorMessage)
            case .decodingError:
                alert = SimpleAlert(message: Const.unknownErrorMessage + " code = 1")
            case .unauthorizedUser:
                alert = SimpleAlert(buttonTitle: "확인", message: "인증되지 않은 사용자입니다. 로그인 후 사용해주세요.", completion: { finished in
                    AppController.shared.deleteUserInformationAndLogout()
                })
            case .tokenExpired:
                alert = SimpleAlert(buttonTitle: "확인", message: "로그인이 만료되었습니다. 다시 로그인해주세요.", completion: { finished in
                    AppController.shared.deleteUserInformationAndLogout()
                })
            case .unknownError(let errorCode):
                guard let errorCode = errorCode else { return }
                alert = SimpleAlert(message: Const.unknownErrorMessage + " code = \(errorCode)")
            default:
                alert = SimpleAlert(message: Const.unknownErrorMessage)
            }
            
            presenter.present(alert, animated: true)
        }
    }
    
    static func showDecodingError(presenter: UIViewController) {
        let alert = SimpleAlert(message: Const.unknownErrorMessage + " code = 1")
        presenter.present(alert, animated: true)
    }
}

extension DateFormatter {
    
    static let myDateFormatter: DateFormatter = {
        
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
    
    enum CodingKeys: String, CodingKey {
        case result, message, timestamp
    }
}

struct Dummy<U: Codable, W: Codable, Z: Codable>: Codable {
    let noti: U
    let study: W
    let schedule: Z
}
