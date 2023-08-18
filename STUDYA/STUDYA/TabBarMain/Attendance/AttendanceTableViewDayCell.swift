//
//  AttendanceTableViewDayCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/03/12.
//

import UIKit

final class AttendanceTableViewDayCell: UITableViewCell {
    
    // MARK: - Properties
    private let dayLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 16, isBold: true)
    private let timeLabel = CustomLabel(title: "", tintColor: .ppsGray2, size: 12)
    private let attendanceCapsuleView = AttendanceStatusCapsuleView(color: .attendedMain)
    private let fineLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 18, isBold: true)
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure
    
    internal func configureCell(with attendance: OneTimeAttendanceInformation) {
        let dayAndTime = DateFormatter.dayAndTimeFormatter.string(from: attendance.studyScheduleDateAndTime)
        let day = String(dayAndTime.prefix(2))
        
        let timeFirstIndex = dayAndTime.index(dayAndTime.endIndex, offsetBy: -5)
        let time = String(dayAndTime[timeFirstIndex...])
        
        let fine = attendance.fine?.toString() ?? "?"
        
        dayLabel.text = day + "일"
        timeLabel.text = time
        fineLabel.text = fine
        
        configureAttendanceLabel(with: attendance)
    }
    
    private func configureAttendanceLabel(with attendance: OneTimeAttendanceInformation) {
        switch attendance.attendanceStatus {
        case Constant.attendance:
            attendanceCapsuleView.configure(title: "출석", color: .attendedMain)
        case Constant.late:
            attendanceCapsuleView.configure(title: "지각", color: .lateMain)
        case Constant.absent:
            attendanceCapsuleView.configure(title: "결석", color: .absentMain)
        case Constant.allowed:
            attendanceCapsuleView.configure(title: "사유", color: .allowedMain)
        default: break
        }
    }
    
    private func configureViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(attendanceCapsuleView)
        contentView.addSubview(fineLabel)
        contentView.addSubview(timeLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).inset(35)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel).offset(2)
            make.leading.equalTo(dayLabel.snp.trailing).offset(10)
        }
        attendanceCapsuleView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(contentView).offset(46)
            make.width.equalTo(32)
            make.height.equalTo(16)
        }
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(35)
        }
    }
}
