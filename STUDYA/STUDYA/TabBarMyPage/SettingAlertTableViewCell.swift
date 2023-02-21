//
//  SettingAlertTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/24.
//

import UIKit

final class SettingAlertTableViewCell: UITableViewCell {
    
    static let identifier = "SettingAlertTableViewCell"
    
    internal var titleText: String? {
        didSet {
            titleLabel.text = titleText
            
            switch titleText {
            case "출석체크 시작 알림":
                subTitileLabel.text = "스터디 시작 10분 전"
            case "스터디 일정 임박 알림":
                subTitileLabel.text = "3시간 전"
            case "스터디 일정 예정 알림":
                subTitileLabel.text = "24시간 전"
            default:
                return
            }
        }
    }
    
    private lazy var titleLabel = CustomLabel(title: titleText ?? "알림 예정 시간", tintColor: .ppsBlack, size: 16)
    private lazy var subTitileLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 12)
    private let brandSwitch = BrandSwitch(isMasterSwitch: false)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitileLabel)
        contentView.addSubview(brandSwitch)

        selectionStyle = .none
        
        titleLabel.anchor(top: contentView.topAnchor, topConstant: 18, leading: contentView.leadingAnchor, leadingConstant: 20)
        subTitileLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 4, bottom: contentView.bottomAnchor, bottomConstant: 18,  leading: titleLabel.leadingAnchor)
        brandSwitch.anchor(trailing: contentView.trailingAnchor, trailingConstant: 20)
        brandSwitch.centerY(inView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
