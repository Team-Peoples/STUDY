//
//  ProfileSettingView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/04.
//

import UIKit

class ProfileSettingView: UIView {
    
    private let nickNameInputView = SignUpInputView(titleText: "닉네임을 설정해주세요", validationLText: "*닉네임은 프로필에서 언제든 변경할 수 있어요")
    private let nickNameTextField
    = CustomTextField(placeholder: "한글/영어/숫자를 사용할 수 있어요", keyBoardType: .default, returnType: .done)
    private let askingRegisterProfileLabel = CustomLabel(title: "프로필 사진을 등록할까요?", color: .black, size: 24)
    private let descriptionLabel = CustomLabel(title: "등록하지 않으면 기본 이미지로 시작돼요", color: .subTitleGeneral, isBold: false, size: 12)
    private let profileImageSelectorView = ProfileImageSelectorView(size: 120)
    private let plusCircleView = PlusCircleFillView(size: 30)
    private let doneButton = CustomButton(title: "완료", isBold: true, isFill: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func assignDelegate(to vc: UIViewController) {
        nickNameTextField.delegate = vc as? UITextFieldDelegate
    }
    
    
    internal func setupTapGestures(target: UIViewController, selector: Selector) {
        
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        
        profileImageSelectorView.addGestureRecognizer(tapGesture)
        profileImageSelectorView.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureNickNameInputView()
        addConstraints()
    }
    
    internal func setProfileImage(into newImage: UIImage?) {
        if let newImage = newImage {
            profileImageSelectorView.image = newImage
        }
    }
    
    internal func toggleDoneButton() {
        if let nickName = nickNameTextField.text {
            
            if nickName.count > 0 {
                
                doneButton.isEnabled = true
                doneButton.fillIn(title: "완료")
            } else {
                
                doneButton.isEnabled = false
                doneButton.fillOut(title: "완료")
            }
        }
    }
    
    internal func nickNameTextFieldAddTarget(target: UIViewController, action: Selector) {
        nickNameTextField.addTarget(target, action: action, for: .editingChanged)
    }
    
    private func addSubViews() {
        addSubview(nickNameInputView)
        addSubview(nickNameTextField)
        addSubview(askingRegisterProfileLabel)
        addSubview(descriptionLabel)
        addSubview(profileImageSelectorView)
        addSubview(plusCircleView)
        addSubview(doneButton)
    }
    
    private func configureNickNameInputView() {
        nickNameInputView.modifyBasicInputView(TitleSize: 24, isTitleBold: true, distance: 98)
        nickNameInputView.changeLabelColor(into: UIColor.appColor(.descriptionGeneral))
        nickNameInputView.changeSeparatorColor(into: UIColor.appColor(.brandMedium))
    }
    
    private func addConstraints() {
        nickNameInputView.anchor(top: safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        
        nickNameTextField.anchor(bottom: nickNameInputView.bottomAnchor, bottomConstant: 32, leading: nickNameInputView.leadingAnchor, trailing: nickNameInputView.trailingAnchor)
        
        askingRegisterProfileLabel.anchor(top: nickNameInputView.bottomAnchor, topConstant: 70, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        
        descriptionLabel.anchor(top: askingRegisterProfileLabel.bottomAnchor, topConstant: 8, leading: askingRegisterProfileLabel.leadingAnchor)
        
        profileImageSelectorView.anchor(top: descriptionLabel.bottomAnchor, topConstant: 46)
        profileImageSelectorView.centerX(inView: self)
        
        plusCircleView.anchor(bottom: profileImageSelectorView.bottomAnchor, trailing: profileImageSelectorView.trailingAnchor)
        
        doneButton.anchor(bottom: bottomAnchor, bottomConstant: 30, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
}

