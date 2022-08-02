//
//  WelcomeViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/02.
//

import UIKit

class WelcomViewController: UIViewController {
    
    private let welcomeLabel = TitleLabel(title: "환영합니다 :)")
    private let kakaoLoginButton = CustomButton(placeholder: "")
    private let naverLoginButton = CustomButton(placeholder: "")
    private let emailLoginButton = CustomButton(placeholder: "이메일로 로그인", isBold: false)
    private let signUpView = BasicInputView(titleText: "회원가입")

    private let buttonsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(buttonsStackView)
        
        addSubviews()
        addArangedSubviewsToStack()
        configureButtons()
        configureStackView()
        configureSignUpView()
        
        addConstraints()
    }
    
    func addSubviews() {
        
        view.addSubview(welcomeLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(signUpView)
    }
    
    func addArangedSubviewsToStack() {
        
        buttonsStackView.addArrangedSubview(kakaoLoginButton)
        buttonsStackView.addArrangedSubview(naverLoginButton)
        buttonsStackView.addArrangedSubview(emailLoginButton)
    }
    
    func configureButtons() {
        kakaoLoginButton.setBackgroundImage(UIImage(named: "kakao"), for: .normal)
        kakaoLoginButton.layer.borderWidth = 0
        
        naverLoginButton.setBackgroundImage(UIImage(named: "naver"), for: .normal)
        naverLoginButton.layer.borderWidth = 0
        
        emailLoginButton.fill()
    }
    
    func configureStackView() {
        
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .vertical
    }
    
    func configureSignUpView() {
        
        signUpView.makeTextBold()
        signUpView.setText(color: UIColor.appColor(.purple))
        signUpView.setSeparator(color: UIColor.appColor(.lightPurple))
        signUpView.stickBarToText()
    }
    
    func addConstraints() {
        
        welcomeLabel.anchor(top: view.topAnchor, topConstant: 130, leading: view.leadingAnchor, leadingConstant: 20)
        buttonsStackView.centerXY(inView: view, yConstant: 50)
        buttonsStackView.anchor(leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
        signUpView.anchor(top: buttonsStackView.bottomAnchor, topConstant: 16)
        signUpView
            .centerX(inView: view)
    }
}
