//
//  MemberJoiningViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class MemberJoiningViewController: UIViewController {
    
    private let titleLabel = CustomLabel(title: "회원가입", tintColor: .titleGeneral, size: 30, isBold: true)
    private lazy var emailInputView = ValidationInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .default, isFieldSecure: false, validationText: "이메일 형식을 올바르게 입력해주세요.", cancelButton: true, target: self, textFieldAction: #selector(clear))
    private lazy var passwordInputView = ValidationInputView(titleText: "비밀번호", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 대문자, 소문자를 포함해주세요", target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    private lazy var passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "",target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    
    weak var delegate: NavigationControllerDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailInputView.getInputField().delegate = self
        passwordInputView.getInputField().delegate = self
        passwordCheckInputView.getInputField().delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(doneButton)
        
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        emailInputView.getInputField().becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.backgroundColor = .systemBackground
        setConstraints()
    }
    
    @objc private func clear() {
        emailInputView.getInputField().text = ""
    }

    @objc private func toggleIsSecure(sender: UIButton) {
        switch sender.superview {
            case passwordInputView:
                sender.isSelected.toggle()
                passwordInputView.toggleSecureText()
            case passwordCheckInputView:
                sender.isSelected.toggle()
                passwordCheckInputView.toggleSecureText()
            default:
                return
        }
    }
    
    @objc func doneButtonDidTapped() {
        let profileSettingVC = ProfileSettingViewController()
        delegate?.push(profileSettingVC)
    }

    private func setConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 20)
        stackView.anchor(top: titleLabel.bottomAnchor, topConstant: 70,  leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 30, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
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
                    view.transform = .identity

                default : break
            }
    }
}


extension MemberJoiningViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("😅")
        switch textField {
        case emailInputView.getInputField():
            emailInputView.setUnderlineColor(as: .brandThick)
        case passwordInputView.getInputField():
            passwordInputView.setUnderlineColor(as: .brandThick)
        case passwordCheckInputView.getInputField():
            passwordCheckInputView.setUnderlineColor(as: .brandThick)
            print(self.keyboardheight)
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -self.keyboardheight)
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
                
                if validationCheck1 == true &&
                    validationCheck2 == true &&
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
            emailInputView.setUnderlineColor(as: .brandLight)
            
        case passwordInputView.getInputField():
            
            if let password = textField.text, let _ = password.range(of: "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,}", options: .regularExpression) {
                
                validationCheck2 = true
                passwordInputView.getValidationLabel().textColor = .systemBackground
                
                if validationCheck1 == true &&
                    validationCheck2 == true &&
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
            passwordInputView.setUnderlineColor(as: .brandLight)
            
        case passwordCheckInputView.getInputField():
            
            if textField.text == passwordInputView.getInputField().text {
                
                validationCheck3 = true
                passwordCheckInputView.getValidationLabel().textColor = .systemBackground
                
                if validationCheck1 == true &&
                    validationCheck2 == true &&
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
            
            passwordCheckInputView.setUnderlineColor(as: .brandLight)
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

extension MemberJoiningViewController: NavigationControllerDelegate {
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

protocol NavigationControllerDelegate: NSObject {
    func push(_ vc: UIViewController)
}
