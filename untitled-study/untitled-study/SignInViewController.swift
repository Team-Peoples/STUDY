//
//  SignInViewController.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/07/31.
//

import UIKit

class SignInViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var emailInputView: SignUpInputView = {
        let v = SignUpInputView(titleText: "이메일", placeholderText: "email@gmail.com", keyBoardType: .emailAddress, returnType: .go, validationLText: "이메일을 입력하시오")
        return v
    }()
    
    private lazy var pwInputView: BasicInputView = {
        let v = BasicInputView(titleText: "패스워드", placeholderText: "패스워드를 입력하시오", keyBoardType: .default, returnType: .done, isSecure: true)
        return v
    }()

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(emailInputView)
        view.addSubview(pwInputView)
        
        setConstraints()
    }
    //MARK: - Setting Constraints
    
    func setConstraints() {
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        pwInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
    }
}
