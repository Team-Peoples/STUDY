//
//  AttendanceIndividualOverallInfoTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/20.
//

import UIKit

final class AttendanceIndividualOverallInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AttendanceIndividualOverallInfoTableViewCell"
    
    private let view: RoundableView = {
        
        let v = RoundableView(cornerRadius: 24)
        
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    private let profileView = ProfileImageView(size: 40)
    private let nicknameLabel = CustomLabel(title: "닉네이이이이임", tintColor: .ppsGray1, size: 16, isBold: true)
    private let disclosureIndicatorImageView = UIImageView(image: UIImage(named: "smallDisclosureIndicator"))
    private let innerView: RoundableView = {
        
        let v = RoundableView(cornerRadius: 14)
        
        v.backgroundColor = .systemBackground
        
        return v
    }()
    private let attendCapsule: AttendanceStatusCapsuleView = {
        
        let v = AttendanceStatusCapsuleView(color: .attendedMain)
        
        v.setTitle("100")
        
        return v
    }()
    private let lateCapsule: AttendanceStatusCapsuleView = {
       
        let v = AttendanceStatusCapsuleView(color: .lateMain)
        
        v.setTitle("20")
        
        return v
    }()
    private let absentCapsule: AttendanceStatusCapsuleView = {
       
        let v = AttendanceStatusCapsuleView(color: .absentMain)
        
        v.setTitle("8")
        
        return v
    }()
    private let allowedCapsule: AttendanceStatusCapsuleView = {
       
        let v = AttendanceStatusCapsuleView(color: .allowedMain)
        
        v.setTitle("0")
        
        return v
    }()
    private lazy var capsuleStackView: UIStackView = {
       
        let v = UIStackView(arrangedSubviews: [attendCapsule, lateCapsule, absentCapsule, allowedCapsule])
        
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 2
        
        return v
    }()
    private let penaltyLabel = CustomLabel(title: "23,000", tintColor: .ppsGray1, size: 18, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        contentView.addSubview(view)
        view.addSubview(profileView)
        view.addSubview(nicknameLabel)
        view.addSubview(disclosureIndicatorImageView)
        view.addSubview(innerView)
        innerView.addSubview(capsuleStackView)
        innerView.addSubview(penaltyLabel)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.top.equalTo(contentView.snp.top)
        }
        profileView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(20)
            make.top.equalTo(view.snp.top).inset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileView.snp.trailing).offset(10)
        }
        disclosureIndicatorImageView.snp.makeConstraints { make in
            make.trailing.top.equalTo(view).inset(24)
        }
        innerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view).inset(12)
            make.height.equalTo(38)
        }
        capsuleStackView.snp.makeConstraints { make in
            make.leading.equalTo(innerView.snp.leading).inset(20)
            make.height.equalTo(16)
            make.width.equalTo(134)
            make.centerY.equalTo(innerView)
        }
        penaltyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(innerView.snp.trailing).inset(14)
            make.centerY.equalTo(innerView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
