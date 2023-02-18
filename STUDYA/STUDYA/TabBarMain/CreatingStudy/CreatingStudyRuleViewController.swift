//
//  CreatingStudyRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/10.
//

import UIKit

final class CreatingStudyRuleViewController: UIViewController {
    
    internal var creatingStudyRuleViewModel = StudyViewModel()
    private let titleLabel = CustomLabel(title: "스터디를 어떻게\n운영하시겠어요?", tintColor: .ppsBlack, size: 24, isBold: true)
    private let subTitleLabel = CustomLabel(title: "스터디 정보에서 언제든지 수정할 수 있어요!", tintColor: .ppsBlack, size: 18)
    private lazy var settingStudyGeneralRuleView: UIView = {
        
        let v = UIView()
        let titleLabel = CustomLabel(title: "스터디 규칙", tintColor: .ppsBlack, size: 18, isBold: true)
        let subTitleLabel = CustomLabel(title: "출결&벌금 / 강퇴 조건", tintColor: .ppsGray1, size: 16, isBold: false)
        let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator"))
        
        v.addSubview(titleLabel)
        v.addSubview(subTitleLabel)
        v.addSubview(disclosureIndicator)
        
        titleLabel.anchor(top: v.topAnchor, topConstant: 22, leading: v.leadingAnchor, leadingConstant: 27)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 1, leading: titleLabel.leadingAnchor)
        disclosureIndicator.anchor(trailing: v.trailingAnchor, trailingConstant: 15)
        disclosureIndicator.centerY(inView: v)
       
        v.configureBorder(color: .ppsGray2, width: 1, radius: 24)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
        
        return v
    }()
    private lazy var settingStudyFreeRuleView: UIView = {
        
        let v = UIView()
        let titleLabel = CustomLabel(title: "스터디 진행방식", tintColor: .ppsBlack, size: 18, isBold: true)
        let subTitleLabel = CustomLabel(title: "자유 형식", tintColor: .ppsGray1, size: 16, isBold: false)
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
    private lazy var creatingStudyRuleSkipButton: UIButton = {
        
        let button = UIButton()
        let attributedString = NSMutableAttributedString.init(string: "나중에 결정하시겠어요?")
        let attributes: [NSAttributedString.Key : Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                          .font: UIFont.boldSystemFont(ofSize: 12)]
        let range = NSRange(location: 0, length: attributedString.length)
        
        attributedString.addAttributes(attributes, range: range)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.appColor(.ppsGray1), for: .normal)
        button.addTarget(self, action: #selector(skipButtonDidTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var doneButton: BrandButton = {
       
        let button = BrandButton(title: "만들기", isBold: true, isFill: false)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatingStudyRuleViewModel.bind { [self] study in
            changeBorderColor(of: settingStudyGeneralRuleView, when: study.generalRuleIsEmpty)
            changeBorderColor(of: settingStudyFreeRuleView, when: study.freeRuleIsEmpty)
            if !study.generalRuleIsEmpty || !study.freeRuleIsEmpty {
                doneButton.fillIn(title: "만들기")
                doneButton.isEnabled = true
                creatingStudyRuleSkipButton.isHidden = true
            } else {
                doneButton.fillOut(title: "만들기")
                doneButton.isEnabled = false
                creatingStudyRuleSkipButton.isHidden = false
            }
        }
        
        view.backgroundColor = .systemBackground
        title = "스터디 만들기"
        
        addsubViews()
        setNavigation()
        settingStudyGeneralRuleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(generalRuleViewTapped)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    @objc private func generalRuleViewTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let studyGeneralRuleVC = storyboard.instantiateViewController(withIdentifier: "CreatingStudyGeneralRuleViewController") as! CreatingStudyGeneralRuleViewController

        studyGeneralRuleVC.generalRuleViewModel.generalRule = creatingStudyRuleViewModel.study.generalRule ?? GeneralStudyRule()
        studyGeneralRuleVC.doneButtonDidTapped = { rule in
            self.creatingStudyRuleViewModel.study.generalRule = rule
        }
        
        studyGeneralRuleVC.navigationItem.title = "규칙"
        studyGeneralRuleVC.navigationItem.titleView?.tintColor = .black
        studyGeneralRuleVC.navigationItem.rightBarButtonItem = closeButton
        
        let vc = UINavigationController(rootViewController: studyGeneralRuleVC)

        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func freeRuleViewTapped() {
        
        let studyFreeRuleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatingStudyFreeRuleViewController") as! CreatingStudyFreeRuleViewController
        
        studyFreeRuleVC.viewDidUpdated = { textView in
            textView.text = self.creatingStudyRuleViewModel.study.freeRule
        }
        studyFreeRuleVC.completeButtonTapped = { freeRule in
            self.creatingStudyRuleViewModel.study.freeRule = freeRule
        }
        
        studyFreeRuleVC.navigationItem.title = "진행방식"
        studyFreeRuleVC.navigationItem.titleView?.tintColor = .black
        studyFreeRuleVC.navigationItem.rightBarButtonItem = closeButton
        
        let vc = UINavigationController(rootViewController: studyFreeRuleVC)
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @objc private func skipButtonDidTapped() {
        creatingStudyRuleViewModel.postNewStudy {
            let nextVC = CreatingStudyCompleteViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc private func doneButtonTapped() {
  
        creatingStudyRuleViewModel.postNewStudy {
            let nextVC = CreatingStudyCompleteViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func closeButtonDidTapped() {

        self.dismiss(animated: true)
    }
    
    private func setNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.setBrandNavigation()
        self.navigationItem.title = "스터디 만들기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func changeBorder(color: AssetColor, of settingView: UIView) {
        settingView.layer.borderColor = UIColor.appColor(color).cgColor
    }
    
    private func addsubViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(settingStudyGeneralRuleView)
        view.addSubview(settingStudyFreeRuleView)
        view.addSubview(creatingStudyRuleSkipButton)
        view.addSubview(doneButton)
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 50, leading: view.leadingAnchor, leadingConstant: 20)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 30, leading: titleLabel.leadingAnchor)
        settingStudyGeneralRuleView.anchor(top: subTitleLabel.bottomAnchor, topConstant: 25, leading: titleLabel.leadingAnchor, trailing: view.trailingAnchor, trailingConstant: 20, height: 88)
        settingStudyFreeRuleView.anchor(top: settingStudyGeneralRuleView.bottomAnchor, topConstant: 20, leading: titleLabel.leadingAnchor, trailing: settingStudyGeneralRuleView.trailingAnchor, height: 88)
        creatingStudyRuleSkipButton.anchor(bottom: doneButton.topAnchor, bottomConstant: 21)
        creatingStudyRuleSkipButton.centerX(inView: view)
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 40, leading: titleLabel.leadingAnchor, trailing: settingStudyGeneralRuleView.trailingAnchor)
    }
    
    func changeBorderColor(of view: UIView, when ruleIsEmpty: Bool) {
        if ruleIsEmpty {
            view.layer.borderColor = UIColor.appColor(.ppsGray2).cgColor
        } else {
            view.layer.borderColor = UIColor.appColor(.keyColor1).cgColor
        }
    }
}
