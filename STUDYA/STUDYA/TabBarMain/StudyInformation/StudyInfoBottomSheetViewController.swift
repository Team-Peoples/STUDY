//
//  StudyInfoBottomSheetViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/14/22.
//

import UIKit

final class StudyInfoBottomSheetViewController: UIViewController {
    
    var studyName: String?
    var studyID: ID?
    
    let task: UserTaskInStudyInfo
    weak var presentingVC: UIViewController?
    
    private var titleLabel: CustomLabel?
    private var subtitleLabel: CustomLabel?
    private let okButton = BrandButton(title: Constant.OK, isFill: true)
    private lazy var backButton = BrandButton(title: "돌아가기", isFill: true)
    private lazy var goToResignAdminButton: UIButton = {
        let btn = UIButton()
        let attributedString: NSAttributedString = NSAttributedString(string: "스터디장 양도하러 가기 >", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.appColor(.keyColor1), .underlineColor: UIColor.appColor(.keyColor1), .underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.addTarget(self, action: #selector(goToResignAdminButtonDidTapped), for: .touchUpInside)
        return btn
    }()
    
    init(task: UserTaskInStudyInfo) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        switch task {
            case .leave:
                titleLabel = CustomLabel(title: "이 스터디에서 탈퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
                subtitleLabel = CustomLabel(title: "스터디에서 탈퇴해도 초대 링크를 통해\n다시 참여할 수 있어요.", tintColor: .ppsGray1, size: 14)
            case .ownerClose:
                titleLabel = CustomLabel(title: "\(studyName ?? "스터디")을(를) 종료할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
                subtitleLabel = CustomLabel(title: "스터디를 종료한 이후에는\n스터디방을 다시 복구할 수 없어요.", tintColor: .ppsGray1, size: 14)
            case .resignMaster:
                titleLabel = CustomLabel(title: "지금은 탈퇴할 수 없어요.", tintColor: .ppsBlack, size: 18, isBold: true)
                subtitleLabel = CustomLabel(title: "스터디에서 탈퇴하려면 다른 멤버에게\n스터디장을 양도해주세요.", tintColor: .ppsGray1, size: 14)
        }
        
        guard let titleLabel = titleLabel else { return }
        guard let subtitleLabel = subtitleLabel else { return }
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(okButton)
    
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        okButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        okButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        
        switch task {
            case .leave, .ownerClose:
                view.addSubview(backButton)
                
                backButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
                
                backButton.snp.makeConstraints { make in
                    make.bottom.equalTo(okButton.snp.top).offset(-14)
                    make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
                    make.height.equalTo(50)
                }
            case .resignMaster:
                view.addSubview(goToResignAdminButton)
                
                goToResignAdminButton.snp.makeConstraints { make in
                    make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                    make.leading.equalTo(subtitleLabel.snp.leading)
                }
        }
    }
    
    
    @objc func buttonDidTapped(_ sender: BrandButton) {
        if sender.titleLabel?.text == Constant.OK {
            switch task {
            case .leave:
                guard let studyID = studyID else { return }
                Network.shared.leaveFromStudy(id: studyID) { result in
                    switch result {
                    case .success:
                        print("스터디 탈퇴 성공")
                        
                        UserDefaults.standard.removeObject(forKey: "checkedAnnouncementIDOfStudy\(studyID)")
                        NotificationCenter.default.post(name: .reloadStudyList, object: nil)
                        self.dismiss(animated: true) {
                            self.presentingVC?.navigationController?.popToRootViewController(animated: true)
                        }
                    case .failure(let error):
                        print("스터디장은 탈퇴할 수 없어요.")
                        UIAlertController.handleCommonErros(presenter: self, error: error)
                    }
                }
                
            case .ownerClose:
                guard let studyID = studyID else { return }
                Network.shared.closeStudy(studyID) { result in
                    switch result {
                    case .success:
                        print("스터디장이 스터디 종료 성공")
                        NotificationCenter.default.post(name: .reloadStudyList, object: nil)
                        self.dismiss(animated: true) {
                            self.presentingVC?.navigationController?.popToRootViewController(animated: true)
                        }
                    case .failure(let error):
                        UIAlertController.handleCommonErros(presenter: self, error: error)
                    }
                }
            case.resignMaster:
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
        
    @objc func goToResignAdminButtonDidTapped() {
        self.dismiss(animated: true) {
            self.presentingVC?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
