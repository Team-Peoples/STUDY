//
//  Network.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/14.
//

import UIKit
import Alamofire

// MARK: - Peoples Error

enum PeoplesError: Error {
    case duplicatedEmail
    case alreadySNSSignUp
    case notAuthEmail
    case wrongPassword
    case loginInformationSavingError
    case unauthorizedUser
    case serverError
    case internalServerError
    case decodingError
    case unknownError(Int?)
    case tokenExpired
    case userNotFound
    case studyNotFound
    case imageNotFound
}

enum ErrorCode {
    static let duplicatedEmail = "DUPLICATE_EMAIL"
    static let wrongPassword = "PASSWORD_MISMATCH"
    static let userNotFound = "USER_NOT_FOUND"
    static let studyNotFound = "STUDY_NOT_FOUND"
    static let imageNotFound = "IMG_NOT_FOUND"
}

// MARK: - Network

struct Network {
    
    static let shared = Network()
    
    private init() {
    }
    
    // MARK: - User
    
    func checkIfDuplicatedEmail(email: String, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.emailCheck(email)).response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return}
            let httpStatusCode = httpResponse.statusCode
            switch httpStatusCode {
            case 200:
                guard let data = response.data, let isIdenticalEmail = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isIdenticalEmail))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
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
            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/form-data")
        }, with: RequestPurpose.signUp).response { response in

            guard let httpResponse = response.response,
                  let data = response.data else { completion(.failure(.serverError)); return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let decodedUser = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                saveLoginformation(httpResponse: httpResponse, user: decodedUser, completion: completion)
            case 400:
                guard let decodedResponse = jsonDecode(type: ErrorResponse.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch decodedResponse.code {
                case ErrorCode.duplicatedEmail: completion(.failure(.duplicatedEmail))
                case ErrorCode.wrongPassword: completion(.failure(.wrongPassword))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func signIn(id: String, pw: String, completion: @escaping (Result<User,PeoplesError>) -> Void) {
        
        AF.upload(multipartFormData: { data in
            data.append(id.data(using: .utf8)!, withName: "userId")
            data.append(pw.data(using: .utf8)!, withName: "password")
        }, with: RequestPurpose.signIn).response { response in
            
            guard let httpResponse = response.response else { completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                saveLoginformation(httpResponse: httpResponse, user: user, completion: completion)
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func resendAuthEmail(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.resendAuthEmail, interceptor: AuthenticationInterceptor()).validate().response { response in
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
        AF.request(RequestPurpose.checkEmailCertificated, interceptor: AuthenticationInterceptor()).validate().response { response in
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
                
                guard let data = response.data, let isSuccessed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isSuccessed))
            case 404:
                completion(.failure(.userNotFound))
            default:
                
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func getUserInfo(completion: @escaping (Result<User, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getMyInfo, interceptor: AuthenticationInterceptor()).validate().response { response in
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
            case 404:
                completion(.failure(.userNotFound))
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
        let imageData = image?.jpegData(compressionQuality: 0.5) ?? Data()
        
        AF.upload(multipartFormData: { data in
            
            data.append(jsonData, withName: "param", fileName: "param", mimeType: "application/json")
            data.append(imageData, withName: "file", fileName: "file", mimeType: "multipart/form-data")
        }, with: RequestPurpose.updateUser(user), interceptor: AuthenticationInterceptor()).validate().response { response in
            
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
            case 404:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResult.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.imageNotFound:  completion(.failure(.imageNotFound))
                case ErrorCode.userNotFound: completion(.failure(.userNotFound))
                case ErrorCode.studyNotFound: completion(.failure(.studyNotFound))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            default:
                
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func closeAccount(userID: UserID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteUser(userID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
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
                
                completion(.failure(.userNotFound))
            default:
                
                seperateCommonErrors(statusCode:  httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.refreshToken, interceptor: TokenRequestInterceptor()).response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data, let isSuccessed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                guard isSuccessed else {
                    completion(.failure(.serverError))
                    return
                }
                
                if let accesToken = httpResponse.allHeaderFields[Const.accessToken] as? String,
                   let refreshToken = httpResponse.allHeaderFields[Const.refreshToken] as? String {
                    
                    KeyChain.create(key: Const.accessToken, value: accesToken)
                    KeyChain.create(key: Const.refreshToken, value: refreshToken)
                } else {
                    completion(.failure(.loginInformationSavingError))
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
                //리프레시 토큰도 만료되었을 경우 로그아웃 시킨다.
            }
        }
    }
    
    // MARK: - User Schedule
    
    // MARK: - Study
    
    func getAllStudy(completion: @escaping (Result<[Study?], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudy, interceptor: AuthenticationInterceptor()).validate().response { response in
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
    
    func createStudy(_ study: Study, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createStudy(study), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
           
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let study = jsonDecode(type: Study.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(study))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func updateStudy(_ study: Study, id studyID: ID, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updateStudy(studyID, study), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
           
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let study = jsonDecode(type: Study.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(study))
                
            case 404:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResult.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.imageNotFound:  completion(.failure(.imageNotFound))
                case ErrorCode.userNotFound: completion(.failure(.userNotFound))
                case ErrorCode.studyNotFound: completion(.failure(.studyNotFound))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    // domb: 스터디 종료인지 삭제인지 확인하고 구현하기 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func deleteStudy(_ study: Study, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
       
        AF.request(RequestPurpose.createStudy(study), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
           
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let study = jsonDecode(type: Study.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(study))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func joinStudy(id studyID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.joinStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let body = response.data, let isSuccessed = jsonDecode(type: Bool.self, data: body) else { return }
                
                completion(.success(isSuccessed))
                
            case 404:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResult.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.imageNotFound:  completion(.failure(.imageNotFound))
                case ErrorCode.userNotFound: completion(.failure(.userNotFound))
                case ErrorCode.studyNotFound: completion(.failure(.studyNotFound))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func getStudyInfo(of studyID: ID, completion: @escaping (Result<Study, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let body = response.data, let study = jsonDecode(type: Study.self, data: body) else { return }
                
                completion(.success(study))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    // MARK: - Study Schedule
    
    func getAllStudySchedule(completion: @escaping (Result<StudySchedule, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudySchedule, interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                print("스터디 스케쥴")
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func createStudySchedule(_ schedule: StudySchedule, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        
        AF.request(RequestPurpose.createStudySchedule(schedule), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSuccessed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isSuccessed))
            case 404:
                completion(.failure(.userNotFound))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func updateStudySchedule(_ schedule: StudySchedule, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updateStudySchedule(schedule), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data,
                      let isSuccessed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                // domb: 현재 방식대로 한다면 studyschedule 수정후 수정사항을 반영하려면 모든 스터디 스케쥴을 가져온후 리로드하는 방법이라 낭비가 크다고 생각함.
                completion(.success(isSuccessed))
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func deleteStudySchedule(_ studyScheduleID: ID, deleteRepeatSchedule: Bool,  completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteStudySchedule(studyScheduleID, deleteRepeatSchedule), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSuccessed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isSuccessed))
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    // MARK: - Study Announcement
    
    // domb: 빈배열로 올경우 어떻게 할것인지 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func getAllAnnouncement(studyID: ID, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllAnnouncements(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let announcements = jsonDecode(type: [Announcement].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(announcements))
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func createAnnouncement(title: String, content: String, studyID: ID, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createAnnouncement(title, content, studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let announcements = jsonDecode(type: [Announcement].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(announcements))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func updateAnnouncement(title: String, content: String, announcementID: ID, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updateAnnouncement(title, content, announcementID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let announcements = jsonDecode(type: [Announcement].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(announcements))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func updatePinnedAnnouncement(notificationID: ID, isPinned: Bool, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updatePinnedAnnouncement(notificationID, isPinned), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let announcements = jsonDecode(type: [Announcement].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(announcements))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func deleteAnnouncement(notificationID: ID, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteAnnouncement(notificationID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let announcements = jsonDecode(type: [Announcement].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(announcements))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
}

// MARK: - Helpers

extension Network {
    
    // MARK: - Image Download
    
    func setImage(stringURL: String, completion: @escaping (Result<UIImage?, PeoplesError>) -> Void) {

        AF.request(stringURL).response { response in

            guard let httpResponse = response.response else { return }

            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let image = UIImage(data: data) else {
                        completion(.failure(.decodingError))
                        return
                    }
                    completion(.success(image))
                default:
                completion(.failure(.unknownError(httpResponse.statusCode)))
            }
        }
    }

    func saveLoginformation(httpResponse: HTTPURLResponse, user: User, completion: (Result<User, PeoplesError>) -> Void) {
        if let accesToken = httpResponse.allHeaderFields[Const.accessToken] as? String,
           let refreshToken = httpResponse.allHeaderFields[Const.refreshToken] as? String,
           let userID = user.id,
           let isEmailCertificated = user.isEmailCertificated {
            
            KeyChain.create(key: Const.accessToken, value: accesToken)
            KeyChain.create(key: Const.refreshToken, value: refreshToken)
            KeyChain.create(key: Const.userId, value: userID)
            
            if isEmailCertificated {
                
                UserDefaults.standard.set(true, forKey: Const.isLoggedin)
                KeyChain.create(key: Const.isEmailCertificated, value: "1")
            } else {
                KeyChain.create(key: Const.isEmailCertificated, value: "0")
            }
            
            completion(.success(user))
        } else {
            
            completion(.failure(.loginInformationSavingError))
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
        case 500: completion(.failure(.internalServerError))
        case 401: completion(.failure(.unauthorizedUser))
        case 403: completion(.failure(.tokenExpired))
        default: completion(.failure(.unknownError(statusCode)))
        }
    }
}

extension UIAlertController {
    static func handleCommonErros(presenter: UIViewController, error: PeoplesError?) {
            
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
    
    static func showDecodingError(presenter: UIViewController) {
        let alert = SimpleAlert(message: Const.unknownErrorMessage + " code = 1")
        presenter.present(alert, animated: true)
    }
}

// MARK: - Networking Model

struct ResponseResult<T: Codable>: Codable {
    let result: T?
    let status: Int?
    let error: String?
    let code: String?
    let message: String?
    let timestamp: String?
    let studyMemberList: [Study]?
}

struct ErrorResponse: Codable {
    let status: Int?
    let error: String?
    let code: String?
    let message: String?
    let timestamp: String?
}

struct ErrorResult: Codable {
    let status: Int?
    let error: String?
    let code: String?
    let message: String?
    let timestamp: String?
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
