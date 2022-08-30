//
//  AccountManagementViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/30.
//

import UIKit

final class AccountManagementViewController: UIViewController {
    
    internal var nickName: String?  {
        didSet {
            nickNameFeild.text = nickName
        }
    }
    internal var email: String? {
        didSet {
            emailLabel.text = email
        }
    }
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let profileImageView = ProfileImageSelectorView(size: 80)
    private let nickNameFeild: UITextField = {
       
        let field = UITextField(frame: .zero)
        field.font = .boldSystemFont(ofSize: 16)
        
        return field
    }()
    private let separator: UIView = {
       
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.appColor(.brandDark)
        
        return view
    }()
    private let emailLabel = CustomLabel(title: "", tintColor: .subTitleGeneral, size: 12)
//    private let oldPWLabel = CustomLabel(title: "기존 비밀번호", tintColor: .subTitleGeneral, size: 12)
//    private let oldPWTextView = GrayBorderTextView(placeholder: "", maxCharactersNumber: nil, height: 36)
//    private let newPWLabel = CustomLabel(title: "새 비밀번호", tintColor: .subTitleGeneral, size: 12)
//    private let newPWTextView = GrayBorderTextView(placeholder: "", maxCharactersNumber: nil, height: 36)
    
//    private lazy var emailInputView = BasicInputView(titleText: "기존 비밀번호", fontSize: 13, titleColor: .subTitleGeneral, titleBottomPadding: 10, placeholder: "", keyBoardType: .default, returnType: .next, isFieldSecure: true, isCancel: true, target: self, textFieldAction: #selector(clear))
//    private lazy var passwordInputView = ValidationInputView(titleText: "새 비밀번호", fontSize: 13, titleColor: .subTitleGeneral, titleBottomPadding: 10, placeholder: "", keyBoardType: .default, returnType: .next, isFieldSecure: true, validationText: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
//    private lazy var passwordCheckInputView = ValidationInputView(titleText: "비밀번호 확인", fontSize: 13, titleColor: .subTitleGeneral, titleBottomPadding: 10, placeholder: "", keyBoardType: .default, returnType: .done, isFieldSecure: true, validationText: "",target: self, textFieldAction: #selector(toggleIsSecure(sender: )))
//    private lazy var stackView: UIStackView = {
//
//        let stackView = UIStackView(frame: .zero)
//
//        stackView.addArrangedSubview(emailInputView)
//        stackView.addArrangedSubview(passwordInputView)
//        stackView.addArrangedSubview(passwordCheckInputView)
//
//        stackView.spacing = 40
//        stackView.distribution = .fillEqually
//        stackView.axis = .vertical
//
//        return stackView
//    }()
    private let logoutLabel = CustomLabel(title: "로그아웃", tintColor: .descriptionGeneral, size: 16)
    private let separator2 = CustomLabel(title: "|", tintColor: .descriptionGeneral, size: 16)
    private let leftLabel = CustomLabel(title: "회원탈퇴", tintColor: .descriptionGeneral, size: 16)
    private lazy var beneathStackView: UIStackView = {
        
        let stackView = UIStackView(frame: .zero)
        
        logoutLabel.isUserInteractionEnabled = true
        leftLabel.isUserInteractionEnabled = true
        
        logoutLabel.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(logout)))
        leftLabel.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(leaveApp)))
        
        stackView.addArrangedSubview(logoutLabel)
        stackView.addArrangedSubview(separator2)
        stackView.addArrangedSubview(leftLabel)
        
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "계정관리"
        view.backgroundColor = .systemBackground
        
        setScrollView()
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.centerX(inView: containerView)
        profileImageView.anchor(top: containerView.topAnchor, topConstant: 40)
        nickNameFeild.centerX(inView: containerView)
        nickNameFeild.anchor(top: profileImageView.bottomAnchor, topConstant: 24)
        separator.centerX(inView: containerView)
        separator.anchor(top: nickNameFeild.bottomAnchor, width: 170, height: 2)
        emailLabel.centerX(inView: containerView)
        emailLabel.anchor(top: separator.bottomAnchor, topConstant: 5)
//        stackView.anchor(top: emailLabel.bottomAnchor, topConstant: 39, leading: containerView.leadingAnchor, leadingConstant: 20, trailing: containerView.trailingAnchor, trailingConstant: 20)
        beneathStackView.centerX(inView: containerView)
//        beneathStackView.anchor(top: stackView.bottomAnchor, topConstant: 70)
//        beneathStackView.anchor(top: stackView.bottomAnchor, topConstant: 70, leading: containerView.leadingAnchor, leadingConstant: 120)
    }
    
    @objc private func clear() {
//        emailInputView.getInputField().text = ""
    }
    
    @objc private func toggleIsSecure(sender: UIButton) {
        
        if sender.tag == 1 {
            
            sender.isSelected.toggle()
//            passwordInputView.getInputField().isSecureTextEntry = passwordInputView.getInputField().isSecureTextEntry == true ? false : true
        } else {
            
            sender.isSelected.toggle()
//            passwordCheckInputView.getInputField().isSecureTextEntry = passwordCheckInputView.getInputField().isSecureTextEntry == true ? false : true
        }
    }
    
    @objc private func logout() {
        print(#function)
    }
    
    @objc private func leaveApp() {
        navigationController?.pushViewController(ByeViewController(), animated: true)
    }
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        scrollView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(safeArea.snp.height)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(nickNameFeild)
        view.addSubview(separator)
        view.addSubview(emailLabel)
//        view.addSubview(stackView)
        view.addSubview(beneathStackView)
    }
}
