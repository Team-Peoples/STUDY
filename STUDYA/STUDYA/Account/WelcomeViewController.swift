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
    private let descriptionLabel = CustomLabel(title: "가입을 진행하면, 이용 약관 및 개인정보 처리방침에 동의한 것으로 간주합니다.", tintColor: .ppsGray1, size: 11)
    
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
        
        configureDescriptionLabel()
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
    
    @objc private func emailLoginButtonDidTapped() {
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc private func signUpViewDidTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let descriptionLabel = sender.view as! UILabel
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: descriptionLabel.bounds.size)
        let attributedText = NSMutableAttributedString(attributedString: descriptionLabel.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        attributedText.addAttributes([NSAttributedString.Key.font: descriptionLabel.font!], range: NSRange(location: 0, length: attributedText.length))
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // Find the character index of the tapped word
        let locationOfTapInLabel = sender.location(in: descriptionLabel)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (descriptionLabel.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
                                          y: (descriptionLabel.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)
        let locationOfTapInTextContainer = CGPoint(x: locationOfTapInLabel.x - textContainerOffset.x,
                                                   y: locationOfTapInLabel.y - textContainerOffset.y)
        let characterIndex = layoutManager.characterIndex(for: locationOfTapInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let range1 = (descriptionLabel.text! as NSString).range(of: "이용 약관")
        let range2 = (descriptionLabel.text! as NSString).range(of: "개인정보 처리방침")
        
        // Check which word was tapped and push the appropriate view controller
        if range1.contains(characterIndex) {
            navigationController?.pushViewController(AgreementViewController(), animated: true)
        } else if range2.contains(characterIndex) {
            navigationController?.pushViewController(TreatingPersonalDataViewController(), animated: true)
        }
    }
    
    private func socialSignIn(SNSToken: String, service: SNS) {
        Network.shared.SNSSignIn(token: SNSToken, sns: service) { result in
            switch result {
            case .success(let user):
                
                if let isFirstLogin = user.isFirstLogin {
                    
                    if isFirstLogin {
                        KeyChain.create(key: Constant.tempIsFirstSNSLogin, value: "1")
                        KeyChain.create(key: Constant.isEmailCertificated, value: "1")
                        
                        let nextVC = ProfileSettingViewController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    } else {
                        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                    }
                    
                } else {
                    let alert = SimpleAlert(message: Constant.serverErrorMessage)
                    self.present(alert, animated: true)
                }
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func configureDescriptionLabel() {
        underlinePartOfLabel()
        insertTapActionToDescriptionLabel()
    }
    
    private func underlinePartOfLabel() {
        let attributedString = NSMutableAttributedString(string: descriptionLabel.text!)
        let range1 = (descriptionLabel.text! as NSString).range(of: "이용 약관")
        let range2 = (descriptionLabel.text! as NSString).range(of: "개인정보 처리방침")
        
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        descriptionLabel.attributedText = attributedString
    }
    
    private func insertTapActionToDescriptionLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    private func addSubviews() {
        
        view.addSubview(welcomeLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(signUpView)
        view.addSubview(underBar)
        view.addSubview(descriptionLabel)
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
        
        signUpView.anchor(top: buttonsStackView.bottomAnchor, topConstant: 14)
        signUpView.centerX(inView: view)
        
        underBar.anchor(top: signUpView.bottomAnchor, leading: signUpView.leadingAnchor, trailing: signUpView.trailingAnchor, height: 2)
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(28)
            make.centerX.equalTo(view)
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
