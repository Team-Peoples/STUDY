//
//  StudyExitViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/14/22.
//

import UIKit
import SnapKit

class StudyExitViewController: UIViewController {
    
    var type: String?
    
    private var titleLabel: CustomLabel?
    private var subtitleLabel: CustomLabel?
    private let okButton = CustomButton(title: "확인", isFill: true)
    private lazy var backButton = CustomButton(title: "돌아가기", isFill: true)
    private lazy var goToResignAdminButton: UIButton = {
        let btn = UIButton()
        let attributedString: NSAttributedString = NSAttributedString(string: "스터디장 양도하러 가기 >", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.appColor(.keyColor1), .underlineColor: UIColor.appColor(.keyColor1), .underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.addTarget(self, action: #selector(goToResignAdminButtonDidTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        if type == "스터디 탈퇴" {
            titleLabel = CustomLabel(title: "이 스터디에서 탈퇴할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
            subtitleLabel = CustomLabel(title: "스터디에서 탈퇴해도 초대 링크를 통해\n다시 참여할 수 있어요.", tintColor: .ppsGray1, size: 14)
        } else if type == "스터디 종료" {
            titleLabel = CustomLabel(title: "{스터디명}을 종료할까요?", tintColor: .ppsBlack, size: 18, isBold: true)
            subtitleLabel = CustomLabel(title: "스터디를 종료한 이후에는\n스터디방을 다시 복구할 수 없어요.", tintColor: .ppsGray1, size: 14)
        } else if type == "최종" {
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
        
        if type == "스터디 탈퇴" || type == "스터디 종료" {
            view.addSubview(backButton)
            
            backButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
            
            backButton.snp.makeConstraints { make in
                make.bottom.equalTo(okButton.snp.top).offset(-14)
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
                make.height.equalTo(50)
            }
        } else {
            view.addSubview(goToResignAdminButton)
            
            goToResignAdminButton.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                make.leading.equalTo(subtitleLabel.snp.leading)
            }
        }
    }
    
    
    @objc func buttonDidTapped(_ sender: CustomButton) {
        if type == "스터디 탈퇴" && sender.titleLabel?.text == "확인" {
            guard let pvc = self.presentingViewController else { return }
            
            self.dismiss(animated: true) {
                
                let vcToPresent = StudyExitViewController()
                vcToPresent.type = "최종"
                
                if let sheet = vcToPresent.sheetPresentationController {
                    sheet.detents = [ .custom { _ in return 300 } ]
                    
                    sheet.preferredCornerRadius = 24
  
                }
                pvc.present(vcToPresent, animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc func goToResignAdminButtonDidTapped() {
        self.dismiss(animated: true)
        print("스터디장 양도 페이지로")
    }
}
