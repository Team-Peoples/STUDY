//
//  AttendanceIndividualInfoTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceIndividualInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AttendanceIndividualInfoTableViewCell"
    
    internal var anUserAttendanceInformation: SingleUserAnAttendanceInformation? {
        didSet {
            guard let anUserAttendanceInformation = anUserAttendanceInformation else { return }
            let attendance = AttendanceSeperator(inputString: anUserAttendanceInformation.attendanceStatus).attendance
            
            attendanceStatusView.configure(title: attendance.korean, color: attendance.color)
            penaltyLabel.text = anUserAttendanceInformation.fine.toString()
//            🛑api되면 닉네임, 사진 넣기
        }
    }
    
    internal let view: RoundableView = {
        
        let v = RoundableView(cornerRadius: 24)
        
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    private let profileImageView = ProfileImageView(size: 40)
    private let nickNameLabel = CustomLabel(title: "닉네임", tintColor: .ppsGray1, size: 16, isBold: true)
    private let attendanceStatusView: AttendanceStatusCapsuleView = {
       
        let v = AttendanceStatusCapsuleView(color: .attendedMain)
        
        v.setTitle("오류")
        
        return v
    }()
    
    private let penaltyLabel = CustomLabel(title: "??", tintColor: .ppsBlack, size: 18, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(view)
        
        view.addSubview(profileImageView)
        view.addSubview(nickNameLabel)
        view.addSubview(attendanceStatusView)
        view.addSubview(penaltyLabel)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(9)
        }
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(20)
            make.centerY.equalTo(view)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(profileImageView.snp.top)
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
