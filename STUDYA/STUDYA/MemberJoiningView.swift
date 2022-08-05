//
//  MemberJoiningView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class MemberJoiningView: UIView {
    
    private let titleLabel = CustomLabel(title: "회원가입", color: .titleGeneral, isBold: true, size: 30)
    private let emailInputView = ValidationInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .next, isFieldSecure: false, validationText: "이메일 형식을 올바르게 입력해주세요.")
    private let passwordInputView = ValidationInputView(titleText: "비밀번호", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 대문자, 소문자를 포함해주세요")
    private let passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "")
    private lazy var stackView: UIStackView = {
       
        let stackView = UIStackView(frame: .zero)
        
        stackView.addArrangedSubview(emailInputView)
        stackView.addArrangedSubview(passwordInputView)
        stackView.addArrangedSubview(passwordCheckInputView)
        
        stackView.spacing = 40
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.heightAnchor.constraint(equalToConstant: 332).isActive = true //이부분도 계산기 뚜드려서 하드코딩.
        
        return stackView
    }()
    private let doneButton = CustomButton(title: "완료", isBold: true, isFill: false)
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        setConstraints()
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
