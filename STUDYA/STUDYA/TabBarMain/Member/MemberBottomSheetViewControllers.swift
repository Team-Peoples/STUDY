//
//  MemberBottomSheetViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberBottomSheetViewController: UIViewController {
    
    internal var member: Member?
    internal var isOwner: Bool?
    
    private var newRole: String?
    internal var hasMemeberInfoEverChanged = false
    
    internal var askExcommunicateMember = {}
    internal var askChangeOwner = {}
    internal var getMemberListAgainAndReload = {}
    
    private let profileImageView = ProfileImageContainerView(size: 40)
    private let nicknameLabel = CustomLabel(title: "닉네임", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var excommunicatingButton = CustomButton(fontSize: 14, isBold: true, normalBackgroundColor: .subColor3, normalTitleColor: .subColor1, height: 28, normalTitle: "강퇴", contentEdgeInsets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), target: self, action: #selector(askExcommunication))
    private let separator: UIView = {
        let s = UIView(frame: .zero)
        
        s.backgroundColor = .appColor(.ppsGray3)
        
        return s
    }()
    private lazy var ownerButton = CustomButton(fontSize: 12, isBold: true, normalBackgroundColor: .whiteLabel, normalTitleColor: .ppsGray2, height: 25, normalBorderColor: .ppsGray2, normalTitle: "스터디장", selectedBackgroundColor: .keyColor1, selectedTitleColor: .whiteLabel, selectedBorderColor: .keyColor1, contentEdgeInsets: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13), target: self, action: #selector(ownerButtonDidTapped))
    private lazy var managerButton = CustomButton(fontSize: 12, isBold: true, normalBackgroundColor: .whiteLabel, normalTitleColor: .ppsGray2, height: 25, normalBorderColor: .ppsGray2, normalTitle: "관리자", selectedBackgroundColor: .keyColor1, selectedTitleColor: .whiteLabel, selectedBorderColor: .keyColor1, contentEdgeInsets: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13), target: self, action: #selector(toggleManagerButton))
    private lazy var roleInputField: PurpleRoundedInputField = {
       
        let f = PurpleRoundedInputField(target: nil, action: nil)
        
        f.setDelegate(to: self)
        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
        f.attributedPlaceholder = NSAttributedString(string: "역할 이름을 자유롭게 정해주세요.('스터디장' 제외)", attributes: [.foregroundColor: UIColor.appColor(.ppsGray2), .font: UIFont.boldSystemFont(ofSize: 16)])
        f.isSecureTextEntry = false
        
        let l = CustomLabel(title: "역할", tintColor: .ppsBlack, size: 16)
        
        f.addSubview(l)
        l.snp.makeConstraints { make in
            make.leading.equalTo(f).inset(22)
            make.centerY.equalTo(f)
        }
        
        return f
    }()
    private lazy var noticeLabel = CustomLabel(title: "스터디장의 역할은 변경할 수 없습니다.", tintColor: .whiteLabel, size: 12)
    private lazy var doneButton: UIButton = {

        let b = UIButton(frame: .zero)

        b.backgroundColor = UIColor.appColor(.keyColor1)
        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        let c = BrandButton(title: Constant.done, isBold: true, isFill: true, fontSize: 20, height: 30)
        c.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        b.addSubview(c)
        c.snp.makeConstraints { make in
            make.centerX.equalTo(b)
            make.top.equalTo(b.snp.top).inset(20)
        }

        return b
    }()
    
    private let bottomViewHeight: CGFloat = 320
    private let askViewHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if hasMemeberInfoEverChanged { getMemberListAgainAndReload() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @objc private func askExcommunication() {
        self.askExcommunicateMember()
    }

    @objc private func ownerButtonDidTapped() {
        self.askChangeOwner()
    }

    @objc private func toggleManagerButton() {
        guard let memberID = member?.memberID else { return }
        
        self.hasMemeberInfoEverChanged = true
        self.managerButton.toggle()
        
        Network.shared.toggleMangerAuth(memberID: memberID) { result in
            switch result {
            case .success(let isSucceed):
                
                if !isSucceed {
                    self.managerButton.toggle()
                    
                    let alert = SimpleAlert(message: Constant.unknownErrorMessage + "code = 2")
                    self.present(alert, animated: true)
                }
                
            case .failure(let error):
                self.managerButton.toggle()
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        hasMemeberInfoEverChanged = true
        view.endEditing(true)
        
        guard let memberID = member?.memberID, let newRole = newRole else { return }
        
        Network.shared.updateUserRole(memberID: memberID, role: newRole) { result in
            switch result {
            case .success(let isSucceed):
                
                if isSucceed {
                    self.dismiss(animated: true)
                    
                } else {
                    let alert = SimpleAlert(message: Constant.unknownErrorMessage + "code = 3")
                    self.present(alert, animated: true)
                }
                
            case .failure(let error):
                switch error {
                case .cantChangeOwnerRole:
                    let alert = SimpleAlert(message: "스터디장의 역할은 변경할 수 없습니다.")
                    self.present(alert, animated: true)
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
    }
    
    internal func configureViewControllerWith(member: Member, isOwner: Bool) {
        self.member = member
        self.isOwner = isOwner
        
        profileImageView.setImageWith(member.profileImageURL)
        nicknameLabel.text = member.nickName
        roleInputField.text = member.role
        
        managerButton.isSelected = member.isManager ? true : false
        ownerButton.isSelected = member.role == "스터디장" ? true : false
        
        ownerButton.isHidden = isOwner ? false : true
        managerButton.isHidden = isOwner ? false : true
        
        ownerButton.isEnabled = member.role == "스터디장" ? false : true
        managerButton.isEnabled = member.role == "스터디장" ? false : true
        excommunicatingButton.isEnabled = member.role == "스터디장" ? false : true
    }
    
    private func configureView() {
                
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(excommunicatingButton)
        view.addSubview(separator)
        view.addSubview(ownerButton)
        view.addSubview(managerButton)
        view.addSubview(roleInputField)
        view.addSubview(noticeLabel)
        view.addSubview(doneButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(30)
            make.leading.equalTo(view.snp.leading).inset(20)
        }
        
        nicknameLabel.centerY(inView: profileImageView)
        nicknameLabel.anchor(leading: profileImageView.trailingAnchor, leadingConstant: 10)
        
        excommunicatingButton.centerY(inView: profileImageView)
        excommunicatingButton.anchor(trailing: view.trailingAnchor, trailingConstant: 33)
        
        separator.anchor(top: profileImageView.bottomAnchor, topConstant: 12, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 1)
        
        ownerButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(40)
            make.top.equalTo(separator.snp.bottom).offset(20)
        }
        
        managerButton.snp.makeConstraints { make in
            make.leading.equalTo(ownerButton.snp.trailing).offset(10)
            make.top.equalTo(ownerButton.snp.top)
        }
        
        roleInputField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(31)
            make.top.equalTo(managerButton.snp.bottom).offset(18)
        }

        noticeLabel.snp.makeConstraints { make in
            make.leading.equalTo(roleInputField.snp.leading).offset(22)
            make.top.equalTo(roleInputField.snp.bottom).offset(6)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(roleInputField.snp.bottom).offset(63)
        }
    }
}

extension MemberBottomSheetViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "스터디장" {
            animateTextColor(to: .appColor(.ppsGray1))

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.animateTextColor(to: .white)
            }
            
            return false
        } else {
            return true
        }
    }
    
    func animateTextColor(to color: UIColor) {
        UIView.transition(with: noticeLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.noticeLabel.textColor = color
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newRole = textField.text
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
               
        let okayToEndEditing = text == "스터디장" ? false : true
        
        return okayToEndEditing
    }
}

final class AskChangingOwnerViewController: UIViewController {
        
    private let askLabel = CustomLabel(title: "닉네임님을 스터디장으로 지정할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "스터디장 권한이 양도돼요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    internal var backButtonTapped = {}
    internal var turnOverStudyOwnerAndReload = {}
    
    internal var navigatableDelegate: Navigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: Constant.OK)
        
        backButton.addTarget(self, action: #selector(GoBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(turnOverOwnerConfirmButtonTapped), for: .touchUpInside)
        
        view.addSubview(askLabel)
        view.addSubview(descLabel)
        view.addSubview(backButton)
        view.addSubview(confirmButton)
        
        askLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(20)
            make.top.equalTo(view).inset(30)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(askLabel)
            make.top.equalTo(askLabel.snp.bottom).offset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(descLabel.snp.bottom).offset(69)
            make.width.equalTo(Constant.screenWidth * 8/9)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backButton)
            make.top.equalTo(backButton.snp.bottom).offset(14)
            make.width.equalTo(Constant.screenWidth * 8/9)
            make.height.equalTo(40)
        }
    }
    
    @objc private func GoBackButtonTapped() {
        backButtonTapped()
    }
    
    @objc private func turnOverOwnerConfirmButtonTapped() {
        turnOverStudyOwnerAndReload()
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}

final class AskExcommunicationViewController: UIViewController {
    
    private let askLabel = CustomLabel(title: "닉네임님을 강퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "강퇴한 멤버는 이 스터디에 다시 참여할 수 없어요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    internal var backButtonTapped = {}
    internal var excommunicateMember = {}
    
    internal var navigatableDelegate: Navigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: Constant.OK)
        
        backButton.addTarget(self, action: #selector(excommuViewBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(excommuViewConfirmButtonTapped), for: .touchUpInside)
        
        view.addSubview(askLabel)
        view.addSubview(descLabel)
        view.addSubview(backButton)
        view.addSubview(confirmButton)
        
        askLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(20)
            make.top.equalTo(view).inset(30)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(askLabel)
            make.top.equalTo(askLabel.snp.bottom).offset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(descLabel.snp.bottom).offset(69)
            make.width.equalTo(Constant.screenWidth * 8/9)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backButton)
            make.top.equalTo(backButton.snp.bottom).offset(14)
            make.width.equalTo(Constant.screenWidth * 8/9)
            make.height.equalTo(40)
        }
    }
    
    @objc private func excommuViewBackButtonTapped() {
        backButtonTapped()
    }
    
    @objc private func excommuViewConfirmButtonTapped() {
        excommunicateMember()
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}
