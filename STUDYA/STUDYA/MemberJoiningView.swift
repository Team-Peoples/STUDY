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
    private var keyboardheight: CGFloat = 0
    private var validationCheck1 = false
    private var validationCheck2 = false
    private var validationCheck3 = false
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        emailInputView.getInputField().delegate = self
        passwordInputView.getInputField().delegate = self
        passwordCheckInputView.getInputField().delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        addSubviews()

        passwordInputView.getInputField().rightView?.tag = 1
        passwordCheckInputView.getInputField().rightView?.tag = 2
        
        doneButton.isEnabled = false
        
        emailInputView.getInputField().becomeFirstResponder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .systemBackground
        setConstraints()
    }

    @objc private func erase() {
        emailInputView.getInputField().text = ""
    }

    @objc private func toggleIsSecure(sender: UIButton) {
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
    
    @objc private func didReceiveKeyboardNotification(_ sender: Notification) {
            switch sender.name {
                case UIResponder.keyboardWillShowNotification:
                print("willshow")
                if let keyboardFrame:NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                       let keyboardRectangle = keyboardFrame.cgRectValue

                    keyboardheight = keyboardRectangle.height
                    }

                case UIResponder.keyboardWillHideNotification :
                    print("willhide")
                    self.transform = .identity

                default : break
            }
    }
}

extension MemberJoiningView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailInputView.getInputField():
            emailInputView.setSeparator(color: .brandThick)
        case passwordInputView.getInputField():
            passwordInputView.setSeparator(color: .brandThick)
        case passwordCheckInputView.getInputField():
            passwordCheckInputView.setSeparator(color: .brandThick)
            print(self.keyboardheight)
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(translationX: 0, y: -self.keyboardheight)
            }
        default:
            break
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputView.getInputField():
            
            if let email = textField.text, let _ = email.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression) {
                
                validationCheck1 = true
                emailInputView.getValidationLabel().textColor = .systemBackground
                
                if validationCheck1 == validationCheck2 &&
                    validationCheck2 == validationCheck3 &&
                    validationCheck3 == true &&
                    doneButton.isEnabled == false {

                    doneButton.isEnabled.toggle()
                    doneButton.fillIn(title: "완료")
                }
                
            } else {
                validationCheck1 = false
                
                emailInputView.getValidationLabel().text = "이메일 형식을 올바르게 입력해주세요."
                emailInputView.getValidationLabel().textColor = .systemRed
                
                if doneButton.isEnabled == true {
                    doneButton.isEnabled.toggle()
                    doneButton.fillOut(title: "완료")
                }
            }
            emailInputView.setSeparator(color: .brandLight)
            
        case passwordInputView.getInputField():
            
            if let password = textField.text, let _ = password.range(of: "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,}", options: .regularExpression) {
                
                validationCheck2 = true
                passwordInputView.getValidationLabel().textColor = .systemBackground
                
                if validationCheck1 == validationCheck2 &&
                    validationCheck2 == validationCheck3 &&
                    validationCheck3 == true &&
                    doneButton.isEnabled == false {

                    doneButton.isEnabled.toggle()
                    doneButton.fillIn(title: "완료")
                }
            } else {
                
                validationCheck2 = false
                
                passwordInputView.getValidationLabel().text = "특수문자, 대문자, 소문자를 포함해주세요"
                passwordInputView.getValidationLabel().textColor = .systemRed
                
                if doneButton.isEnabled == true {
                    doneButton.isEnabled.toggle()
                    doneButton.fillOut(title: "완료")
                }
            }
            passwordInputView.setSeparator(color: .brandLight)
            
        case passwordCheckInputView.getInputField():
            
            if textField.text == passwordInputView.getInputField().text {
                
                validationCheck3 = true
                passwordCheckInputView.getValidationLabel().textColor = .systemBackground
                
                if validationCheck1 == validationCheck2 &&
                    validationCheck2 == validationCheck3 &&
                    validationCheck3 == true &&
                    doneButton.isEnabled == false {

                    doneButton.isEnabled.toggle()
                    doneButton.fillIn(title: "완료")
                }
            } else {
                
                validationCheck3 = false
                
                passwordCheckInputView.getValidationLabel().text = "비밀번호가 맞지 않아요"
                passwordCheckInputView.getValidationLabel().textColor = .systemRed
                
                if doneButton.isEnabled == true {
                    doneButton.isEnabled.toggle()
                    doneButton.fillOut(title: "완료")
                }
            }
            
            passwordCheckInputView.setSeparator(color: .brandLight)
        default:
            break
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputView.getInputField():
            passwordInputView.getInputField().becomeFirstResponder()
        case passwordInputView.getInputField():
            passwordCheckInputView.getInputField().becomeFirstResponder()
        case passwordCheckInputView.getInputField():
            passwordCheckInputView.getInputField().resignFirstResponder()
        default:
            break
        }
        return true
    }
}
