//
//  MemberBottomSheetViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberBottomSheetViewController: UIViewController, Draggable {
    
    internal weak var sheetCoordinator: UBottomSheetCoordinator?
    internal weak var dataSource: UBottomSheetCoordinatorDataSource?
    
    private let defaultView = UIView(frame: .zero)
    private let bar: UIView = {
       
        let b = UIView(frame: .zero)
        
        b.backgroundColor = .appColor(.ppsGray2)
        b.clipsToBounds = true
        b.layer.cornerRadius = 2
        
        return b
    }()
    private let profileView = ProfileImageSelectorView(size: 40)
    private let nicknameLabel = CustomLabel(title: "요시", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var excommunicatingButton: UIButton = {
       
        let b = UIButton(frame: .zero)
        
        b.backgroundColor = .appColor(.subColor3)
        b.setTitle("강퇴", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 14)
        b.setTitleColor(.appColor(.subColor1), for: .normal)
        b.layer.cornerRadius = 14
        b.addTarget(self, action: #selector(askExcommunication), for: .touchUpInside)
        
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
        
        return b
    }()
    private lazy var managerButton: CustomButton = {
       
        let b = CustomButton(title: "", isBold: true, isFill: false, fontSize: 12, height: 25)
        
        b.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
        b.addTarget(self, action: #selector(toggleManagerButton), for: .touchUpInside)
        
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
    private lazy var doneButton: UIButton = {
       
        let b = UIButton(frame: .zero)
        
        b.backgroundColor = UIColor.appColor(.keyColor1)
        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        let c = CustomButton(title: "완료", isBold: true, isFill: true, fontSize: 20, height: 30)
        c.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        b.addSubview(c)
        c.snp.makeConstraints { make in
            make.centerX.equalTo(b)
            make.top.equalTo(b.snp.top).inset(20)
        }
        
        return b
    }()
    private lazy var doneButtonTitleLabel: CustomButton = {
       
        let b = CustomButton(title: "완료", isBold: true, isFill: true, fontSize: 20, height: 30)
        
        return b
    }()
    
    private lazy var askChangingOwnerView: UIView = {
       
        let v = UIView(frame: .zero)
        
        let askLabel = CustomLabel(title: "닉네임님을 스터디장으로 지정할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
        let descLabel = CustomLabel(title: "스터디장 권한이 양도돼요.", tintColor: .ppsGray1, size: 14)
        let backButton = UIButton(frame: .zero)
        let confirmButton = UIButton(frame: .zero)
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: "확인")
        
        backButton.addTarget(self, action: #selector(ownerViewBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(ownerViewConfirmButtonTapped), for: .touchUpInside)
        
        v.addSubview(askLabel)
        v.addSubview(descLabel)
        v.addSubview(backButton)
        v.addSubview(confirmButton)
        
        askLabel.snp.makeConstraints { make in
            make.leading.equalTo(v).inset(20)
            make.top.equalTo(v).inset(30)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(askLabel)
            make.top.equalTo(askLabel.snp.bottom).offset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(v).inset(20)
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
        
        v.isHidden = true
        return v
    }()
    
    private lazy var askExCommunicationView: UIView = {
       
        let v = UIView(frame: .zero)
        
        let askLabel = CustomLabel(title: "닉네임님을 강퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
        let descLabel = CustomLabel(title: "강퇴한 멤버는 이 스터디에 다시 참여할 수 없어요.", tintColor: .ppsGray1, size: 14)
        let backButton = UIButton(frame: .zero)
        let confirmButton = UIButton(frame: .zero)
        
        configureButton(button: backButton, title: "돌아가기")
        configureButton(button: confirmButton, title: "확인")
        
        backButton.addTarget(self, action: #selector(excommuViewBackButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(excommuViewConfirmButtonTapped), for: .touchUpInside)
        
        v.addSubview(askLabel)
        v.addSubview(descLabel)
        v.addSubview(backButton)
        v.addSubview(confirmButton)
        
        askLabel.snp.makeConstraints { make in
            make.leading.equalTo(v).inset(20)
            make.top.equalTo(v).inset(30)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(askLabel)
            make.top.equalTo(askLabel.snp.bottom).offset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(v).inset(20)
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
        
        v.isHidden = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureDefaultView()
        view.addSubview(askChangingOwnerView)
        askChangingOwnerView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.addSubview(askExCommunicationView)
        askExCommunicationView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sheetCoordinator?.startTracking(item: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @objc private func askExcommunication() {
        sheetCoordinator?.appearTwice(Const.screenHeight * 0.94, animated: true, twiceHeight: Const.screenHeight * 0.6, completion: {
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.defaultView.backgroundColor = .systemBackground
            } completion: { _ in
                self.defaultView.isHidden = true
                self.askExCommunicationView.isHidden = false
            }
        })
    }
    
    @objc private func keyboardUp() {
        sheetCoordinator?.setPosition(Const.screenHeight * 0.25, animated: true)
    }
    
    @objc private func keyboardDown() {
        sheetCoordinator?.setPosition(Const.screenHeight * 0.5, animated: true)
    }
    
    @objc private func ownerButtonTapped() {
        sheetCoordinator?.appearTwice(Const.screenHeight * 0.94, animated: true, twiceHeight: Const.screenHeight * 0.6, completion: {
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.defaultView.backgroundColor = .systemBackground
            } completion: { _ in
                self.defaultView.isHidden = true
                self.askChangingOwnerView.isHidden = false
            }
        })
    }

    @objc private func toggleManagerButton() {
        managerButton.isSelected.toggle()
        managerButton.isSelected ? managerButton.easyConfigure(title: "관리자", backgroundColor: .appColor(.keyColor1), textColor: .systemBackground, borderColor: .keyColor1, radius: 12.5) : managerButton.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
    }
    
    @objc private func doneButtonTapped() {
        print(#function)
    }
    
    @objc private func ownerViewBackButtonTapped() {
        sheetCoordinator?.appearTwice(Const.screenHeight * 0.94, animated: true, twiceHeight: Const.screenHeight * 0.5, completion: {
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.askChangingOwnerView.backgroundColor = .systemBackground
            } completion: { _ in
                self.askChangingOwnerView.isHidden = true
                self.defaultView.isHidden = false
            }
        })
    }
    
    @objc private func ownerViewConfirmButtonTapped() {
        print(#function)
    }
    
    @objc private func excommuViewBackButtonTapped() {
        sheetCoordinator?.appearTwice(Const.screenHeight * 0.94, animated: true, twiceHeight: Const.screenHeight * 0.5, completion: {
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.askExCommunicationView.backgroundColor = .systemBackground
            } completion: { _ in
                self.askExCommunicationView.isHidden = true
                self.defaultView.isHidden = false
            }
        })
    }
    
    @objc private func excommuViewConfirmButtonTapped() {
        print(#function)
    }
    
    private func configureDefaultView() {
        
        view.addSubview(defaultView)
        defaultView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        defaultView.addSubview(bar)
        defaultView.addSubview(profileView)
        defaultView.addSubview(nicknameLabel)
        defaultView.addSubview(excommunicatingButton)
        defaultView.addSubview(separator)
        defaultView.addSubview(ownerButton)
        defaultView.addSubview(managerButton)
        defaultView.addSubview(roleInputField)
        defaultView.addSubview(doneButton)
        
        
        bar.snp.makeConstraints { make in
            make.top.equalTo(defaultView.snp.top).inset(6)
            make.centerX.equalTo(view)
            make.height.equalTo(4)
            make.width.equalTo(46)
        }
        
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
            make.leading.trailing.equalTo(defaultView).inset(31)
            make.top.equalTo(managerButton.snp.bottom).offset(18)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(defaultView)
            make.top.equalTo(roleInputField.snp.bottom).offset(63)
        }
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor(.keyColor1)
        button.layer.cornerRadius = 12
    }
}
