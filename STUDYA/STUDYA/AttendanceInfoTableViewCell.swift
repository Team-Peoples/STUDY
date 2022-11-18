//
//  AttendanceInfoTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AttendanceInfoTableViewCell"
    
    internal let view: RoundableView = {
       
        let v = RoundableView(cornerRadius: 24)
        
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    private let profileView = ProfileImageView(size: 40)
    private let nickNameLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 16, isBold: true)
    private let attendanceStatusLabel: UILabel = {
        
        let l = UILabel(frame: .zero)
        
        l.text = "출석"
        l.backgroundColor = .appColor(.attendedMain)
        l.layer.cornerRadius = 8
        
        return l
    }()
    private let penaltyLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 18, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(view)
        
        view.addSubview(profileView)
        view.addSubview(nickNameLabel)
        view.addSubview(attendanceStatusLabel)
        view.addSubview(penaltyLabel)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(9)
        }
        profileView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(20)
            make.centerY.equalTo(view)
        }
        attendanceStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(10)
            make.top.equalTo(profileView.snp.top)
        }
        penaltyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
