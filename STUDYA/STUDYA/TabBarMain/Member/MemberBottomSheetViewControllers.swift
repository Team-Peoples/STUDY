//
//  MemberBottomSheetViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberBottomSheetViewController: UIViewController {
    
    deinit {
        print("🚨🚨🚨🚨🚨")
    }
    
    internal var member: Member? {
        didSet {
            guard let member = member else { return }
            
            profileImageView.setImageWith(member.profileImageURL)
            nicknameLabel.text = member.nickName
            roleInputField.text = member.role
            
            managerButton.isSelected = member.isManager ? true : false
//            ownerButton.isSelected = member.isOwner ? true : false
        }
    }
    internal var isOwner: Bool? {
        didSet {
            guard let isOwner = isOwner else { return }
            
            ownerButton.isHidden = isOwner ? false : true
            managerButton.isHidden = isOwner ? false : true
        }
    }
    private var newRole: String?
    internal var hasManagerSwitchEverToggled = false
    
    internal var askExcommunicateMember = {}
    internal var askChangeOwner = {}
    internal var getMemberListAgainAndReload = {}
    
    private let profileImageView = ProfileImageView(size: 40)
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
        f.attributedPlaceholder = NSAttributedString(string: "역할 이름을 자유롭게 정해주세요.", attributes: [.foregroundColor: UIColor.appColor(.ppsGray2), .font: UIFont.boldSystemFont(ofSize: 16)])
        f.isSecureTextEntry = false
        
        let l = CustomLabel(title: "역할", tintColor: .ppsBlack, size: 16)
        
        f.addSubview(l)
        l.snp.makeConstraints { make in
            make.leading.equalTo(f).inset(22)
            make.centerY.equalTo(f)
        }
        
        return f
    }()
//    🛑스터디장 역할 수정하려고할 때 색깔바꿔주기
    private lazy var noticeLabel = CustomLabel(title: "스터디장의 역할은 변경할 수 없습니다.", tintColor: .whiteLabel, size: 12)
    private lazy var doneButton: UIButton = {

        let b = UIButton(frame: .zero)

        b.backgroundColor = UIColor.appColor(.keyColor1)
        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        let c = BrandButton(title: Const.done, isBold: true, isFill: true, fontSize: 20, height: 30)
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
        
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if hasManagerSwitchEverToggled { getMemberListAgainAndReload() }
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
        
        Network.shared.toggleMangerAuth(memberID: memberID) { result in
            switch result {
            case .success(let isSucceed):
                if isSucceed {
                    
                    self.hasManagerSwitchEverToggled = true
                    self.managerButton.toggle()
                    
                } else {
                    let alert = SimpleAlert(message: Const.unknownErrorMessage + "code = 2")
                    self.present(alert, animated: true)
                }
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
        
        guard let memberID = member?.memberID, let newRole = newRole else { return }
        
        Network.shared.updateUserRole(memberID: memberID, role: newRole) { result in
            switch result {
            case .success(let isSucceed):
                
                if isSucceed {
                    self.getMemberListAgainAndReload()
                    self.dismiss(animated: true)
                    
                } else {
                    let alert = SimpleAlert(message: Const.unknownErrorMessage + "code = 3")
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
//        🛑멤버가 스터디장이라면 False 리턴
        true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        newRole = textField.text
    }
}

final class AskChangingOwnerViewController: UIViewController {
        
    private let askLabel = CustomLabel(title: "닉네임님을 스터디장으로 지정할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "스터디장 권한이 양도돼요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    internal var backButtonTapped = {}
    internal var getMemberListAgainAndReload = {}
    
    internal var navigatableDelegate: Navigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: Const.OK)
        
        backButton.addTarget(self, action: #selector(ownerViewBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(ownerViewConfirmButtonTapped), for: .touchUpInside)
        
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
            make.width.equalTo(Const.screenWidth * 8/9)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backButton)
            make.top.equalTo(backButton.snp.bottom).offset(14)
            make.width.equalTo(Const.screenWidth * 8/9)
            make.height.equalTo(40)
        }
    }
    
    @objc private func ownerViewBackButtonTapped() {
        backButtonTapped()
    }
    
    @objc private func ownerViewConfirmButtonTapped() {
        print(#function)
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}

final class AskExcommunicationViewController: UIViewController {
        
    internal var excommunicatedMemberID: Int?
    
    private let askLabel = CustomLabel(title: "닉네임님을 강퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "강퇴한 멤버는 이 스터디에 다시 참여할 수 없어요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    internal var backButtonTapped = {}
    internal var getMemberListAgainAndReload = {}
    
    internal var navigatableDelegate: Navigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: Const.OK)
        
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
            make.width.equalTo(Const.screenWidth * 8/9)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backButton)
            make.top.equalTo(backButton.snp.bottom).offset(14)
            make.width.equalTo(Const.screenWidth * 8/9)
            make.height.equalTo(40)
        }
    }
    
    @objc private func excommuViewBackButtonTapped() {
        backButtonTapped()
    }
    
    @objc private func excommuViewConfirmButtonTapped() {
        guard let id = excommunicatedMemberID else { return }
        
        Network.shared.excommunicateMember(id) { result in
            switch result {
            case .success(let isSucced):
                print(isSucced)
                
            case .failure(let error):
                switch error {
                case .unauthorizedMember:
                    let alert = SimpleAlert(buttonTitle: Const.OK, message: "강퇴 권한이 없습니다.") { finished in
                        self.dismiss(animated: true) {
                            self.navigatableDelegate?.pop()
                        }
                    }
                    self.present(alert, animated: true)
                case .cantExpelOwner:
                    let alert = SimpleAlert(message: "스터디장은 강퇴할 수 없습니다.")
                    self.present(alert, animated: true)
                case .cantExpelSelf:
                    let alert = SimpleAlert(message: "자기자신은 강퇴할 수 없습니다.\n스터디 정보의 \"스터디 탈퇴\" 통해 탈퇴할 수 있습니다.")
                    self.present(alert, animated: true)
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}
