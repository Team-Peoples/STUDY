//
//  FindPasswordCompleteViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import UIKit

class FindPasswordCompleteViewController: UIViewController {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(title: "이메일울\n확인해주세요", tintColor: .ppsBlack, size: 30, isBold: true)
    private var emailLabel = CustomLabel(title: String(), tintColor: .ppsBlack, size: 20, isBold: true)
    private let descriptionLabel = CustomLabel(title: "가입하신 이메일로 임시 비밀번호를\n보내드렸어요!😊", tintColor: .ppsBlack, size: 20)
    private let completeButton = BrandButton(title: Constant.OK, isFill: true)
    
    // MARK: - Actions
    
    @objc private func completeButtonDidTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.emailLabel.text = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureCompleteButton()
        
        setConstraints()
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(emailLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(completeButton)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureCompleteButton() {
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(160)
            make.leading.equalTo(view).offset(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.leading.equalTo(titleLabel)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(33)
            make.leading.equalTo(emailLabel)
        }
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
