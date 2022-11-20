//
//  AttendanceIndividualInfoTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceIndividualInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AttendanceInfoTableViewCell"
    
    internal let view: RoundableView = {
        
        let v = RoundableView(cornerRadius: 24)
        
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    private let profileView = ProfileImageView(size: 40)
    private let nickNameLabel = CustomLabel(title: "니이이이이이이이익넴", tintColor: .ppsGray1, size: 16, isBold: true)
    private let attendanceStatusView: AttendanceStatusCapsuleView = {
       
        let v = AttendanceStatusCapsuleView(color: .attendedMain)
        
        v.setTitle("출석")
        
        return v
    }()
    
    private let penaltyLabel = CustomLabel(title: "10000", tintColor: .ppsBlack, size: 18, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(view)
        
        view.addSubview(profileView)
        view.addSubview(nickNameLabel)
        view.addSubview(attendanceStatusView)
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
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(10)
            make.top.equalTo(profileView.snp.top)
        }
        attendanceStatusView.anchor(top: nickNameLabel.bottomAnchor, topConstant: 8, leading: nickNameLabel.leadingAnchor, width: 32, height: 16)
        penaltyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
