//
//  EditingStudyGeneralRuleAttendanceTimeTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

class EditingStudyGeneralRuleAttendanceTimeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EditingStudyGeneralRuleAttendanceTimeTableViewCell"
    
    let attendanceTitleLabel = CustomLabel(title: "출결 규칙", tintColor: .ppsBlack, size: 16, isBold: true)
    let attendanceDescriptionLabel = CustomLabel(title: "* 결석 조건을 입력하지 않으면 스터디가 끝나는 시간으로 설정돼요.", tintColor: .ppsGray1, size: 12)
    let latenessRuleTimeFieldFrontLabel = CustomLabel(title: "스터디 시작 후", tintColor: .ppsBlack, size: 16)
    let latenessRuleTimeBehindLabel = CustomLabel(title: "분 부터 지각", boldPart: "지각")
    let absenceRuleTimeFieldFrontLabel = CustomLabel(title: "스터디 시작 후", tintColor: .ppsBlack, size: 16)
    let absenceRuleTimeFieldBehindLabel = CustomLabel(title: "분 부터 결석", boldPart: "결석")

    
    let latenessRuleTimeField = RoundedNumberField(numPlaceholder: nil, centerAlign: true)
    let absenceRuleTimeField = RoundedNumberField(numPlaceholder: nil, centerAlign: true)
    
    var latenessRuleTimeFieldAction: (Int?) -> Void = { latenessRuleTime in }
    var absenceRuleTimeFieldAction: (Int?) -> Void = { absenceRuleTime in }

    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        latenessRuleTimeField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        absenceRuleTimeField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func roundedNumberFieldDidChanged(_ sender: RoundedNumberField) {
        print(sender)
        switch sender {
        case latenessRuleTimeField:
            latenessRuleTimeFieldAction(sender.text?.toInt())
        case absenceRuleTimeField:
            absenceRuleTimeFieldAction(sender.text?.toInt())
        default:
            return
        }
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        selectionStyle = .none
        
        contentView.addSubview(attendanceTitleLabel)
        contentView.addSubview(attendanceDescriptionLabel)
        
        attendanceDescriptionLabel.numberOfLines = 0
        
        contentView.addSubview(latenessRuleTimeFieldFrontLabel)
        contentView.addSubview(latenessRuleTimeField)
        contentView.addSubview(latenessRuleTimeBehindLabel)
        contentView.addSubview(absenceRuleTimeFieldFrontLabel)
        contentView.addSubview(absenceRuleTimeField)
        contentView.addSubview(absenceRuleTimeFieldBehindLabel)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        attendanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(18)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        attendanceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(attendanceTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(attendanceTitleLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        latenessRuleTimeFieldFrontLabel.snp.makeConstraints { make in
            make.top.equalTo(attendanceDescriptionLabel.snp.bottom).offset(26)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(40)
            make.width.equalTo(92)
        }
        
        latenessRuleTimeField.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(75)
            make.leading.equalTo(latenessRuleTimeFieldFrontLabel.snp.trailing).offset(10)
            make.centerY.equalTo(latenessRuleTimeFieldFrontLabel)
        }
        
        latenessRuleTimeBehindLabel.snp.makeConstraints { make in
            make.leading.equalTo(latenessRuleTimeField.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(40)
            make.centerY.equalTo(latenessRuleTimeFieldFrontLabel)
            make.width.equalTo(78)
        }
        
        absenceRuleTimeFieldFrontLabel.snp.makeConstraints { make in
            make.top.equalTo(latenessRuleTimeFieldFrontLabel.snp.bottom).offset(40)
            make.leading.equalTo(latenessRuleTimeFieldFrontLabel)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(32)
            make.width.equalTo(92)
        }
        
        absenceRuleTimeField.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(75)
            make.leading.equalTo(absenceRuleTimeFieldFrontLabel.snp.trailing).offset(10)
            make.centerY.equalTo(absenceRuleTimeFieldFrontLabel)
        }
        
        absenceRuleTimeFieldBehindLabel.snp.makeConstraints { make in
            make.leading.equalTo(absenceRuleTimeField.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(40)
            make.centerY.equalTo(absenceRuleTimeFieldFrontLabel)
            make.width.equalTo(78)
        }
    }
}
