//
//  AccountMangementViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 3/23/23.
//

import UIKit
import Combine
import Kingfisher

class AccountMangementViewModel {
    
    var profileImage: UIImage?
    var nickName: String?
    var id: String?
    var sns: SNS = .none
    var error: Observable<PeoplesError> = Observable(.noError)
    
    @Published var oldPassword: String = String() {
        didSet {
            if oldPassword != String() {
                oldPasswordIsEmpty = false
            } else {
                oldPasswordIsEmpty = true
            }
        }
    }
    @Published var profileImageChanged = false
    @Published var nicknameChanged = false
    @Published var oldPasswordIsEmpty = true
    @Published var newPassword = String()
    @Published var newPasswordCheck = String()
    @Published var oldPasswordIsValidated = false
    
    var profileIsChangedPublisher: AnyPublisher<Bool,Never> {
        Publishers.CombineLatest($nicknameChanged, $profileImageChanged)
            .map { (nicknameChanged, profileImageChanged) in
                let profileIsChanged = nicknameChanged || profileImageChanged
                return profileIsChanged
            }
            .dropFirst()
            .eraseToAnyPublisher()
    }

    var passwordFormIsValidPublisher: AnyPublisher<(Bool, Bool, Bool, Bool), Never> {
        Publishers.CombineLatest4($oldPasswordIsEmpty, $oldPasswordIsValidated, $newPassword, $newPasswordCheck)
            .map { [weak self] (oldPasswordIsEmpty,
                                oldPasswordIsValidated,
                                newPassword,
                                newPasswordCheck) in

                let isValidNewPassword = self!.validateCheck(newPassword)
                let isValidNewPasswordCheck = self!.validateCheck(newPasswordCheck) && self!.isSame(newPasswordCheck, and: newPassword)


                return (oldPasswordIsEmpty, oldPasswordIsValidated, isValidNewPassword, isValidNewPasswordCheck)
            }
            .dropFirst()
            .eraseToAnyPublisher()
    }

    var cancellables = Set<AnyCancellable>()

    init() {
        
        $oldPassword
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .dropFirst()
            .removeDuplicates()
            .map { oldPassword in
                Future<Bool, Never> { [weak self] promise in
                    self?.checkOldPassword(oldPassword) { result in
                        promise(.success(result))
                    }
                }
            }
            .switchToLatest()
            .sink { [weak self] result in
                self?.oldPasswordIsValidated = result
            }
            .store(in: &cancellables)
    }
    
    func getUserInfo(completion: @escaping (User) -> Void) {
        Network.shared.getUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                self?.id = user.id
                self?.nickName = user.nickName
                
                if let kakaoLogin = user.isKakaoLogin, kakaoLogin {
                    self?.sns = .kakao
                } else if let naverLogin = user.isNaverLogin, naverLogin {
                    self?.sns = .naver
                } else {
                    self?.sns = .none
                }
                
                if let imageURL = user.imageURL {
                    guard let url = URL(string: imageURL) else { return }
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let imageResult):
                            let image = imageResult.image
                            self?.profileImage = image
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                completion(user)
            case .failure(let error):
                self?.error.value = error
            }
        }
    }
    
    func updateUserInfo(completion: @escaping () -> Void) {
        Network.shared.updateUserInfo(oldPassword: oldPassword, password: newPassword, passwordCheck: newPasswordCheck, nickname: nickName, image: profileImage) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func closeAccount(completion: @escaping (Result<Bool, PeoplesError>) -> Void) {
        
        guard let userId = KeychainService.shared.read(key: Constant.userId) else { return }
        
        Network.shared.closeAccount(userID: userId) { result in
            completion(result)
        }
    }
    
    func checkOldPassword(_ password: String, completion: @escaping (Bool) -> Void) {
        
        guard let id = id else { fatalError() }
        
        Network.shared.checkIfCorrectedOldPassword(userID: id, password: password) { result in
            switch result {
            case .success(let isCorrectOldPassword):
                completion(isCorrectOldPassword)
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    private func validateCheck(_ text: String, _ comfirmText: String = String()) -> Bool {
        guard text != "" else { return false }
        
        let range = text.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}", options: .regularExpression)
        let isValidated = range != nil
        return isValidated
    }
    
    private func isSame(_ password: String, and comfirmPassword: String) -> Bool {
        return password == comfirmPassword
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
