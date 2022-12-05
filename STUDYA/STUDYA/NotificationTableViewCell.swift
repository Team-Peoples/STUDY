//
//  NotificationTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/04.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    static let identifier = "NotificationTableViewCell"
    
    private let backView = UIView(frame: .zero)
    private let titleLabel = CustomLabel(title: "아리가또", tintColor: .ppsGray1, size: 18)
    private let dateLabel = CustomLabel(title: "2022.06.01", tintColor: .ppsGray1, size: 12)
    private let contentLabel = CustomLabel(title: "오늘은 일본어를 배워봅니다. 코노야로들아.", tintColor: .ppsBlack, size: 16, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backView.configureBorder(color: .ppsGray3, width: 1, radius: 24)
        
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(contentLabel)
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.bottom.equalTo(contentView).inset(5)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).inset(20)
            make.top.equalTo(backView.snp.top).inset(17)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).inset(20)
            make.top.equalTo(backView.snp.top).inset(23)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
