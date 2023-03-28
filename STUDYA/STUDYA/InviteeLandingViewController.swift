//
//  InviteeLandingViewController.swift
//  STUDYA
//
//  Created by 서동운 on 3/27/23.
//

import UIKit

class InviteeLandingViewController: UIViewController {
    
    let study: Study
    let memberCount: Int
    
    let titleLabel = CustomLabel(title: "스터디에\n초대되었어요!", tintColor: .ppsBlack, size: 24, isBold: true, isNecessaryTitle: false)
    let studyInformationBackgroundView = UIView(backgroundColor: .appColor(.background))
    let studyCategoryBackgroundView = UIView(backgroundColor: .appColor(.background))
    let studyCategoryLabel = CustomLabel(title: String(), tintColor: .keyColor1, size: 16)
    let roundedRectangleInFrontOfstudyNameLabel = UIView(backgroundColor: .appColor(.subColor2), alpha: 1, cornerRadius: 4)
    let studyNameLabel = CustomLabel(title: String(), tintColor: .keyColor1, size: 18, isBold: true)
    let memberLogo = UIImageView(image: UIImage(named: "member"))
    let memberCountLabel = CustomLabel(title: String(), tintColor: .ppsBlack, size: 12)
    let studyTypeLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 12)
    let separater = UIView(backgroundColor: .appColor(.keyColor1))
    let studyOwnerTitleLabel = CustomLabel(title: "스터디장", tintColor: .whiteLabel, size: 10, isBold: true)
    let studyOwnerNicknameLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 12, isBold: true)
    let studyOwnerRitleBackgroundView = UIView(backgroundColor: .appColor(.keyColor1), cornerRadius: 10)
    let roundedRectangleInFrontOfstudyIntroductionLabel = UIView(backgroundColor: .appColor(.subColor2), alpha: 1, cornerRadius: 4)
    let studyIntroductionLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 12)
    let studyJoinButton = CustomButton(fontSize: 20, isBold: true, normalBackgroundColor: .keyColor1, normalTitleColor: .whiteLabel, normalTitle: "참여하기", radiusIfNotCapsule: 25)
    
    init(study: Study, memberCount: Int) {
        self.study = study
        self.memberCount = memberCount
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetting()
        configureViews()
        
        updateViews(with: study, memberCount: memberCount)
    }
    
    private func initialSetting() {
        studyIntroductionLabel.numberOfLines = 2
        
        studyInformationBackgroundView.configureBorder(color: .ppsGray2, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .ppsGray2, width: 1, radius: 14)
        studyJoinButton.addTarget(self, action: #selector(joinStudy), for: .touchUpInside)
    }
    
    @objc private func joinStudy() {
        guard let studyID = study.id else { return }
        
        Network.shared.joinStudy(id: studyID) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func updateViews(with study: Study, memberCount: Int) {
        
        if let studyCategory = study.category {
            studyCategoryLabel.text = StudyCategory(rawValue: studyCategory)?.translatedKorean
        }
        if let studyName = study.studyName {
            studyNameLabel.text = studyName
        }
        
        memberCountLabel.text = memberCount.toString()
        
        let studyOn = study.studyOn
        let studyOff = study.studyOff
        
        switch (studyOn, studyOff) {
        case (true, true):
            studyTypeLabel.text = OnOff.onoff.translatedKorean
        case (false, true):
            studyTypeLabel.text = OnOff.off.translatedKorean
        case (true, false):
            studyTypeLabel.text = OnOff.on.translatedKorean
        case (false, false):
            studyTypeLabel.text = nil
        }
        
        if let studyOwnerNickname = study.ownerNickname {
            studyOwnerNicknameLabel.text = studyOwnerNickname
        }
        if let studyIntroduction = study.studyIntroduction {
            studyIntroductionLabel.text = studyIntroduction
        }
    }
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(studyInformationBackgroundView)
        
        studyInformationBackgroundView.addSubview(roundedRectangleInFrontOfstudyNameLabel)
        studyInformationBackgroundView.addSubview(studyNameLabel)
        studyInformationBackgroundView.addSubview(memberLogo)
        studyInformationBackgroundView.addSubview(memberCountLabel)
        studyInformationBackgroundView.addSubview(studyTypeLabel)
        studyInformationBackgroundView.addSubview(separater)
        studyInformationBackgroundView.addSubview(studyOwnerRitleBackgroundView)
        studyOwnerRitleBackgroundView.addSubview(studyOwnerTitleLabel)
        
        studyInformationBackgroundView.addSubview(studyOwnerNicknameLabel)
        studyInformationBackgroundView.addSubview(roundedRectangleInFrontOfstudyIntroductionLabel)
        studyInformationBackgroundView.addSubview(studyIntroductionLabel)
        
        view.addSubview(studyCategoryBackgroundView)
        studyCategoryBackgroundView.addSubview(studyCategoryLabel)
        
        view.addSubview(studyJoinButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        studyInformationBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        studyCategoryBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(studyInformationBackgroundView.snp.top)
            make.height.equalTo(28)
            make.leading.equalTo(studyInformationBackgroundView).inset(25)
        }
        studyCategoryLabel.snp.makeConstraints { make in
            make.edges.equalTo(studyCategoryBackgroundView).inset(UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15))
        }
        roundedRectangleInFrontOfstudyNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(studyNameLabel)
            make.top.bottom.equalTo(studyNameLabel).inset(1)
            make.trailing.equalTo(studyNameLabel.snp.leading).offset(-4)
            make.width.equalTo(4)
        }
        studyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(studyInformationBackgroundView).inset(20)
            make.leading.equalTo(studyInformationBackgroundView).inset(23)
        }
        memberLogo.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.trailing.equalTo(memberCountLabel.snp.leading).offset(-2)
            make.centerY.equalTo(memberCountLabel)
        }
        memberCountLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(studyInformationBackgroundView).inset(12)
        }
        studyTypeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(studyInformationBackgroundView).inset(12)
            make.top.equalTo(memberCountLabel.snp.bottom).offset(1)
        }
        separater.snp.makeConstraints { make in
            make.top.equalTo(studyNameLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(studyInformationBackgroundView).inset(10)
            make.height.equalTo(1)
        }
        studyOwnerRitleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(separater.snp.bottom).offset(6)
            make.leading.equalTo(studyInformationBackgroundView).inset(15)
        }
        studyOwnerTitleLabel.snp.makeConstraints { make in
            make.edges.equalTo(studyOwnerRitleBackgroundView).inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        studyOwnerNicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(studyOwnerRitleBackgroundView.snp.trailing).offset(4)
            make.centerY.equalTo(studyOwnerRitleBackgroundView)
        }
        roundedRectangleInFrontOfstudyIntroductionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(studyIntroductionLabel)
            make.top.bottom.equalTo(studyIntroductionLabel).inset(1)
            make.trailing.equalTo(studyIntroductionLabel.snp.leading).offset(-4)
            make.width.equalTo(4)
        }
        studyIntroductionLabel.snp.makeConstraints { make in
            make.top.equalTo(studyOwnerRitleBackgroundView.snp.bottom).offset(6)
            make.leading.trailing.equalTo(studyInformationBackgroundView).inset(24)
            make.bottom.equalTo(studyInformationBackgroundView).inset(12)
        }
        studyJoinButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
