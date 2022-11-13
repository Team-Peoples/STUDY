//
//  ByeViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/30.
//

import UIKit

final class ByeViewController: UIViewController {
    
    private let titleLabel = CustomLabel(title: "탈퇴가\n완료됐어요.", tintColor: .ppsBlack, size: 30, isBold: true, isNecessaryTitle: false)
    private let descriptionLabel = CustomLabel(title: "그동안 피플즈를 이용해주셔서\n감사합니다. 🤗", tintColor: .ppsBlack, size: 20)
    private let button = CustomButton(title: "완료", isBold: true, isFill: true, size: 20, height: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "회원 탈퇴"
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 20)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 64, leading: titleLabel.leadingAnchor)
        button.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 30, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}
