//
//  SignInViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    // MARK: - Properties
    
    private let loginLabel: UILabel = TitleLabel(title: "로그인")
    private lazy var emailTextField = CustomTextField(placeholder: "studya@email.com", keyBoardType: .emailAddress, returnType: .next)
    private let passwordTextField = CustomTextField(placeholder: "비밀번호를 입력해주새요.", keyBoardType: .default, returnType: .done, isSecure: true)
    private let emailInputView = BasicInputView(titleText: "이메일")
    private let passwordInputView = BasicInputView(titleText: "패스워드")
    private lazy var completeButton: CustomButton = {
        let btn = CustomButton(placeholder: "완료")
        btn.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var pwSecureToggleButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "eye-close"), for: .normal)
        btn.setImage(UIImage(named: "eye-open"), for: .selected)
        btn.addTarget(self, action: #selector(secureToggleButtonDidTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private var loginViewModel = LoginViewModel()
    
    // MARK: - Actioins
    
    @objc func secureToggleButtonDidTapped(sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func didReceiveKeyboardNotification(_ sender: Notification) {
        switch sender.name {
            case UIResponder.keyboardWillShowNotification:
                guard let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardRectangle = keyboardFrame.cgRectValue
                UIView.animate(withDuration: 0.3) {
                    self.completeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 30)
                }
                
            case UIResponder.keyboardWillHideNotification :
                completeButton.transform = .identity
                
            default : break
        }
    }
    
    @objc func textDidChanged(_ sender: UITextField) {
        switch sender {
            case emailTextField:
                loginViewModel.email = emailTextField.text
            case passwordTextField:
                loginViewModel.password = passwordTextField.text
            default:
                break
        }
        
        formUpdate()
    }
    
    @objc func completeButtonDidTapped() {
        print("완료버튼")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "Vector 42"), style: .done, target: self, action: nil)
        
        configureViews()
        configureTextFieldDelegateAndNotification()
        
        setConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(loginLabel)
        view.addSubview(emailInputView)
        view.addSubview(emailTextField)
        view.addSubview(passwordInputView)
        view.addSubview(passwordTextField)
        view.addSubview(pwSecureToggleButton)
        view.addSubview(completeButton)
    }
    
    func configureTextFieldDelegateAndNotification() {
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        emailTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(130)
            make.leading.equalTo(view).offset(20)
        }
    
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel).offset(70)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(emailInputView).offset(-6)
            make.leading.trailing.equalTo(emailInputView)
        }
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordInputView).offset(-6)
            make.leading.trailing.equalTo(passwordInputView)
        }
        
        pwSecureToggleButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordInputView)
            make.bottom.equalTo(passwordInputView).offset(-15)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                emailInputView.setSeparator(color: UIColor.appColor(.purple))
                return true
            case passwordTextField:
                passwordInputView.setSeparator(color: UIColor.appColor(.purple))
                NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                return true
            default:
                return true
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                emailInputView.setSeparator(color: UIColor.appColor(.defaultGray))
                return true
            case passwordTextField:
                passwordInputView.setSeparator(color: UIColor.appColor(.defaultGray))
                return true
            default:
                return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
                return true
            case passwordTextField:
                return true
            default:
                return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range.length, range.location)
        return true
    }
}

extension SignInViewController: formViewModel {
    func formUpdate() {
        completeButton.isEnabled = loginViewModel.formIsValid
        completeButton.backgroundColor = loginViewModel.backgroundColor
        completeButton.setTitleColor(loginViewModel.titleColor, for: .normal)
    }
}
