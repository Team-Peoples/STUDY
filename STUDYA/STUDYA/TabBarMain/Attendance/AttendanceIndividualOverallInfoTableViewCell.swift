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
    private let profileImageView = ProfileImageView(size: 40)
    private let nicknameLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 16, isBold: true)
    private let disclosureIndicatorImageView = UIImageView(image: UIImage(named: "smallDisclosureIndicator"))
    private let innerView: RoundableView = {
        
        let v = RoundableView(cornerRadius: 14)
        
        v.backgroundColor = .systemBackground
        
        return v
    }()
    private let attendCapsule = AttendanceStatusCapsuleView(color: .attendedMain)
    private let lateCapsule = AttendanceStatusCapsuleView(color: .lateMain)
    private let absentCapsule = AttendanceStatusCapsuleView(color: .absentMain)
    private let allowedCapsule = AttendanceStatusCapsuleView(color: .allowedMain)
    private lazy var capsuleStackView: UIStackView = {
       
        let v = UIStackView(arrangedSubviews: [attendCapsule, lateCapsule, absentCapsule, allowedCapsule])
        
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 2
        
        return v
    }()
    private let penaltyLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 18, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        contentView.addSubview(view)
        view.addSubview(profileImageView)
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
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(20)
            make.top.equalTo(view.snp.top).inset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
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
    
    internal func configureCell(with userAttendanceStatistics: UserAttendanceStatistics) {
        profileImageView.setImageWith(userAttendanceStatistics.profileImageURL)
        nicknameLabel.text = userAttendanceStatistics.nickName
        attendCapsule.setTitle(userAttendanceStatistics.attendedCount.toString())
        lateCapsule.setTitle(userAttendanceStatistics.lateCount.toString())
        absentCapsule.setTitle(userAttendanceStatistics.absentCount.toString())
        allowedCapsule.setTitle(userAttendanceStatistics.allowedCount.toString())
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let fine = formatter.string(from: NSNumber(value: userAttendanceStatistics.totalFine)) else { return }
        penaltyLabel.text = fine
    }
}
