//
//  MainFourthAnnouncementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit
import SnapKit

class MainFourthAnnouncementTableViewCell: UITableViewCell {
    
    static let identifier = "MainFourthAnnouncementTableViewCell"
    
    internal var studyID: ID?
    internal var announcement: Announcement? {
        didSet {
            configureRedDot()
            
            guard let announcement = announcement else { return }
            
            titleLabel.text = announcement.title
            subTitleLabel.text = announcement.content
        }
    }
    
    private func configureRedDot() {

        if let _ = studyID, let announcementID = announcement?.id {
            configureRedDotWhenYesAnnouncement(announcementID: announcementID)
        } else {
            hideRedDotWhenNoAnnouncement()
        }
    }
    
    private func configureRedDotWhenYesAnnouncement(announcementID: ID) {
        
        if let preAnnouncementID = UserDefaults.standard.value(forKey: "checkedAnnouncementIDOfStudy\(studyID)") as? ID {
            configureRedDotWhenUserHaveCheckedAnyAnnouncementOfThisStudy(preAnnouncementID: preAnnouncementID, presentAnnouncementID: announcementID)
        } else {
            hideRedDotWhenUserHaveNeverCheckedAnnouncementOfThisStudy()
        }
    }
    
    private func configureRedDotWhenUserHaveCheckedAnyAnnouncementOfThisStudy(preAnnouncementID: ID, presentAnnouncementID: ID) {
        if preAnnouncementID >= presentAnnouncementID {
            redDot.isHidden = true
        } else {
            redDot.isHidden = false
        }
    }
    
    private func hideRedDotWhenUserHaveNeverCheckedAnnouncementOfThisStudy() {
        redDot.isHidden = false
    }
    
    private func hideRedDotWhenNoAnnouncement() {
        redDot.isHidden = true
    }
    
    internal var navigatable: Navigatable!
    
    private let announcementLabel = CustomLabel(title: "공지", tintColor: .keyColor1, size: 12, isBold: true)
    private lazy var titleLabel: CustomLabel = {
       
        let l = CustomLabel(title: "", tintColor: .ppsBlack, size: 12, isBold: true)
        l.numberOfLines = 1
        
        return l
    }()
    private lazy var subTitleLabel: CustomLabel = {
       
        let l = CustomLabel(title: "예정된 일정이 없어요 😴", tintColor: .ppsBlack, size: 12)
        l.numberOfLines = 1
        
        return l
    }()
    private lazy var redDot: CustomLabel = {
       
        let i = CustomLabel(title: "·", tintColor: .subColor1, size: 40, isBold: true)
        
        return i
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .appColor(.background2)
        
        contentView.addSubview(announcementLabel)
        contentView.addSubview(redDot)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        announcementLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(30)
            make.top.equalTo(contentView.snp.top).inset(14)
        }
        redDot.snp.makeConstraints { make in
            make.centerY.equalTo(announcementLabel).offset(-2)
            make.trailing.equalTo(announcementLabel.snp.leading).offset(-4)
//            make.width.height.equalTo(6)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(announcementLabel.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).inset(30)
            make.top.equalTo(announcementLabel.snp.top)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(30)
            make.top.equalTo(announcementLabel.snp.bottom).offset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
