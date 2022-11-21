//
//  MemberBottomSheetViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberBottomSheetViewController: UIViewController {
    
    internal var isMaster = true
    internal lazy var member = Member(nickName: "", isManager: false) {
        didSet {
            profileView.configure(member.profileImage)
            nicknameLabel.text = member.nickName
            roleInputField.text = member.role
            member.isManager ? managerButton.easyConfigure(title: "관리자", backgroundColor: .appColor(.keyColor1), textColor: .systemBackground, borderColor: .keyColor1, radius: 12.5) : managerButton.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
        }
    }
    
    private let profileView = ProfileImageView(size: 40)
    private let nicknameLabel = CustomLabel(title: "요시", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var excommunicatingButton: UIButton = {
       
        let b = UIButton(frame: .zero)
        
        b.backgroundColor = .appColor(.subColor3)
        b.setTitle("강퇴", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 14)
        b.setTitleColor(.appColor(.subColor1), for: .normal)
        b.layer.cornerRadius = 14
        b.addTarget(self, action: #selector(askExcommunication), for: .touchUpInside)
        b.isHidden = true
        
        return b
    }()
    private let separator: UIView = {
        let s = UIView(frame: .zero)
        
        s.backgroundColor = .appColor(.ppsGray3)
        
        return s
    }()
    private lazy var ownerButton: CustomButton = {
       
        let b = CustomButton(title: "", isBold: true, isFill: false, fontSize: 12, height: 25)
        
        b.easyConfigure(title: "스터디장", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
        b.addTarget(self, action: #selector(ownerButtonTapped), for: .touchUpInside)
        b.isHidden = true
        
        return b
    }()
    private lazy var managerButton: CustomButton = {
       
        let b = CustomButton(title: "", isBold: true, isFill: false, fontSize: 12, height: 25)
        
        b.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
        b.addTarget(self, action: #selector(toggleManagerButton), for: .touchUpInside)
        b.isHidden = true
        
        return b
    }()
    private lazy var roleInputField: PurpleRoundedInputField = {
       
        let f = PurpleRoundedInputField(target: nil, action: nil)
        
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
//    private lazy var doneButton: UIButton = {
//
//        let b = UIButton(frame: .zero)
//
//        b.backgroundColor = UIColor.appColor(.keyColor1)
//        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
//
//        let c = CustomButton(title: "완료", isBold: true, isFill: true, fontSize: 20, height: 30)
//        c.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
//
//        b.addSubview(c)
//        c.snp.makeConstraints { make in
//            make.centerX.equalTo(b)
//            make.top.equalTo(b.snp.top).inset(20)
//        }
//
//        return b
//    }()
    
    private let bottomViewHeight: CGFloat = 320
    private let askViewHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isMaster {
            excommunicatingButton.isHidden = false
            ownerButton.isHidden = false
            managerButton.isHidden = false
        }
        
        view.backgroundColor = .systemBackground
        
        configureDefaultView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @objc private func askExcommunication() {
        guard let presentingViewController = self.presentingViewController else { return }
        
        self.dismiss(animated: true) {
            
            let presentingVC = AskExcommunicationViewController()
            presentingVC.willPresentingAgainVC = self
            
            guard let sheet = presentingVC.sheetPresentationController else { return }
  
            sheet.detents = [ .custom { _ in return 300 }]
            sheet.preferredCornerRadius = 24

            presentingViewController.present(presentingVC, animated: true)
        }
    }

    @objc private func ownerButtonTapped() {
        guard let presentingViewController = self.presentingViewController else { return }
        
        self.dismiss(animated: true) {
            
            let presentingVC = AskChangingOwnerViewController()
            presentingVC.willPresentingAgainVC = self
            
            guard let sheet = presentingVC.sheetPresentationController else { return }
  
            sheet.detents = [ .custom { _ in return 300 }]
            sheet.preferredCornerRadius = 24

            presentingViewController.present(presentingVC, animated: true)
        }
    }

    @objc private func toggleManagerButton() {
        managerButton.isSelected.toggle()
        managerButton.isSelected ? managerButton.easyConfigure(title: "관리자", backgroundColor: .appColor(.keyColor1), textColor: .systemBackground, borderColor: .keyColor1, radius: 12.5) : managerButton.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
    }
    
//    @objc private func doneButtonTapped() {
//        print(#function)
//    }
    
    private func configureDefaultView() {
        
        view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(profileView)
        view.addSubview(nicknameLabel)
        view.addSubview(excommunicatingButton)
        view.addSubview(separator)
        view.addSubview(ownerButton)
        view.addSubview(managerButton)
        view.addSubview(roleInputField)
//        view.addSubview(doneButton)
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(30)
            make.leading.equalTo(view.snp.leading).inset(20)
        }
        
        nicknameLabel.centerY(inView: profileView)
        nicknameLabel.anchor(leading: profileView.trailingAnchor, leadingConstant: 10)
        
        excommunicatingButton.centerY(inView: profileView)
        excommunicatingButton.anchor(trailing: view.trailingAnchor, trailingConstant: 33, width: 48)
        
        separator.anchor(top: profileView.bottomAnchor, topConstant: 12, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 1)
        
        ownerButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(40)
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.width.equalTo(67)
        }
        
        managerButton.snp.makeConstraints { make in
            make.leading.equalTo(ownerButton.snp.trailing).offset(10)
            make.top.equalTo(ownerButton.snp.top)
            make.width.equalTo(57)
        }
        
        roleInputField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(31)
            make.top.equalTo(managerButton.snp.bottom).offset(18)
        }
//
//        doneButton.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(view)
//            make.top.equalTo(roleInputField.snp.bottom).offset(63)
//        }
    }
}

final class AskChangingOwnerViewController: UIViewController {
        
    private let askLabel = CustomLabel(title: "닉네임님을 스터디장으로 지정할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "스터디장 권한이 양도돼요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: "확인")
        
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
    
    internal var willPresentingAgainVC: UIViewController?
    
    @objc private func ownerViewBackButtonTapped() {
        guard let presentingViewController = self.presentingViewController else { return }
        
        self.dismiss(animated: true) {
            
            let presentingVC = self.willPresentingAgainVC!
            
            guard let sheet = presentingVC.sheetPresentationController else { return }
  
            sheet.detents = [ .custom { _ in return 300 }]
            sheet.preferredCornerRadius = 24

            presentingViewController.present(presentingVC, animated: true)
        }
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
        
    private let askLabel = CustomLabel(title: "닉네임님을 강퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
    private let descLabel = CustomLabel(title: "강퇴한 멤버는 이 스터디에 다시 참여할 수 없어요.", tintColor: .ppsGray1, size: 14)
    private let backButton = UIButton(frame: .zero)
    private let confirmButton = UIButton(frame: .zero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: "확인")
        
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
    
    internal var willPresentingAgainVC: UIViewController?
    
    @objc private func excommuViewBackButtonTapped() {
        guard let presentingViewController = self.presentingViewController else { return }
        
        self.dismiss(animated: true) {
            
            let presentingVC = self.willPresentingAgainVC!
            
            guard let sheet = presentingVC.sheetPresentationController else { return }
  
            sheet.detents = [ .custom { _ in return 300 }]
            sheet.preferredCornerRadius = 24

            presentingViewController.present(presentingVC, animated: true)
        }
    }
    
    @objc private func excommuViewConfirmButtonTapped() {
        print(#function)
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}
