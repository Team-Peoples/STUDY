//
//  AttendanceBottomViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/21.
//

import UIKit
import SnapKit

final class AttendanceBottomViewController: UIViewController {

//    private let attendanceCheckConditionSettingView = AttendanceCheckConditionSettingView(doneButtonTitle: "조회")
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {

        let v = UIView(frame: .zero)

        v.backgroundColor = .appColor(.ppsGray3)

        return v
    }()
    private let sortTitleLabel = CustomLabel(title: "정렬기준", tintColor: .ppsBlack, size: 14, isBold: true)
    private let nameInOrderButton = BrandButton(title: "이름순", isBold: false, textColor: .keyColor1, borderColor: .keyColor1, backgroundColor: .appColor(.background), fontSize: 14, height: 36)
    private let attendanceInOrderButton = BrandButton(title: "출석순", isBold: false, textColor: .keyColor1, borderColor: .keyColor1, backgroundColor: .appColor(.background), fontSize: 14, height: 36)
    private let timeTitleLabel = CustomLabel(title: "회차 선택", tintColor: .ppsBlack, size: 14, isBold: true)
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    lazy var doneButton: UIButton = {

        let b = UIButton(frame: .zero)
        b.backgroundColor = .appColor(.keyColor1)
//        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return b
    }()
    lazy var titleButton: BrandButton = {

        let b = BrandButton(title: "조회", isBold: true, isFill: true, fontSize: 20, height: 30)

//        b.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        return b
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground


        view.addSubview(titleLabel)
        view.addSubview(separator)
        view.addSubview(sortTitleLabel)
        view.addSubview(nameInOrderButton)
        view.addSubview(attendanceInOrderButton)
        view.addSubview(timeTitleLabel)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).inset(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        sortTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        nameInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(sortTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(36)
        }
        attendanceInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(nameInOrderButton.snp.trailing).offset(14)
            make.trailing.equalTo(view).inset(18)
            make.top.width.equalTo(nameInOrderButton)
            make.height.equalTo(36)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(view.snp.top).offset(166)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.trailing.equalTo(view).inset(20)
            make.top.equalTo(view.snp.top).offset(192)
        }

        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(collectionView.snp.bottom).offset(16)
        }

        doneButton.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.centerX.equalTo(doneButton)
            make.top.equalTo(doneButton.snp.top).inset(20)
        }
    }
    
    private func configureCollectionView() {
        
        flowLayout.itemSize = CGSize(width: 83, height: 36)
        flowLayout.minimumInteritemSpacing = 6
        
//        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        
        collectionView.register(InviteMemberCollectionViewCell.self, forCellWithReuseIdentifier: InviteMemberCollectionViewCell.identifier)
    }
}

extension AttendanceBottomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

extension AttendanceBottomViewController: UICollectionViewDelegate {
    
}

final class AttendanceCheckConditionSettingView: FullDoneButtonButtomView {

//    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
//    private let separator: UIView = {
//
//        let v = UIView(frame: .zero)
//
//        v.backgroundColor = .appColor(.ppsGray3)
//
//        return v
//    }()
//    private let sortTitleLabel = CustomLabel(title: "정렬기준", tintColor: .ppsBlack, size: 14, isBold: true)
//    private let nameInOrderButton = CustomButton(title: "")
//    private let attendanceInOrderButton = CustomButton(title: "")
//    private let timeTitleLabel = CustomLabel(title: "회차 선택", tintColor: .ppsBlack, size: 14, isBold: true)
//    private let dummyLabel = CustomLabel(title: "임시", tintColor: .ppsBlack, size: 16)

    override init(doneButtonTitle: String) {
        super.init(doneButtonTitle: doneButtonTitle)

//        backgroundColor = .systemBackground
//
//        nameInOrderButton.easyConfigure(title: "이름순", backgroundColor: .appColor(.background), textColor: .appColor(.keyColor1), borderColor: .keyColor1, radius: 18)
//        attendanceInOrderButton.easyConfigure(title: "출석순", backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 18)
//
//        addSubview(titleLabel)
//        addSubview(separator)
//        addSubview(sortTitleLabel)
//        addSubview(nameInOrderButton)
//        addSubview(attendanceInOrderButton)
//        addSubview(timeTitleLabel)
//        addSubview(dummyLabel)
//
//        titleLabel.snp.makeConstraints { make in
//            make.centerX.equalTo(self)
//            make.top.equalTo(self.snp.top).inset(24)
//        }
//        separator.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(self)
//            make.top.equalTo(titleLabel.snp.bottom).offset(16)
//            make.height.equalTo(1)
//        }
//        sortTitleLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.snp.leading).inset(18)
//            make.top.equalTo(separator.snp.bottom).offset(24)
//        }
//        nameInOrderButton.snp.makeConstraints { make in
//            make.leading.equalTo(sortTitleLabel.snp.leading)
//            make.top.equalTo(sortTitleLabel.snp.bottom).offset(12)
//            make.height.equalTo(36)
//        }
//        attendanceInOrderButton.snp.makeConstraints { make in
//            make.leading.equalTo(nameInOrderButton.snp.trailing).offset(14)
//            make.top.equalTo(nameInOrderButton)
//            make.height.equalTo(36)
//            make.width.equalTo(nameInOrderButton)
//        }
//        timeTitleLabel.snp.makeConstraints { make in
//            make.leading.equalTo(sortTitleLabel.snp.leading)
//            make.top.equalTo(nameInOrderButton.snp.bottom).offset(26)
//        }
//        dummyLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.snp.leading)
//            make.top.equalTo(timeTitleLabel.snp.bottom).offset(10)
//        }
////        configureDoneButton(on: self, under: dummyLabel, constant: 16)
//        addSubview(doneButton)
//        doneButton.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(self)
//            make.top.equalTo(dummyLabel.snp.bottom).offset(16)
//        }
//
//        doneButton.addSubview(titleButton)
//        titleButton.snp.makeConstraints { make in
//            make.centerX.equalTo(doneButton)
//            make.top.equalTo(doneButton.snp.top).inset(20)
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//
//final class AttendanceBottomViewController: UIViewController {
//
//    private let profileView = ProfileImageView(size: 40)
//    private let nicknameLabel = CustomLabel(title: "요시", tintColor: .ppsBlack, size: 14, isBold: true)
//    private lazy var excommunicatingButton: UIButton = {
//
//        let b = UIButton(frame: .zero)
//
//        b.backgroundColor = .appColor(.subColor3)
//        b.setTitle("강퇴", for: .normal)
//        b.titleLabel?.font = .boldSystemFont(ofSize: 14)
//        b.setTitleColor(.appColor(.subColor1), for: .normal)
//        b.layer.cornerRadius = 14
//        b.addTarget(self, action: #selector(askExcommunication), for: .touchUpInside)
//        b.isHidden = true
//
//        return b
//    }()
//    private let separator: UIView = {
//        let s = UIView(frame: .zero)
//
//        s.backgroundColor = .appColor(.ppsGray3)
//
//        return s
//    }()
//    private lazy var ownerButton: CustomButton = {
//
//        let b = CustomButton(title: "", isBold: true, isFill: false, fontSize: 12, height: 25)
//
//        b.easyConfigure(title: "스터디장", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
//        b.addTarget(self, action: #selector(ownerButtonTapped), for: .touchUpInside)
//        b.isHidden = true
//
//        return b
//    }()
//    private lazy var managerButton: CustomButton = {
//
//        let b = CustomButton(title: "", isBold: true, isFill: false, fontSize: 12, height: 25)
//
//        b.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
//        b.addTarget(self, action: #selector(toggleManagerButton), for: .touchUpInside)
//        b.isHidden = true
//
//        return b
//    }()
//    private lazy var roleInputField: PurpleRoundedInputField = {
//
//        let f = PurpleRoundedInputField(target: nil, action: nil)
//
//        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
//        f.attributedPlaceholder = NSAttributedString(string: "역할 이름을 자유롭게 정해주세요.", attributes: [.foregroundColor: UIColor.appColor(.ppsGray2), .font: UIFont.boldSystemFont(ofSize: 16)])
//        f.isSecureTextEntry = false
//
//        let l = CustomLabel(title: "역할", tintColor: .ppsBlack, size: 16)
//
//        f.addSubview(l)
//        l.snp.makeConstraints { make in
//            make.leading.equalTo(f).inset(22)
//            make.centerY.equalTo(f)
//        }
//
//        return f
//    }()
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
//
//    private let bottomViewHeight: CGFloat = 320
//    private let askViewHeight: CGFloat = 300
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        if isMaster {
////            excommunicatingButton.isHidden = false
////            ownerButton.isHidden = false
////            managerButton.isHidden = false
////        }
//
//        view.backgroundColor = .systemBackground
//
//        configureDefaultView()
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        view.endEditing(true)
//    }
//
//    @objc private func askExcommunication() {
//        guard let presentingViewController = self.presentingViewController else { return }
//
//        self.dismiss(animated: true) {
//
//            let presentingVC = AskExcommunicationViewController()
//            presentingVC.willPresentingAgainVC = self
//
//            guard let sheet = presentingVC.sheetPresentationController else { return }
//
//            sheet.detents = [ .custom { _ in return 300 }]
//            sheet.preferredCornerRadius = 24
//
//            presentingViewController.present(presentingVC, animated: true)
//        }
//    }
//
//    @objc private func ownerButtonTapped() {
//        guard let presentingViewController = self.presentingViewController else { return }
//
//        self.dismiss(animated: true) {
//
//            let presentingVC = AskChangingOwnerViewController()
//            presentingVC.willPresentingAgainVC = self
//
//            guard let sheet = presentingVC.sheetPresentationController else { return }
//
//            sheet.detents = [ .custom { _ in return 300 }]
//            sheet.preferredCornerRadius = 24
//
//            presentingViewController.present(presentingVC, animated: true)
//        }
//    }
//
//    @objc private func toggleManagerButton() {
//        managerButton.isSelected.toggle()
//        managerButton.isSelected ? managerButton.easyConfigure(title: "관리자", backgroundColor: .appColor(.keyColor1), textColor: .systemBackground, borderColor: .keyColor1, radius: 12.5) : managerButton.easyConfigure(title: "관리자", backgroundColor: .systemBackground, textColor: .appColor(.ppsGray2), borderColor: .ppsGray2, radius: 12.5)
//    }
//
//    @objc private func doneButtonTapped() {
//        print(#function)
//    }
//
//    private func configureDefaultView() {
//
////        view.snp.makeConstraints { make in
////            make.edges.equalTo(view)
////        }
//
//        view.addSubview(profileView)
//        view.addSubview(nicknameLabel)
//        view.addSubview(excommunicatingButton)
//        view.addSubview(separator)
//        view.addSubview(ownerButton)
//        view.addSubview(managerButton)
//        view.addSubview(roleInputField)
//        view.addSubview(doneButton)
//
//        profileView.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.top).inset(30)
//            make.leading.equalTo(view.snp.leading).inset(20)
//        }
//
//        nicknameLabel.centerY(inView: profileView)
//        nicknameLabel.anchor(leading: profileView.trailingAnchor, leadingConstant: 10)
//
//        excommunicatingButton.centerY(inView: profileView)
//        excommunicatingButton.anchor(trailing: view.trailingAnchor, trailingConstant: 33, width: 48)
//
//        separator.anchor(top: profileView.bottomAnchor, topConstant: 12, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 1)
//
//        ownerButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.snp.leading).inset(40)
//            make.top.equalTo(separator.snp.bottom).offset(20)
//            make.width.equalTo(67)
//        }
//
//        managerButton.snp.makeConstraints { make in
//            make.leading.equalTo(ownerButton.snp.trailing).offset(10)
//            make.top.equalTo(ownerButton.snp.top)
//            make.width.equalTo(57)
//        }
//
//        roleInputField.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(view).inset(31)
//            make.top.equalTo(managerButton.snp.bottom).offset(18)
//        }
//
//        doneButton.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(view)
//            make.top.equalTo(roleInputField.snp.bottom).offset(63)
//        }
//    }
//}
