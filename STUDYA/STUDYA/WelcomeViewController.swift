//
//  WelcomeViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/02.
//

import UIKit

class WelcomViewController: UIViewController {
    
    private let welcomeLabel = CustomLabel(title: "환영합니다 :)", color: .titleGeneral, isBold: true, size: 30)
    private let kakaoLoginButton = CustomButton(title: "카카오톡으로 로그인")
    private let naverLoginButton = CustomButton(title: "네이버로 로그인")
    private let emailLoginButton = CustomButton(title: "이메일로 로그인")
    private let signUpView = CustomLabel(title: "회원가입", color: .brandThick, isBold: true, size: 16)
    private let underBar = UIView(frame: .zero)
    private let buttonsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(buttonsStackView)
        signUpView.isUserInteractionEnabled = true
        
        addSubviews()
        addArangedSubviewsToStack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButtons()
        configureStackView()
        addConstraints()
        
        underBar.backgroundColor = UIColor.appColor(.brandLight)
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
        
        signUpView.anchor(top: buttonsStackView.bottomAnchor, topConstant: 14)
        signUpView.centerX(inView: view)
        
        underBar.anchor(top: signUpView.bottomAnchor, leading: signUpView.leadingAnchor, trailing: signUpView.trailingAnchor, height: 2)
    }
}
