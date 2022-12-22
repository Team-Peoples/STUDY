//
//  WelcomeViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/02.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import NaverThirdPartyLogin

final class WelcomViewController: UIViewController {
    
    let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
    var loginAction: (User) -> Void = { _ in }
    
    private let welcomeLabel = CustomLabel(title: "환영합니다 :)", tintColor: .ppsBlack, size: 30, isBold: true)
    private let kakaoLoginButton = BrandButton(title: "카카오로 시작하기")
    private let naverLoginButton = BrandButton(title: "네이버로 시작하기")
    private let emailLoginButton = BrandButton(title: "이메일로 시작하기")
    private let signUpView = CustomLabel(title: "이메일 회원가입", tintColor: .keyColor1, size: 16, isBold: true)
    private let underBar = UIView(frame: .zero)
    private let buttonsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        naverLoginButton.addTarget(self, action: #selector(naverLoginButtonTapped), for: .touchUpInside)
        emailLoginButton.addTarget(self, action: #selector(emailLoginButtonDidTapped), for: .touchUpInside)
        
        signUpView.isUserInteractionEnabled = true
        signUpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpViewDidTapped)))
        
        configureButtons()
        configureStackView()
        
        
        underBar.backgroundColor = UIColor.appColor(.keyColor3)
        
        addSubviews()
        addArangedSubviewsToStack()
        addConstraints()
    }
    
    @objc private func kakaoLoginButtonTapped() {
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("loginWithKakaoTalk() success.")
//
//                    guard let accessToken = oauthToken?.accessToken else { return }
//                    self.socialSignIn(SNSToken: accessToken, service: .kakao)
//                }
//            }
//        }
    }
        
        @objc private func naverLoginButtonTapped() {
            naverLogin?.delegate = self
            naverLogin?.requestThirdPartyLogin()
        }
    
//    @objc private func naverLoginButtonTapped() {
//            let alertController = UIAlertController(title: "정말 탈퇴하시겠어요?", message: "참여한 모든 스터디 기록이 삭제되고, 다시 가입해도 복구할 수 없어요.😥", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//            let closeAccountAction = UIAlertAction(title: "탈퇴하기", style: .destructive) {
//                _ in
//
//                self.closeAccount()
//            }
//
//            alertController.addAction(closeAccountAction)
//            alertController.addAction(cancelAction)
//            present(alertController, animated: true)
//    }
    
    
//    private func closeAccount() {
//        guard let userId = KeyChain.read(key: Const.userId) else { return }
//
//        Network.shared.closeAccount(userID: userId) { result in
//            switch result {
//            case .success(let isNotManager):
//                switch isNotManager {
//                case true:
//                    print("참여중인 스터디의 스터디장이 아닐경우 탈퇴됨.")
//                    KeyChain.delete(key: Const.accessToken)
//                    KeyChain.delete(key: Const.refreshToken)
//                    KeyChain.delete(key: Const.userId)
//                    KeyChain.delete(key: Const.isEmailCertificated)
//                    UserDefaults.standard.set(false, forKey: Const.isLoggedin)
//                    DispatchQueue.main.async {
//                        let vc = ByeViewController()
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: true)
//                    }
//
//                case false:
//                    print("참여중인 스터디의 스터디장일 경우 양도하는 플로우로 연결")
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
        @objc private func emailLoginButtonDidTapped() {
            let signInVC = SignInViewController()
            navigationController?.pushViewController(signInVC, animated: true)
        }
        
        @objc private func signUpViewDidTapped() {
            let signUpVC = SignUpViewController()
            navigationController?.pushViewController(signUpVC, animated: true)
        }
        
        private func addSubviews() {
            
            view.addSubview(welcomeLabel)
            view.addSubview(buttonsStackView)
            view.addSubview(signUpView)
            view.addSubview(underBar)
        }
        
        private func addArangedSubviewsToStack() {
            
            buttonsStackView.addArrangedSubview(kakaoLoginButton)
            buttonsStackView.addArrangedSubview(naverLoginButton)
            buttonsStackView.addArrangedSubview(emailLoginButton)
        }
        
        private func configureButtons() {
            
            kakaoLoginButton.setImage(UIImage(named: "kakao"), for: .normal)
            kakaoLoginButton.setTitleColor(UIColor.appColor(.kakaoBrown), for: .normal)
            kakaoLoginButton.backgroundColor = .appColor(.kakao)
            kakaoLoginButton.layer.borderWidth = 0
            kakaoLoginButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 7)
            
            naverLoginButton.setImage(UIImage(named: "naver"), for: .normal)
            naverLoginButton.setTitleColor(.white, for: .normal)
            naverLoginButton.backgroundColor = .appColor(.naver)
            naverLoginButton.layer.borderWidth = 0
            naverLoginButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 7)
        }
        
        private func configureStackView() {
            
            buttonsStackView.spacing = 14
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.axis = .vertical
        }
        
        private func addConstraints() {
            
            welcomeLabel.anchor(top: view.topAnchor, topConstant: 130, leading: view.leadingAnchor, leadingConstant: 20)
            
            buttonsStackView.anchor(top: welcomeLabel.bottomAnchor, topConstant: 200, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    //        buttonsStackView.setHeight(150 + 28)
            
            signUpView.anchor(top: buttonsStackView.bottomAnchor, topConstant: 14)
            signUpView.centerX(inView: view)
            
            underBar.anchor(top: signUpView.bottomAnchor, leading: signUpView.leadingAnchor, trailing: signUpView.trailingAnchor, height: 2)
        }
    
    private func socialSignIn(SNSToken: String,service: SNS) {
        Network.shared.SNSSignIn(token: SNSToken, sns: service) { result in
            switch result {
            case .success(let user):
                
                if let isFirstLogin = user.isFirstLogin {
                    if isFirstLogin {
                        KeyChain.create(key: Const.tempIsFirstSNSLogin, value: "1")
                        KeyChain.create(key: Const.isEmailCertificated, value: "1")
                        DispatchQueue.main.async {
                            let nextVC = ProfileSettingViewController()
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }

                    } else {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(message: Const.serverErrorMessage)
                        self.present(alert, animated: true)
                    }
                }
            default:
                DispatchQueue.main.async {
                    let alert = SimpleAlert(message: Const.serverErrorMessage)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension WelcomViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLogin?.accessToken else { return }
        
        socialSignIn(SNSToken: accessToken, service: .naver)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = naverLogin?.accessToken else { return }
        
        socialSignIn(SNSToken: accessToken, service: .naver)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        //        로그아웃시 사용하는 토큰 삭제시 호출되는 함수
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        //        네아로의 모든 에러에서 호출
        let alert = SimpleAlert(message: "네이버 로그인을 확인해주세요.")
        present(alert, animated: true)
    }
}
