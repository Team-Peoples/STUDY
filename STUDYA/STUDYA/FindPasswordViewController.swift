//
//  FindPasswordViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/02.
//

import UIKit
import SnapKit

class FindPasswordViewController: UIViewController {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(title: "가입하신 이메일을 \n입력해주세요.", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var emailInputView = BasicInputView(titleText: "이메일", placeholder: "studya@gmail.com", keyBoardType: .emailAddress, returnType: .done, isFieldSecure: false, isCancel: true, target: self, textFieldAction: #selector(cancelButtonDidTapped))
    private let completeButton = CustomButton(title: "다음")
    
    // MARK: - Actions
    
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
    
    @objc private func completeButtonDidTapped() {
        guard let text = emailInputView.getInputField().text else { return }
        if text.isEmpty {
            let okAlert = SimpleAlert(message: "가입된 이메일이\n아니에요 😮")
            present(okAlert, animated: true)
        } else {
            let nextVC = FindPasswordCompleteViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func cancelButtonDidTapped() {
        emailInputView.getInputField().text = nil
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureTextFieldDelegateAndNotification()
        configureCompleteButton()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - configure Views
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(emailInputView)
//        view.addSubview(emailTextField)
        view.addSubview(completeButton)
    }
    
    private func configureTextFieldDelegateAndNotification() {
        emailInputView.getInputField().delegate = self
        emailInputView.getInputField().becomeFirstResponder()
    }
    
    private func configureCompleteButton() {
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(160)
            make.leading.equalTo(view).offset(20)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

// MARK: - UITextFieldDelegate

extension FindPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        emailInputView.setUnderlineColor(as: .keyColor1)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        emailInputView.setUnderlineColor(as: .keyColor3)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completeButtonDidTapped()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
