//
//  MainSixthETCTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/30.
//

import UIKit

class MainSixthETCTableViewCell: UITableViewCell {
    
    static let identifier = "MainSixthETCTableViewCell"
    
    internal var currentStudyID: Int?
    internal var currentStudyName: String?
    
    internal var navigatableSwitchSyncableDelegate: (Navigatable & SwitchSyncable)!
    
    private let infoBackgroundView = RoundableView(cornerRadius: 15)
    private let memberBackgroundView = RoundableView(cornerRadius: 15)
    private let studyInfoImageView = UIImageView(image: UIImage(named: "studyInformation"))
    private let studyInfoLabel = CustomLabel(title: "  스터디 정보", tintColor: .ppsBlack, size: 14)
    private let membersImageView = UIImageView(image: UIImage(named: "members"))
    private let membersLabel = CustomLabel(title: "  멤버 관리", tintColor: .ppsBlack, size: 14)
    private let informationButton = UIButton()
    private let membersButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        informationButton.addTarget(self, action: #selector(informationButtonTapped), for: .touchUpInside)
        membersButton.addTarget(self, action: #selector(membersButtonTapped), for: .touchUpInside)
        
        contentView.backgroundColor = .systemBackground
        infoBackgroundView.backgroundColor = .appColor(.background2)
        memberBackgroundView.backgroundColor = .appColor(.background2)
        
        contentView.addSubview(infoBackgroundView)
        contentView.addSubview(memberBackgroundView)
        infoBackgroundView.addSubview(studyInfoImageView)
        infoBackgroundView.addSubview(studyInfoLabel)
        infoBackgroundView.addSubview(informationButton)
        memberBackgroundView.addSubview(membersImageView)
        memberBackgroundView.addSubview(membersLabel)
        memberBackgroundView.addSubview(membersButton)
        
        infoBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView).inset(18)
            make.leading.equalTo(contentView.snp.leading).inset(14)
        }
        memberBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalTo(infoBackgroundView)
            make.leading.equalTo(infoBackgroundView.snp.trailing).offset(12)
            make.trailing.equalTo(contentView).inset(14)
            make.width.equalTo(infoBackgroundView)
        }
        studyInfoImageView.snp.makeConstraints { make in
            make.leading.equalTo(infoBackgroundView.snp.leading).inset(40)
            make.centerY.equalTo(infoBackgroundView)
        }
        studyInfoLabel.snp.makeConstraints { make in
            make.trailing.equalTo(infoBackgroundView.snp.trailing).inset(40)
            make.centerY.equalTo(infoBackgroundView)
        }
        membersImageView.snp.makeConstraints { make in
            make.leading.equalTo(memberBackgroundView.snp.leading).inset(45)
            make.centerY.equalTo(memberBackgroundView)
        }
        membersLabel.snp.makeConstraints { make in
            make.trailing.equalTo(memberBackgroundView.snp.trailing).inset(45)
            make.centerY.equalTo(memberBackgroundView)
        }
        informationButton.snp.makeConstraints { make in
            make.edges.equalTo(infoBackgroundView)
        }
        membersButton.snp.makeConstraints { make in
            make.edges.equalTo(memberBackgroundView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func informationButtonTapped() {
        let storyboard = UIStoryboard(name: StudyInfoViewController.identifier, bundle: nil)
        let nextVC  = storyboard.instantiateViewController(withIdentifier: StudyInfoViewController.identifier) as! StudyInfoViewController
        guard let currentStudyID = currentStudyID, let currentStudyName = currentStudyName else { return }
        
        nextVC.studyID = currentStudyID
        nextVC.title = currentStudyName
        
        navigatableSwitchSyncableDelegate.syncSwitchWith(nextVC: nextVC)
        navigatableSwitchSyncableDelegate.push(vc: nextVC)
    }
    
    @objc private func membersButtonTapped() {
        guard let currentStudyID = currentStudyID, let currentStudyName = currentStudyName else { return }
        let nextVC = MemberViewController()
        
        nextVC.currentStudyID = currentStudyID
        nextVC.title = currentStudyName
        
        navigatableSwitchSyncableDelegate.syncSwitchWith(nextVC: nextVC)
        navigatableSwitchSyncableDelegate.push(vc: nextVC)
    }
}
