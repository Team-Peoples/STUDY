//
//  ProfileSettingViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/03.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    private let nickNameInputView = SignUpInputView(titleText: "닉네임을 설정해주세요", validationLText: "*닉네임은 프로필에서 언제든 변경할 수 있어요")
    private let nickNameTextField
    = CustomTextField(placeholder: "한글/영어/숫자를 사용할 수 있어요", keyBoardType: .default, returnType: .done)
    private let askingRegisterProfileLabel = TitleLabel(title: "프로필 사진을 등록할까요?")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureNickNameInputView()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(nickNameInputView)
        view.addSubview(nickNameTextField)
        view.addSubview(askingRegisterProfileLabel)
    }
    
    private func configureNickNameInputView() {
        nickNameInputView.modifyBasicInputView(TitleSize: 24, isTitleBold: true, distance: 98)
        nickNameInputView.changeLabelColor(into: UIColor.appColor(.descriptionGeneral))
        nickNameInputView.changeSeparatorColor(into: UIColor.appColor(.brandMedium))
    }
    
    private func addConstraints() {
        
        nickNameInputView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
        
        nickNameTextField.anchor(bottom: nickNameInputView.bottomAnchor, bottomConstant: 32, leading: nickNameInputView.leadingAnchor, trailing: nickNameInputView.trailingAnchor)
        
        askingRegisterProfileLabel.anchor(top: nickNameInputView.bottomAnchor, topConstant: 70, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

