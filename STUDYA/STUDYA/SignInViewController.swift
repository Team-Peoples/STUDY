
//  SignInViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    // MARK: - Properties
    
    private let loginLabel: UILabel = CustomLabel(title: "로그인", tintColor: .titleGeneral, size: 30, isBold: true)
    private lazy var emailInputView = BasicInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .next, isCancel: true, target: self, textFieldAction: #selector(cancelButtonDidTapped))
    private lazy var passwordInputView = BasicInputView(titleText: "패스워드", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, target: self, textFieldAction: #selector(secureToggleButtonDidTapped(sender:)))
    private let findPasswordButton = UIButton(type: .custom)
    private let completeButton = CustomButton(title: "완료")
    private var loginViewModel = LoginViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureCompleteButton()
        configureFindPasswordButton()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTextFieldDelegateAndNotification()
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
        view.addSubview(passwordInputView)
        view.addSubview(findPasswordButton)
        view.addSubview(completeButton)
    }
    
    private func configureTextFieldDelegateAndNotification() {
        
        emailInputView.getInputField().delegate = self
        emailInputView.getInputField().becomeFirstResponder()
        emailInputView.getInputField().addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
       
        passwordInputView.getInputField().delegate = self
        passwordInputView.getInputField().addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    private func configureFindPasswordButton() {
        
        findPasswordButton.setTitleColor(UIColor.appColor(.descriptionGeneral), for: .normal)
        findPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        findPasswordButton.setTitle("비밀번호를 잊으셨나요", for: .normal)
        findPasswordButton.addTarget(self, action: #selector(findPasswordButtonDidTapped), for: .touchUpInside)
    }
    
    private func configureCompleteButton() {
        
        completeButton.isUserInteractionEnabled = false
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Actioins
    
    @objc private func secureToggleButtonDidTapped(sender: UIView) {
        
        let button = passwordInputView.getInputField().rightView as? UIButton
        button?.isSelected.toggle()
        passwordInputView.toggleSecureText()
    }
    
    @objc private func cancelButtonDidTapped() {
        emailInputView.getInputField().text = nil
    }
    
    @objc private func didReceiveKeyboardNotification(_ sender: Notification) {
        
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
    
    @objc private func textDidChanged(_ sender: UITextField) {
        // 구조체를 하나만 생성하는게 맞는지...모르겠네..
        
        switch sender.superview {
            case emailInputView:
                loginViewModel.email = emailInputView.getInputField().text
            case passwordInputView:
                loginViewModel.password = passwordInputView.getInputField().text
            default:
                break
        }
        
        formUpdate()
    }
    
    @objc private func findPasswordButtonDidTapped() {
        
        let findPwVC = FindPasswordViewController()
        navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc private func completeButtonDidTapped() {
        
        self.dismiss(animated: true)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(130)
            make.leading.equalTo(view).offset(20)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel).offset(70)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        //        pwSecureToggleButton.snp.makeConstraints { make in
        //            make.trailing.equalTo(passwordInputView)
        //            make.bottom.equalTo(passwordInputView).offset(-15)
        //        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputView.snp.bottom).offset(6)
            make.trailing.equalTo(passwordInputView)
        }
    }
}
// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.superview {
            case emailInputView:
                
                emailInputView.setUnderlineColor(as: .brandDark)
            case passwordInputView:
                
                passwordInputView.setUnderlineColor(as: .brandDark)
                
                NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            default:
                return true
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.superview {
            case emailInputView:
                
                emailInputView.setUnderlineColor(as: .brandLight)
            case passwordInputView:
                
                passwordInputView.setUnderlineColor(as: .brandLight)
            default:
                return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.superview {
            case emailInputView:
                
                passwordInputView.getInputField().becomeFirstResponder()
            case passwordInputView:
                
                completeButtonDidTapped()
            default:
                return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension SignInViewController: formViewModel {
    func formUpdate() {
        completeButton.isUserInteractionEnabled = loginViewModel.formIsValid
        completeButton.isUserInteractionEnabled ? completeButton.fillIn(title: "완료") : completeButton.fillOut(title: "완료")
        
    }
}
