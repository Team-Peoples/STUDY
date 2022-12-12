//
//  SignUpViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/05.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private var emailValidationOkay = false
    private var passwordValidationOkay = false
    private var passwordCheckOkay = false
    private var isExistingEmail = false
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let titleLabel = CustomLabel(title: "회원가입", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var emailInputView = ValidationInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .default, isFieldSecure: false, validationText: "이메일 형식을 올바르게 입력해주세요.", cancelButton: true, target: self, textFieldAction: #selector(clear))
    private lazy var passwordInputView = ValidationInputView(titleText: "비밀번호", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    private lazy var passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "비밀번호가 맞지 않아요.",target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
    
    private lazy var emailInputField = emailInputView.getInputField()
    private lazy var emailValidationLabel = emailInputView.getValidationLabel()
    private lazy var passwordInputField = passwordInputView.getInputField()
    private lazy var passwordValidationLabel = passwordInputView.getValidationLabel()
    private lazy var checkInputField = passwordCheckInputView.getInputField()
    private lazy var checkValidationLabel = passwordCheckInputView.getValidationLabel()
    
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
    
    private let doneButton = BrandButton(title: "완료", isBold: true, isFill: false)

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
        
        emailInputField.delegate = self
        passwordInputField.delegate = self
        checkInputField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        passwordInputField.rightView?.tag = 1
        checkInputField.rightView?.tag = 2
        
        addSubviews()
        
        setScrollView()
        checkValidationLabel.textColor = .systemBackground
        
        enableScroll()
        emailInputField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setConstraints()
    }
    
    @objc private func clear() {
        emailInputField.text = ""
    }
    
    @objc private func toggleIsSecure(sender: UIButton) {
        
        if sender.tag == 1 {
            
            sender.isSelected.toggle()
            passwordInputField.isSecureTextEntry = passwordInputField.isSecureTextEntry ? false : true
        } else {
            
            sender.isSelected.toggle()
            checkInputField.isSecureTextEntry = checkInputField.isSecureTextEntry ? false : true
        }
    }
    
    @objc func doneButtonDidTapped() {
        let nextVC = ProfileSettingViewController()
        
        nextVC.email = emailInputField.text
        nextVC.password = passwordInputField.text
        nextVC.passwordCheck = checkInputField.text
        
        navigationController?.pushViewController(ProfileSettingViewController(), animated: true)
    }
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
    
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
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
//        let activeField: UITextField? = [emailInputField, passwordInputField, checkInputField].first { $0.isFirstResponder }
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
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
    
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
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
    
    private func checkDoneButtonPossible() {
        if emailValidationOkay &&
            passwordValidationOkay &&
            passwordCheckOkay {

            doneButton.isEnabled = true
            doneButton.fillIn(title: "완료")
        } else {
            if doneButton.isEnabled {
                doneButton.isEnabled = false
                doneButton.fillOut(title: "완료")
            }
        }
    }
    
    private func validateCheck(_ textField: UITextField) {
        
        switch textField {
        case emailInputField:
            
            if let email = textField.text {
                let range = email.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
                emailValidationOkay = range != nil ? true : false
                
                if emailValidationOkay {
    //                이메일 중복체크하기
    //                completion handler에서 dispatch main queue async 로 isOverlappedEmail 값 전달 후
                    emailValidationOkay = isExistingEmail ? false : true
                    checkValidation1Label()
                }
            }
        case passwordInputField:

            if let password = textField.text {
                let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!.?@#$%^&*()_+=-]).{5,}", options: .regularExpression)
                passwordValidationOkay = range != nil ? true : false
            }
        case checkInputField:
            
            if let check = textField.text {
                passwordCheckOkay = check == passwordInputField.text ? true : false
            }
        default: break
        }
    }
    
    private func checkValidation1Label() {
        if emailValidationOkay {
            emailValidationLabel.textColor = .systemBackground
        } else {
            let text = emailInputField.text
            
            emailValidationLabel.textColor = text == nil ? UIColor.appColor(.ppsGray1) : UIColor.appColor(.subColor1)
            emailValidationLabel.text = isExistingEmail ? "이미 가입된 이메일이에요.😮" : "이메일 형식을 올바르게 입력해주세요."
        }
    }
    
    private func checkValidation2Label() {
        if passwordValidationOkay {
            passwordValidationLabel.textColor = .systemBackground
        } else {
            let text = passwordInputField.text
            
            passwordValidationLabel.textColor = text == "" ? UIColor.appColor(.ppsGray1) : UIColor.appColor(.subColor1)
        }
    }
    
    private func checkValidation3Label() {
        if passwordCheckOkay {
            checkValidationLabel.textColor = .systemBackground
        } else {
            let text = checkInputField.text
            
            checkValidationLabel.textColor = text == "" ? .systemBackground : UIColor.appColor(.subColor1)
        }
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailInputField:
            emailInputView.setUnderlineColor(as: .keyColor1)
        case passwordInputField:
            passwordInputView.setUnderlineColor(as: .keyColor1)
        case checkInputField:
            passwordCheckInputView.setUnderlineColor(as: .keyColor1)
        default: break
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputField:
            
            validateCheck(textField)
            checkValidation1Label()
            checkDoneButtonPossible()
            
            emailInputView.setUnderlineColor(as: .keyColor3)
            
        case passwordInputField:
            
            validateCheck(textField)
            validateCheck(checkInputField)
            checkValidation2Label()
            checkValidation3Label()
            checkDoneButtonPossible()
            
            passwordInputView.setUnderlineColor(as: .keyColor3)
            
        case checkInputField:
            
            validateCheck(textField)
            checkValidation3Label()
            checkDoneButtonPossible()
            
            passwordCheckInputView.setUnderlineColor(as: .keyColor3)
        default: break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputField:
            passwordInputField.becomeFirstResponder()
        case passwordInputField:
            checkInputField.becomeFirstResponder()
        case checkInputField:
            checkInputField.resignFirstResponder()
        default: break
        }
        return true
    }
}
