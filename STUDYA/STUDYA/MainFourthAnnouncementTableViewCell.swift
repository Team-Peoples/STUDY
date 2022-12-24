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
    
    internal var announcement: Announcement? {
        didSet {
            if announcement != nil {
                titleLabel.text = announcement?.title
                subTitleLabel.text = announcement?.content
            }
        }
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .appColor(.background2)
        
        contentView.addSubview(announcementLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        announcementLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(30)
            make.top.equalTo(contentView.snp.top).inset(14)
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
