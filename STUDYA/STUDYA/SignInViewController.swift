
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
    private let completeButton = BrandButton(title: "완료")
    
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
                signInViewModel.email = emailInputView.getInputField().text
            case passwordInputView:
                signInViewModel.password = passwordInputView.getInputField().text
            default:
                break
        }
        
        buttonStateUpdate()
    }
    
    @objc private func findPasswordButtonDidTapped() {
        
        let findPwVC = FindPasswordViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc private func completeButtonDidTapped() {
        
        guard let id = emailInputView.getInputField().text else { return }
        guard let pw = passwordInputView.getInputField().text else { return }
        
        Network.shared.signIn(id: id, pw: pw) { result in
            switch result {
            case .success(let user):
                print(user)
                UserDefaults.standard.set(true, forKey: Const.isLoggedin)
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func buttonStateUpdate() {
        completeButton.isEnabled = signInViewModel.formIsValid
        completeButton.isEnabled ? completeButton.fillIn(title: "완료") : completeButton.fillOut(title: "완료")
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
