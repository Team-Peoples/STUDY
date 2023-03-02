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
    case unauthorizedUser
    case serverError
    case decodingError
    case unknownError(Int?)
    case tokenExpired
    case internalServerError
    
    case duplicatedEmail
    case alreadySNSSignUp
    case notAuthEmail
    case wrongPassword
    case loginInformationSavingError
    case userNotFound
    case studyNotFound
    case imageNotFound
    case wrongAttendanceCode
    case unauthorizedMember
    case cantExpelOwner
    case cantExpelSelf
    case cantChangeOwnerRole
    case youAreNotOwner
    case ownerCantLeave
}

enum ErrorCode {
    static let duplicatedEmail = "DUPLICATE_EMAIL"
    static let wrongPassword = "PASSWORD_MISMATCH"
    static let userNotFound = "USER_NOT_FOUND"
    static let studyNotFound = "STUDY_NOT_FOUND"
    static let imageNotFound = "IMG_NOT_FOUND"
    static let unknownMember = "NOT_STUDY_MEMBER"
    static let wrongAttendnaceCode = "CHECK_NUMBER_MISMATCH"
    static let unauthorizedMember = "NOT_MANAGER"
    static let cantExpelOwner = "MASTER_DO_NOT_EXPIRE"
    static let cantExpelSelf = "DO_NOT_SELF_EXPIRE"
    static let cantChangeOwnerRole = "MASTER_DO_NOT_CHANGE"
    static let needToResignMaster = "MASTER_DO_NOT_LEAVE"
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
        
        guard let jsonData = try? JSONEncoder().encode(user) else { return }
        let imageData = image?.jpegData(compressionQuality: 0.5) ?? Data()
        
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
                guard let data = response.data, let isEmailCertificated = jsonDecode(type: Bool.self, data: data) else { completion(.failure(.decodingError))
                    return
                }
                
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
        let imageData = Data()
        
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
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
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
    
    func checkIfCorrectedOldPassword(userID: UserID, password: Password, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.checkOldPassword(userID, password), interceptor: AuthenticationInterceptor()).validate().response {
            response in
            
            guard let httpResponse = response.response else {
                
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data,
                      let isCorrectOldPassword = jsonDecode(type: Bool.self, data: data) else {
                    
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isCorrectOldPassword))
                
                break
            default:
                
                seperateCommonErrors(statusCode:  httpResponse.statusCode) { result in
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
                
                guard let data = response.data, let responseResult = jsonDecode(type: ResponseResult<Bool>.self, data: data), let isSuccessed = responseResult.result else {
                    completion(.failure(.decodingError))
                    return
                }
                
                guard isSuccessed else {
                    completion(.failure(.serverError))
                    return
                }
                
                if let accesToken = httpResponse.allHeaderFields[Constant.accessToken] as? String,
                   let refreshToken = httpResponse.allHeaderFields[Constant.refreshToken] as? String {
                    
                    KeyChain.create(key: Constant.accessToken, value: accesToken)
                    KeyChain.create(key: Constant.refreshToken, value: refreshToken)
                    print("리프레시 토큰 저장 성공")
                    completion(.success(isSuccessed))
                } else {
                    completion(.failure(.loginInformationSavingError))
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
                
                //리프레시 토큰도 만료되었을 경우 로그아웃 시킨다.   //ehd: 403을 받으면 refresh -> refresh 시도했는데 실패시 401 뜸 -> seperateCommon에서 unauthuser 뜸 -> handleCommon에서 로그아웃 이렇게 되고 있는 거 아닌가?
                // 따로 handleCommon을 실행시키는 코드를 작성해주지않았을지도!
            }
        }
    }
    
    // MARK: - User Schedule
    
    // MARK: - Study
    
    func getAllStudies(completion: @escaping (Result<[Study], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudy, interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }

            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let studies = jsonDecode(type: [Study].self, data: data) else {
                 completion(.failure(.decodingError))
                    return
                }
                completion(.success(studies))

            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func getStudy(studyID: Int, completion: @escaping (Result<StudyOverall, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }

            switch httpResponse.statusCode {
            case 200:
                
                guard let data = response.data, let studyOverall = jsonDecode(type: StudyOverall.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(studyOverall))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
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
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
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
    func closeStudy(_ studyID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
       
        AF.request(RequestPurpose.closeStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
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
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
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
    
    func joinStudy(id studyID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.joinStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:

                guard let body = response.data, let isSuccess = jsonDecode(type: Bool.self, data: body) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isSuccess))
                
            case 404:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
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
    
    func leaveFromStudy(id studyID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.leaveFromStudy(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSuccess = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isSuccess))
            case 400:
                completion(.failure(.ownerCantLeave))
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func getAllMembers(studyID: Int, completion: @escaping (Result<MemberListResponse, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudyMembers(studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let response = jsonDecode(type: MemberListResponse.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(response))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func excommunicateMember(_ memberID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteMember(memberID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSucceed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isSucceed))
            case 400:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                 switch errorCode {
                case ErrorCode.unauthorizedMember:  completion(.failure(.unauthorizedMember))
                case ErrorCode.cantExpelOwner: completion(.failure(.cantExpelOwner))
                case ErrorCode.cantExpelSelf: completion(.failure(.cantExpelSelf))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            case 404:
                completion(.failure(.unauthorizedMember))
                
            default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func toggleMangerAuth(memberID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.toggleManagerAuth(memberID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else { completion(.failure(.serverError)); return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSucceed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isSucceed))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func updateUserRole(memberID: ID, role: String, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updateUserRole(memberID, role), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response, let data = response.data else { completion(.failure(.serverError)); return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let isSucceed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(isSucceed))
                
            case 400:
                guard let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.cantChangeOwnerRole:  completion(.failure(.cantChangeOwnerRole))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    // MARK: - Study Schedule
    
    func getAllStudyScheduleOfAllStudy(completion: @escaping (Result<AllStudyScheduleOfAllStudy, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllStudyScheduleOfAllStudy, interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let studyAllSchedule = jsonDecode(type: AllStudyScheduleOfAllStudy.self, data: data) else { return }
                completion(.success(studyAllSchedule))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func createStudySchedule(_ schedule: StudySchedulePosting, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        
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
    
    func updateStudySchedule(_ schedule: StudySchedulePosting, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
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
    
    func updatePinnedAnnouncement(_ announcementID: ID, isPinned: Bool, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updatePinnedAnnouncement(announcementID, isPinned), interceptor: AuthenticationInterceptor()).validate().response { response in
            
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
    
    func deleteAnnouncement(_ announcementID: ID, completion: @escaping (Result<[Announcement], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.deleteAnnouncement(announcementID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
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
    
    // MARK: - Study Attendance
    
    func getAttendanceCertificationCode(scheduleID: ID, completion: @escaping (Result<Int, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAttendanceCertificactionCode(scheduleID), interceptor: AuthenticationInterceptor()).validate().response { response in
            print("⚡️", response.response?.statusCode)
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let code = jsonDecode(type: Int.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(code))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func attend(in scheduleID: ID, with code: Int, completion: @escaping (Result<AttendanceInformation, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.attend(scheduleID, code), interceptor: AuthenticationInterceptor()).validate().response {
            response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let attendanceInformation = jsonDecode(type: AttendanceInformation.self, data: data) else {
                    
                    completion(.failure(.decodingError))
                    return
                }
                print(attendanceInformation, "❤️")
                completion(.success(attendanceInformation))
            case 400:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.unknownMember:  completion(.failure(.userNotFound))
                case ErrorCode.wrongAttendnaceCode: completion(.failure(.wrongAttendanceCode))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func getMyAttendanceBetween(start: DashedDate, end: DashedDate, studyID: ID, completion: @escaping (Result<MyAttendanceOverall, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getMyAttendanceBetween(start, end, studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let attendanceOverall = jsonDecode(type: MyAttendanceOverall.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(attendanceOverall))
            case 400:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.studyNotFound:  completion(.failure(.studyNotFound))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func getAllMembersAttendanceOn(_ date: DashedDate, studyID: ID, completion: @escaping (Result<AllUsersAttendacneForADay, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllMembersAttendanceOn(date, studyID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let allUsersAttendacneForADay = jsonDecode(type: AllUsersAttendacneForADay.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(allUsersAttendacneForADay))
            case 400:
                guard let data = response.data,
                      let errorBody = jsonDecode(type: ErrorResponse.self, data: data),
                      let errorCode = errorBody.code else {
                    completion(.failure(.decodingError))
                    return
                }
                
                switch errorCode {
                case ErrorCode.studyNotFound:  completion(.failure(.studyNotFound))
                default: seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
                }
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode) { result in
                    completion(result)
                }
            }
        }
    }
    
    func updateAttendanceInformation(_ info: SingleUserAnAttendanceInformation, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.update(info), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSucceed = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isSucceed))
            case 400:
                completion(.failure(.userNotFound))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    // MARK: - My Schedule
    func getAllMySchedules(completion: @escaping (Result<[MySchedule],PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getAllMySchedules, interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let schdules = jsonDecode(type: [MySchedule].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(schdules))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func createMySchedule(content: String, date: DashedDate, completion: @escaping (Result<[MySchedule], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.createMySchedule(content, date), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let schdules = jsonDecode(type: [MySchedule].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(schdules))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func toggleMyScheduleStatus(scheduleID: ID, completion: @escaping (Result<[MySchedule], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.toggleMyScheduleStatus(scheduleID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let schdules = jsonDecode(type: [MySchedule].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(schdules))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func updateMySchedule(scheduleID: ID, content: String, completion: @escaping (Result<[MySchedule], PeoplesError>) -> Void) {
        AF.request(RequestPurpose.updateMySchedule(scheduleID, content), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let schdules = jsonDecode(type: [MySchedule].self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(schdules))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func turnOverStudyOwnerTo(memberID: ID, completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.turnOverStudyOwnerTo(memberID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let isSuccess = jsonDecode(type: Bool.self, data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(isSuccess))
            case 403:
                completion(.failure(.youAreNotOwner))
                
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
    
    func getImminentScheduleAttendance(scheduleID: ID, completion: @escaping (Result<AttendanceInformation, PeoplesError>) -> Void) {
        AF.request(RequestPurpose.getImminentScheduleAttendnace(scheduleID), interceptor: AuthenticationInterceptor()).validate().response { response in
            guard let httpResponse = response.response else {
                completion(.failure(.serverError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let attendanceInfo = jsonDecode(type: AttendanceInformation.self, data: data) else {
                    completion(.failure(.decodingError))
                    print(String(data: response.data!, encoding: .utf8), "❌")
                    return
                }
                
                completion(.success(attendanceInfo))
            default:
                seperateCommonErrors(statusCode: httpResponse.statusCode, completion: completion)
            }
        }
    }
}

// MARK: - Helpers

extension Network {
    
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
        if let accesToken = httpResponse.allHeaderFields[Constant.accessToken] as? String,
           let refreshToken = httpResponse.allHeaderFields[Constant.refreshToken] as? String,
           let userID = user.id,
           let isEmailCertificated = user.isEmailCertificated {
            
            KeyChain.create(key: Constant.accessToken, value: accesToken)
            KeyChain.create(key: Constant.refreshToken, value: refreshToken)
            KeyChain.create(key: Constant.userId, value: userID)
            
            if isEmailCertificated {
                
                UserDefaults.standard.set(true, forKey: Constant.isLoggedin)
                KeyChain.create(key: Constant.isEmailCertificated, value: "1")
            } else {
                KeyChain.create(key: Constant.isEmailCertificated, value: "0")
            }
            
            completion(.success(user))
        } else {
            
            completion(.failure(.loginInformationSavingError))
        }
    }

    func jsonDecode<T: Codable>(type: T.Type, data: Data) -> T? {

        let jsonDecoder = JSONDecoder()
        let result: Codable?

        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.fullDateFormatter)
        
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
        print(statusCode,"🔥")
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
        case .internalServerError:
            alert = SimpleAlert(message: Constant.serverErrorMessage)
        case .decodingError:
            alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = 1")
        case .unauthorizedUser:
            alert = SimpleAlert(buttonTitle: Constant.OK, message: "인증되지 않은 사용자입니다. 로그인 후 사용해주세요.", completion: { finished in
                AppController.shared.deleteUserInformationAndLogout()
            })
        case .tokenExpired:
            alert = SimpleAlert(buttonTitle: Constant.OK, message: "로그인이 만료되었습니다. 다시 로그인해주세요.", completion: { finished in
                AppController.shared.deleteUserInformationAndLogout()
            })
        case .unknownError(let errorCode):
            guard let errorCode = errorCode else { return }
            alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = \(errorCode)")
        default:
            alert = SimpleAlert(message: Constant.unknownErrorMessage)
        }
        
        presenter.present(alert, animated: true)
    }
    
    static func showDecodingError(presenter: UIViewController) {
        let alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = 1")
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
