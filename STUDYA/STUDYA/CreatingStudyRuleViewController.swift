//
//  CreatingStudyRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/10.
//

import UIKit

class CreatingStudyRuleViewController: UIViewController {

    private let titleLabel = CustomLabel(title: "스터디를 어떻게\n운영하시겠어요?", tintColor: .titleGeneral, size: 24, isBold: true, isNecessaryTitle: false)
    private lazy var settingGeneralStudyRuleView: UIView = {
        
        let v = UIView()
        
        let titleLabel = CustomLabel(title: "스터디 규칙", tintColor: .titleGeneral, size: 18, isBold: true, isNecessaryTitle: false)
        let subTitleLabel = CustomLabel(title: "출결&벌금 / 강퇴 조건", tintColor: .subTitleGeneral, size: 18, isBold: false, isNecessaryTitle: false)
        let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator"))
        
        v.addSubview(titleLabel)
        v.addSubview(subTitleLabel)
        v.addSubview(disclosureIndicator)
        
        titleLabel.anchor(top: v.topAnchor, topConstant: 22, leading: v.leadingAnchor, leadingConstant: 27)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 1, leading: titleLabel.leadingAnchor)
        disclosureIndicator.anchor(top: v.topAnchor, topConstant: 29, bottom: v.bottomAnchor, bottomConstant: 29, trailing: v.trailingAnchor, trailingConstant: 15)
        
        v.layer.borderColor = UIColor.appColor(.descriptionGeneral).cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 24
        
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
        
        return v
    }()
    private lazy var settingStudyRuleDetailView: UIView = {
        
        let v = UIView()
        
        let titleLabel = CustomLabel(title: "스터디 규칙", tintColor: .titleGeneral, size: 18, isBold: true, isNecessaryTitle: false)
        let subTitleLabel = CustomLabel(title: "출결&벌금 / 강퇴 조건", tintColor: .subTitleGeneral, size: 18, isBold: false, isNecessaryTitle: false)
        let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator"))
        
        v.addSubview(titleLabel)
        v.addSubview(subTitleLabel)
        v.addSubview(disclosureIndicator)
        
        titleLabel.anchor(top: v.topAnchor, topConstant: 22, leading: v.leadingAnchor, leadingConstant: 27)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 1, leading: titleLabel.leadingAnchor)
        disclosureIndicator.anchor(top: v.topAnchor, topConstant: 29, bottom: v.bottomAnchor, bottomConstant: 29, trailing: v.trailingAnchor, trailingConstant: 15)
        
        v.layer.borderColor = UIColor.appColor(.descriptionGeneral).cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 24
        
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailRuleViewTapped)))
        
        return v
    }()
    private let descriptionLabel: CustomLabel = {
        
        let label = CustomLabel(title: "", tintColor: .brandMedium, size: 14)
        let attributedString = NSMutableAttributedString.init(string: "나중에 결정하시겠어요?")
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        label.attributedText = attributedString
        
        return label
    }()
    private lazy var doneButton: CustomButton = {
       
        let button = CustomButton(title: "다음", isBold: true, isFill: false)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "스터디 만들기"
        
        addsubViews()
//        settingGeneralStudyRuleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
//        settingStudyRuleDetailView.add
        colorBorder(of: settingStudyRuleDetailView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    @objc private func generalRuleViewTapped() {
        print(#function)
    }
    
    @objc private func detailRuleViewTapped() {
        print(#function)
    }
    
    @objc private func doneButtonTapped() {
        print(#function)
    }
    
    private func colorBorder(of settingView: UIView) {
        settingView.layer.borderColor = UIColor.appColor(.brandDark).cgColor
    }
    
    private func addsubViews() {
        view.addSubview(titleLabel)
        view.addSubview(settingGeneralStudyRuleView)
        view.addSubview(settingStudyRuleDetailView)
        view.addSubview(descriptionLabel)
        view.addSubview(doneButton)
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 50, leading: view.leadingAnchor, leadingConstant: 17)
        settingGeneralStudyRuleView.anchor(top: titleLabel.bottomAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 17, trailing: view.trailingAnchor, trailingConstant: 17, height: 88)
        settingStudyRuleDetailView.anchor(top: settingGeneralStudyRuleView.bottomAnchor, topConstant: 20, leading: view.leadingAnchor, leadingConstant: 17, trailing: view.trailingAnchor, trailingConstant: 17, height: 88)
        descriptionLabel.anchor(bottom: doneButton.topAnchor, bottomConstant: 21)
        descriptionLabel.centerX(inView: view)
        doneButton.anchor(bottom: view.bottomAnchor, bottomConstant: 40, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}
