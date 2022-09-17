//
//  CreatingStudyRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/10.
//

import UIKit

class CreatingStudyRuleViewController: UIViewController {

    internal var study: Study?
    
    private let titleLabel = CustomLabel(title: "스터디를 어떻게\n운영하시겠어요?", tintColor: .ppsBlack, size: 24, isBold: true, isNecessaryTitle: false)
    private lazy var settingStudyGeneralRuleView: UIView = {
        
        let v = UIView()
        
        let titleLabel = CustomLabel(title: "스터디 규칙", tintColor: .ppsBlack, size: 18, isBold: true, isNecessaryTitle: false)
        let subTitleLabel = CustomLabel(title: "출결&벌금 / 강퇴 조건", tintColor: .ppsGray1, size: 16, isBold: false, isNecessaryTitle: false)
        let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator"))
        
        v.addSubview(titleLabel)
        v.addSubview(subTitleLabel)
        v.addSubview(disclosureIndicator)
        
        titleLabel.anchor(top: v.topAnchor, topConstant: 22, leading: v.leadingAnchor, leadingConstant: 27)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 1, leading: titleLabel.leadingAnchor)
        disclosureIndicator.anchor(trailing: v.trailingAnchor, trailingConstant: 15)
        disclosureIndicator.centerY(inView: v)
        
        v.layer.borderColor = UIColor.appColor(.ppsGray2).cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 24
        
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
        
        return v
    }()
    
    private lazy var settingStudyFreeRuleView: UIView = {
        
        let v = UIView()
        
        let titleLabel = CustomLabel(title: "스터디 진행방식", tintColor: .ppsBlack, size: 18, isBold: true, isNecessaryTitle: false)
        let subTitleLabel = CustomLabel(title: "자유 형식", tintColor: .ppsGray1, size: 16, isBold: false, isNecessaryTitle: false)
        let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator"))
        
        v.addSubview(titleLabel)
        v.addSubview(subTitleLabel)
        v.addSubview(disclosureIndicator)
        
        titleLabel.anchor(top: v.topAnchor, topConstant: 22, leading: v.leadingAnchor, leadingConstant: 27)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 1, leading: titleLabel.leadingAnchor)
        disclosureIndicator.anchor(trailing: v.trailingAnchor, trailingConstant: 15)
        disclosureIndicator.centerY(inView: v)
        
        v.layer.borderColor = UIColor.appColor(.ppsGray2).cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 24
        
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(freeRuleViewTapped)))
        
        return v
    }()
    
    private let descriptionLabel: CustomLabel = {
        
        let label = CustomLabel(title: "", tintColor: .keyColor2, size: 14)
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
    
    var ruleViewModel: RuleViewModel? {
        didSet {
            if (ruleViewModel?.generalStudyRule) != nil {
                changeBorder(color: .keyColor1, of: settingStudyGeneralRuleView)
            } else {
                changeBorder(color: .ppsGray2, of: settingStudyGeneralRuleView)
            }
            
            if ruleViewModel?.freeStudyRule != nil {
                changeBorder(color: .keyColor1, of: settingStudyFreeRuleView)
            } else {
                changeBorder(color: .ppsGray2, of: settingStudyFreeRuleView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "스터디 만들기"
        
        addsubViews()
        settingStudyGeneralRuleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    @objc private func generalRuleViewTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "StudyGeneralRuleViewController") as! StudyGeneralRuleViewController
        vc.generalStudyRule = ruleViewModel?.generalStudyRule
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    @objc private func freeRuleViewTapped() {
     let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudyFreeRuleViewController") as! StudyFreeRuleViewController
        vc.freeStudyRule = ruleViewModel?.freeStudyRule
        
        vc.completion = { rule in
            self.ruleViewModel?.freeStudyRule = rule
        }
        present(vc, animated: true)
    }
    
    @objc private func doneButtonTapped() {
        print(#function)
    }
    
    private func changeBorder(color: AssetColor, of settingView: UIView) {
        settingView.layer.borderColor = UIColor.appColor(color).cgColor
    }
    
    private func addsubViews() {
        view.addSubview(titleLabel)
        view.addSubview(settingStudyGeneralRuleView)
        view.addSubview(settingStudyFreeRuleView)
        view.addSubview(descriptionLabel)
        view.addSubview(doneButton)
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 50, leading: view.leadingAnchor, leadingConstant: 17)
        settingStudyGeneralRuleView.anchor(top: titleLabel.bottomAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 17, trailing: view.trailingAnchor, trailingConstant: 17, height: 88)
        settingStudyFreeRuleView.anchor(top: settingStudyGeneralRuleView.bottomAnchor, topConstant: 20, leading: view.leadingAnchor, leadingConstant: 17, trailing: view.trailingAnchor, trailingConstant: 17, height: 88)
        descriptionLabel.anchor(bottom: doneButton.topAnchor, bottomConstant: 21)
        descriptionLabel.centerX(inView: view)
        doneButton.anchor(bottom: view.bottomAnchor, bottomConstant: 40, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

extension CreatingStudyViewController {
    
}

//protocol
