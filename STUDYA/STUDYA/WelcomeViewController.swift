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
        addConstraints()
        
        underBar.backgroundColor = UIColor.appColor(.keyColor3)
        
        addSubviews()
        addArangedSubviewsToStack()
    }
    
    @objc private func kakaoLoginButtonTapped() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    guard let accessToken = oauthToken?.accessToken else { return }
                    Network.shared.SNSSignIn(token: accessToken, sns: .kakao) { user in
                        
                        if user != nil {
                            NotificationCenter.default.post(name: .loginSuccess, object: user)
                        } else {
                            DispatchQueue.main.async {
                                let alert = SimpleAlert(message: Const.serverErrorMessage)
                                self.present(alert, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
        
        @objc private func naverLoginButtonTapped() {
            naverLogin?.delegate = self
            naverLogin?.requestThirdPartyLogin()
        }
        
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
}

extension WelcomViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLogin?.accessToken else { return }
        Network.shared.SNSSignIn(token: accessToken, sns: .naver) { user in
//            소셜로그인시 firstlogin이면 화면전환
            if user != nil {
                NotificationCenter.default.post(name: .loginSuccess, object: user)
            } else {
                DispatchQueue.main.async {
                    let alert = SimpleAlert(message: Const.serverErrorMessage)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = naverLogin?.accessToken else { return }
        Network.shared.SNSSignIn(token: accessToken, sns: .naver) { user in
//            소셜로그인시 firstlogin이면 화면전환
            if user != nil {
                NotificationCenter.default.post(name: .loginSuccess, object: user)
            } else {
                DispatchQueue.main.async {
                    let alert = SimpleAlert(message: Const.serverErrorMessage)
                    self.present(alert, animated: true)
                }
            }
        }
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

