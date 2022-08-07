//
//  MemberJoiningView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class MemberJoiningView: UIView {
    
    private let titleLabel = CustomLabel(title: "회원가입", color: .titleGeneral, isBold: true, size: 30)
    private lazy var emailInputView = ValidationInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .next, isFieldSecure: false, validationText: "이메일 형식을 올바르게 입력해주세요.", isEraseButton: true, target: self, action: #selector(erase))
    private lazy var passwordInputView = ValidationInputView(titleText: "비밀번호", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 대문자, 소문자를 포함해주세요", isEraseButton: false, target: self, action: #selector(toggleIsSecure))
    private lazy var passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "", isEraseButton: false, target: self, action: #selector(toggleIsSecure))
    private lazy var stackView: UIStackView = {
       
        let stackView = UIStackView(frame: .zero)
        
        stackView.addArrangedSubview(emailInputView)
        stackView.addArrangedSubview(passwordInputView)
        stackView.addArrangedSubview(passwordCheckInputView)
        
        stackView.spacing = 40
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        return stackView
    }()
    private let doneButton = CustomButton(title: "완료", isBold: true, isFill: false)
    private var eyeButton: UIButton?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        
        passwordInputView.getInputField().rightView?.tag = 1
        passwordCheckInputView.getInputField().rightView?.tag = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        setConstraints()
    }
    
    @objc func erase() {
        emailInputView.getInputField().text = ""
    }
    
    @objc func toggleIsSecure(sender: UIButton) {
        if sender.tag == 1 {
            
            sender.isSelected.toggle()
            passwordInputView.getInputField().isSecureTextEntry = passwordInputView.getInputField().isSecureTextEntry == true ? false : true
        } else {
            
            sender.isSelected.toggle()
            passwordCheckInputView.getInputField().isSecureTextEntry = passwordCheckInputView.getInputField().isSecureTextEntry == true ? false : true
        }
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(doneButton)
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: leadingAnchor, leadingConstant: 20)
        stackView.anchor(top: titleLabel.bottomAnchor, topConstant: 70,  leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        doneButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, bottomConstant: 30, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
}


