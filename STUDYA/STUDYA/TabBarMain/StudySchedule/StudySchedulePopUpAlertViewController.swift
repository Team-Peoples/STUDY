//
//  StudySchedulePopUpAlertViewController.swift
//  STUDYA
//
//  Created by 서동운 on 1/13/23.
//

import UIKit

class StudySchedulePopUpAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    let popUpType: String
    let repeatOption: RepeatOption
    var firstButtonAction: () -> Void = {}
    var secondButtonAction: () -> Void = {}
    
    private lazy var popUpTitleLabel = CustomLabel(title: "일정을 \(popUpType)할까요?", tintColor: .ppsBlack, size: 16)
    
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private lazy var firstButton = BrandButton(title: "이 일정만 \(popUpType)", fontSize: 16, backgroundColor: .appColor(.keyColor1), textColor: .appColor(.whiteLabel), radius: 12)
    private lazy var secondButton = BrandButton(title: "반복 일정까지 모두 \(popUpType)", fontSize: 16, backgroundColor: .appColor(.keyColor1), textColor: .appColor(.whiteLabel), radius: 12)
    private let cancelButton = BrandButton(title: "취소", fontSize: 16, backgroundColor: .systemBackground, textColor: .appColor(.keyColor1), radius: 12, borderColor: .keyColor1)
    
    // MARK: - Life Cycle
    
    init(type: String, repeatOption: RepeatOption) {
        self.popUpType = type
        self.repeatOption = repeatOption
        
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setConstraints()
        addTargetButton()
    }
    
    // MARK: - Actions
    
    @objc private func firstButtonDidTapped() {
        firstButtonAction()
    }
    
    @objc private func secondButtonDidTapped() {
        secondButtonAction()
    }
    
    @objc private func cancelButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    private func addTargetButton() {
        firstButton.addTarget(self, action: #selector(firstButtonDidTapped), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonDidTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.addSubview(popUpTitleLabel)
        popUpContainerView.addSubview(firstButton)
        if repeatOption != .norepeat {
            popUpContainerView.addSubview(secondButton)
        }
        popUpContainerView.addSubview(cancelButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        popUpContainerView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        popUpTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpContainerView).inset(50)
            make.centerX.equalTo(popUpContainerView)
        }
        firstButton.snp.makeConstraints { make in
            make.width.equalTo(260)
            make.leading.trailing.equalTo(popUpContainerView).inset(20)
            make.top.equalTo(popUpTitleLabel.snp.bottom).offset(40)
        }
        if repeatOption != .norepeat {
            
            secondButton.snp.makeConstraints { make in
                make.width.equalTo(260)
                make.leading.trailing.equalTo(popUpContainerView).inset(20)
                make.top.equalTo(firstButton.snp.bottom).offset(10)
            }
            cancelButton.snp.makeConstraints { make in
                make.width.equalTo(260)
                make.leading.trailing.equalTo(popUpContainerView).inset(20)
                make.top.equalTo(secondButton.snp.bottom).offset(10)
                make.bottom.equalTo(popUpContainerView).inset(20)
            }
        } else {
            cancelButton.snp.makeConstraints { make in
                make.width.equalTo(260)
                make.leading.trailing.equalTo(popUpContainerView).inset(20)
                make.top.equalTo(firstButton.snp.bottom).offset(10)
                make.bottom.equalTo(popUpContainerView).inset(20)
            }
        }
    }
}
