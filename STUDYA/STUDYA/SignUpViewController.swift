//
//  MemberJoiningViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private var validationCheck1 = false
    private var validationCheck2 = false
    private var validationCheck3 = false
    private var isOverlappedEmail = false
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let titleLabel = CustomLabel(title: "회원가입", tintColor: .titleGeneral, size: 30, isBold: true)
    private lazy var emailInputView = ValidationInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .default, isFieldSecure: false, validationText: "이메일 형식을 올바르게 입력해주세요.", cancelButton: true, target: self, textFieldAction: #selector(clear))
    private lazy var passwordInputView = ValidationInputView(titleText: "비밀번호", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    private lazy var passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "비밀번호가 맞지 않아요.",target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    
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
    
    var bottomConstraint: NSLayoutConstraint!
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)
        containerView.addSubview(doneButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        emailInputView.getInputField().delegate = self
        passwordInputView.getInputField().delegate = self
        passwordCheckInputView.getInputField().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        passwordInputView.getInputField().rightView?.tag = 1
        passwordCheckInputView.getInputField().rightView?.tag = 2
        
        addSubviews()
        
        setScrollView()
        passwordCheckInputView.getValidationLabel().textColor = .systemBackground
        
        enableScroll()
        emailInputView.getInputField().becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    @objc private func clear() {
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
    
    @objc func doneButtonDidTapped() {
        navigationController?.pushViewController(ProfileSettingViewController(), animated: true)
    }
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(safeArea.snp.height)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func enableScroll() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: containerView.topAnchor, topConstant: 40, leading: containerView.leadingAnchor, leadingConstant: 20)
        stackView.anchor(top: titleLabel.bottomAnchor, topConstant: 70,  leading: containerView.leadingAnchor, leadingConstant: 20, trailing: containerView.trailingAnchor, trailingConstant: 20)
        doneButton.anchor(bottom: containerView.bottomAnchor, bottomConstant: 30, leading: containerView.leadingAnchor, leadingConstant: 20, trailing: containerView.trailingAnchor, trailingConstant: 20)
    }
    
    @objc func pullKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
//        var viewFrame = self.view.frame
//
//        viewFrame.size.height -= keyboardSize.height
//
//        let activeField: UITextField? = [emailInputView.getInputField(), passwordInputView.getInputField(), passwordCheckInputView.getInputField()].first { $0.isFirstResponder }
//
//        if let activeField = activeField {
//
//            if !viewFrame.contains(activeField.frame.origin) {
//
//                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - keyboardSize.height)
//
//                scrollView.setContentOffset(scrollPoint, animated: true)
//            }
//        }
    }
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    private func checkDoneButtonPossible() {
        if validationCheck1 == true &&
            validationCheck2 == true &&
            validationCheck3 == true {

            doneButton.isEnabled = true
            doneButton.fillIn(title: "완료")
        } else {
            if doneButton.isEnabled == true {
                doneButton.isEnabled = false
                doneButton.fillOut(title: "완료")
            }
        }
    }
    
    private func validateCheck(_ textField: UITextField) {
        
        switch textField {
        case emailInputView.getInputField():
            
            if let email = textField.text {
                let range = email.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
                validationCheck1 = range != nil ? true : false
                
                if validationCheck1 {
    //                이메일 중복체크하기
    //                completion handler에서 dispatch main queue async 로 isOverlappedEmail 값 전달 후
                    validationCheck1 = isOverlappedEmail ? false : true
                    checkValidation1Label()
                }
            }
        case passwordInputView.getInputField():
            
            if let password = textField.text {
                let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,}", options: .regularExpression)
                validationCheck2 = range != nil ? true : false
            }
        case passwordCheckInputView.getInputField():
            
            if let check = textField.text {
                validationCheck3 = check == passwordInputView.getInputField().text ? true : false
            }
        default: break
        }
    }
    
    private func checkValidation1Label() {
        if validationCheck1 {
            emailInputView.getValidationLabel().textColor = .systemBackground
        } else {
            let text = emailInputView.getInputField().text
            
            emailInputView.getValidationLabel().textColor = text == nil ? UIColor.appColor(.subTitleGeneral) : UIColor.appColor(.highlightDeep)
            emailInputView.getValidationLabel().text = isOverlappedEmail ? "이미 가입된 이메일이에요.😮" : "이메일 형식을 올바르게 입력해주세요."
        }
    }
    
    private func checkValidation2Label() {
        if validationCheck2 {
            passwordInputView.getValidationLabel().textColor = .systemBackground
        } else {
            let text = passwordInputView.getInputField().text
            
            passwordInputView.getValidationLabel().textColor = text == "" ? UIColor.appColor(.subTitleGeneral) : UIColor.appColor(.highlightDeep)
        }
    }
    
    private func checkValidation3Label() {
        if validationCheck3 {
            passwordCheckInputView.getValidationLabel().textColor = .systemBackground
        } else {
            let text = passwordCheckInputView.getInputField().text
            
            passwordCheckInputView.getValidationLabel().textColor = text == "" ? .systemBackground : UIColor.appColor(.highlightDeep)
        }
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailInputView.getInputField():
            emailInputView.setUnderlineColor(as: .brandDark)
        case passwordInputView.getInputField():
            passwordInputView.setUnderlineColor(as: .brandDark)
        case passwordCheckInputView.getInputField():
            passwordCheckInputView.setUnderlineColor(as: .brandDark)
        default:
            break
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputView.getInputField():
            
            validateCheck(textField)
            checkValidation1Label()
            checkDoneButtonPossible()
            
            emailInputView.setUnderlineColor(as: .brandLight)
            
        case passwordInputView.getInputField():
            
            validateCheck(textField)
            validateCheck(passwordCheckInputView.getInputField())
            checkValidation2Label()
            checkValidation3Label()
            checkDoneButtonPossible()
            
            passwordInputView.setUnderlineColor(as: .brandLight)
            
        case passwordCheckInputView.getInputField():
            
            validateCheck(textField)
            checkValidation3Label()
            checkDoneButtonPossible()
            
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
