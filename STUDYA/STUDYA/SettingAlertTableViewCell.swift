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
        }
    }
    
    private lazy var titleLabel = CustomLabel(title: titleText ?? "알림 예정 시간", tintColor: .ppsBlack, size: 16)
    private let brandSwitch = BrandSwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(brandSwitch)

        selectionStyle = .none
        
        titleLabel.anchor(leading: leadingAnchor, leadingConstant: 20)
        titleLabel.centerY(inView: self)
        brandSwitch.anchor(trailing: trailingAnchor, trailingConstant: 20)
        brandSwitch.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
