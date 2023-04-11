
//  SignInViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

final class SignInViewController: UIViewController {
    // MARK: - Properties
    
    private var signInViewModel = SignInViewModel()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let loginLabel: UILabel = CustomLabel(title: "로그인", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var emailInputView = BasicInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .next, isCancel: true, target: self, textFieldAction: #selector(cancelButtonDidTapped))
    private lazy var passwordInputView = BasicInputView(titleText: "패스워드", placeholder: "비밀번호를 입력해주세요.", keyBoardType: .default, returnType: .done, isFieldSecure: true, target: self, textFieldAction: #selector(secureToggleButtonDidTapped(sender:)))
    private let findPasswordButton = UIButton(type: .custom)
    private let completeButton = BrandButton(title: Constant.done)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInViewModel.bind { [self] credential in
            completeButton.isEnabled = credential.formIsValid
            completeButton.isEnabled ? completeButton.fillIn(title: Constant.done) : completeButton.fillOut(title: Constant.done)
        }
        
        configureViews()
        enableScroll()
        configureCompleteButton()
        configureFindPasswordButton()
        setupNotification()
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
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(loginLabel)
        containerView.addSubview(emailInputView)
        containerView.addSubview(passwordInputView)
        containerView.addSubview(findPasswordButton)
        containerView.addSubview(completeButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(safeArea.snp.height)
            make.width.equalTo(scrollView.snp.width)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(containerView.safeAreaLayoutGuide).offset(20)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel).offset(70)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputView.snp.bottom).offset(6)
            make.trailing.equalTo(passwordInputView)
        }
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
        findPasswordButton.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        findPasswordButton.addTarget(self, action: #selector(findPasswordButtonDidTapped), for: .touchUpInside)
    }
    
    private func configureCompleteButton() {
        
        completeButton.isEnabled = false
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Actioins
    
    @objc
    private func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
        
    @objc
    private func keyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    private func enableScroll() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc
    private func secureToggleButtonDidTapped(sender: UIView) {
        
        let button = passwordInputView.getInputField().rightView as? UIButton
        button?.isSelected.toggle()
        passwordInputView.getInputField().isSecureTextEntry.toggle()
    }
    
    @objc
    private func cancelButtonDidTapped() {
        
        emailInputView.getInputField().text = nil
    }
    
    @objc
    private func didReceiveKeyboardNotification(_ sender: Notification) {
            
        switch sender.name {
            case UIResponder.keyboardWillShowNotification:
                guard let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardFrameRect = keyboardFrame.cgRectValue
            if Constant.screenHeight > 700 {
                UIView.animate(withDuration: 0.3) {
                    self.completeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrameRect.height)
                }
            }
            case UIResponder.keyboardWillHideNotification :
            if Constant.screenHeight > 700 {
                completeButton.transform = .identity
            }
            default : break
        }
    }
    
    @objc
    private func textDidChanged(_ sender: UITextField) {
        
        switch sender.superview {
            case emailInputView:
            signInViewModel.credential.email = emailInputView.getInputField().text
            case passwordInputView:
            signInViewModel.credential.password = passwordInputView.getInputField().text
            default:
                break
        }
    }
    
    @objc
    private func findPasswordButtonDidTapped() {
        
        let findPwVC = FindPasswordViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc
    private func completeButtonDidTapped() {
        signInViewModel.singIn { user in
            guard let userID = user.id else { fatalError("사용자 아이디 없음") }
            guard let nickname = user.nickName else { fatalError("사용자 닉네임 없음") }
            
            KeychainService.shared.create(key: Constant.tempUserId, value: userID)
            KeychainService.shared.create(key: Constant.tempNickname, value: nickname)
            
            if let isEmailCertificated = user.isEmailCertificated, isEmailCertificated {
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
            } else {
                self.navigationController?.pushViewController(MailCheckViewController(), animated: true)
            }
        } _: { error in
            var alert = SimpleAlert(message: "")
            
            switch error {
            case .serverError:
                alert = SimpleAlert(message: Constant.serverErrorMessage)
            case .decodingError:
                alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = 1")
            case .unauthorizedUser:
                alert = SimpleAlert(buttonTitle: Constant.OK, message: "이메일 또는 비밀번호를 확인해주세요 😮", completion: { finished in
                    AppController.shared.deleteUserInformation()
                })
            case .tokenExpired:
                alert = SimpleAlert(buttonTitle: Constant.OK, message: "로그인이 만료되었습니다. 다시 로그인해주세요.", completion: { finished in
                    AppController.shared.deleteUserInformation()
                })
            case .unknownError(let errorCode):
                guard let errorCode = errorCode else { return }
                alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = \(errorCode)")
            default:
                print(#function)
                alert = SimpleAlert(message: Constant.unknownErrorMessage)
            }
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func pullKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
