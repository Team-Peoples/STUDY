
//  SignInViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit
import SnapKit

final class SignInViewController: UIViewController {
    // MARK: - Properties
    
    private var signInViewModel = SignInViewModel()
    
    private let loginLabel: UILabel = CustomLabel(title: "로그인", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var emailInputView = BasicInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .next, isCancel: true, target: self, textFieldAction: #selector(cancelButtonDidTapped))
    private lazy var passwordInputView = BasicInputView(titleText: "패스워드", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, target: self, textFieldAction: #selector(secureToggleButtonDidTapped(sender:)))
    private let findPasswordButton = UIButton(type: .custom)
    private let completeButton = BrandButton(title: Const.done)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInViewModel.bind { [self] credential in
            completeButton.isEnabled = credential.formIsValid
            completeButton.isEnabled ? completeButton.fillIn(title: Const.done) : completeButton.fillOut(title: Const.done)
        }
        
        configureViews()
        configureCompleteButton()
        configureFindPasswordButton()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTextFieldDelegate()
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
    
    private func configureTextFieldDelegate() {
        
        emailInputView.getInputField().delegate = self
        emailInputView.getInputField().becomeFirstResponder()
        emailInputView.getInputField().addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
       
        passwordInputView.getInputField().delegate = self
        passwordInputView.getInputField().addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    private func configureFindPasswordButton() {
        
        findPasswordButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
        findPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        findPasswordButton.setTitle("비밀번호를 잊으셨나요", for: .normal)
        findPasswordButton.addTarget(self, action: #selector(findPasswordButtonDidTapped), for: .touchUpInside)
    }
    
    private func configureCompleteButton() {
        
        completeButton.isEnabled = false
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Actioins
    
    @objc private func secureToggleButtonDidTapped(sender: UIView) {
        
        let button = passwordInputView.getInputField().rightView as? UIButton
        button?.isSelected.toggle()
        passwordInputView.getInputField().isSecureTextEntry.toggle()
    }
    
    @objc private func cancelButtonDidTapped() {
        
        emailInputView.getInputField().text = nil
    }
    
    @objc private func didReceiveKeyboardNotification(_ sender: Notification) {
            
        switch sender.name {
            case UIResponder.keyboardWillShowNotification:
                guard let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardFrameRect = keyboardFrame.cgRectValue
                
                UIView.animate(withDuration: 0.3) {
                    self.completeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrameRect.height + 16)
                }
                
            case UIResponder.keyboardWillHideNotification :
                completeButton.transform = .identity
                
            default : break
        }
    }
    
    @objc private func textDidChanged(_ sender: UITextField) {
        
        switch sender.superview {
            case emailInputView:
            signInViewModel.credential.email = emailInputView.getInputField().text
            case passwordInputView:
            signInViewModel.credential.password = passwordInputView.getInputField().text
            default:
                break
        }
    }
    
    @objc private func findPasswordButtonDidTapped() {
        
        let findPwVC = FindPasswordViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc private func completeButtonDidTapped() {
        signInViewModel.singIn { user in
            guard let userID = user.id else { fatalError("사용자 아이디 없음") }
            guard let nickname = user.nickName else { fatalError("사용자 닉네임 없음")}
            
            KeyChain.create(key: Const.tempUserId, value: userID)
            KeyChain.create(key: Const.tempNickname, value: nickname)
            print("키체인에 저장")
            
            if let isEmailCertificated = user.isEmailCertificated, isEmailCertificated {
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
            } else {
                self.navigationController?.pushViewController(MailCheckViewController(), animated: true)
            }
        } _: { error in
            var alert = SimpleAlert(message: "")
            
            switch error {
            case .serverError:
                alert = SimpleAlert(message: Const.serverErrorMessage)
            case .decodingError:
                alert = SimpleAlert(message: Const.unknownErrorMessage + " code = 1")
            case .unauthorizedUser:
                alert = SimpleAlert(buttonTitle: Const.OK, message: "이메일 또는 비밀번호를 확인해주세요 😮", completion: { finished in
                    AppController.shared.deleteUserInformation()
                })
            case .tokenExpired:
                alert = SimpleAlert(buttonTitle: Const.OK, message: "로그인이 만료되었습니다. 다시 로그인해주세요.", completion: { finished in
                    AppController.shared.deleteUserInformation()
                })
            case .unknownError(let errorCode):
                guard let errorCode = errorCode else { return }
                alert = SimpleAlert(message: Const.unknownErrorMessage + " code = \(errorCode)")
            default:
                print(#function)
                alert = SimpleAlert(message: Const.unknownErrorMessage)
            }
            
            self.present(alert, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel).offset(70)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
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
                
                emailInputView.setUnderlineColor(as: .keyColor1)
            case passwordInputView:
                
                passwordInputView.setUnderlineColor(as: .keyColor1)
                
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
                
                emailInputView.setUnderlineColor(as: .keyColor3)
            case passwordInputView:
                
                passwordInputView.setUnderlineColor(as: .keyColor3)
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
                
                if completeButton.isEnabled {
                    completeButtonDidTapped()
                } else {
                    let alert = SimpleAlert(message: "이메일 또는 비밀번호를 확인해주세요 😮")
                    present(alert, animated: true)
                }
            default:
                return true
        }
        return true
    }
}
