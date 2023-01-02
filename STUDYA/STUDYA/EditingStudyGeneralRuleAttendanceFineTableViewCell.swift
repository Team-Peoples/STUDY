//
//  EditingStudyGeneralRuleAttendanceFineTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

class EditingStudyGeneralRuleAttendanceFineTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EditingStudyGeneralRuleAttendanceFineTableViewCell"
    
    let fineTitleLabel = CustomLabel(title: "벌금 규칙", tintColor: .ppsBlack, size: 16, isBold: true)
    let fineDescriptionLabel = CustomLabel(title: "* 출석체크 시, 입력하신 규칙에 따라 벌금이 자동으로 계산돼요.", tintColor: .ppsGray1, size: 12)
    
    let perLateMinuteFieldLabel = CustomLabel(title: "지각", tintColor: .ppsBlack, size: 16)
    let perLateMinuteFieldBehindLabel = CustomLabel(title: "분당", tintColor: .ppsBlack, size: 16)
    let latenessFineFieldBehindLabel = CustomLabel(title: "원", tintColor: .ppsBlack, size: 16)
    let absenceFineCountLabel = CustomLabel(title: "결석 1회당", tintColor: .ppsBlack, size: 16)
    let absenceFineFieldBehindLabel = CustomLabel(title: "원", tintColor: .ppsBlack, size: 16)
    
    /// 벌금규칙
    let perLateMinuteField = RoundedNumberField(numPlaceholder: nil, centerAlign: true)
    let latenessFineField = RoundedNumberField(numPlaceholder: 0, centerAlign: false, isPicker: false, isNecessary: true)
    let absenceFineField = RoundedNumberField(numPlaceholder: 0, centerAlign: false, isPicker: false, isNecessary: true)
    
    var perLateMinuteFieldAction: (Int?) -> Void = { perLateMinute in }
    var latenessFineFieldAction: (Int?) -> Void = { latenessFine in }
    var absenceFineFieldAction: (Int?) -> Void = { absenceFine in }
    
    lazy var fineDimmingView = UIView(backgroundColor: .white, alpha: 0.5)

    // MARK: - Initialization
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        perLateMinuteField.delegate = self
        latenessFineField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        absenceFineField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func roundedNumberFieldDidChanged(_ sender: RoundedNumberField) {
    
        switch sender {
        case perLateMinuteField:
            perLateMinuteFieldAction(perLateMinuteField.text?.toInt())
        case latenessFineField:
            latenessFineFieldAction(latenessFineField.text?.toInt() == 0 ? nil : latenessFineField.text?.toInt())
        case absenceFineField:
            absenceFineFieldAction(absenceFineField.text?.toInt() == 0 ? nil : absenceFineField.text?.toInt())
        default:
            return
        }
    }
    
    func fineDimmingViewAddTapGesture(target: Any?, action: Selector) {
        print("초기화","🔥")
        fineDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        selectionStyle = .none
        
        contentView.addSubview(fineTitleLabel)
        contentView.addSubview(fineDescriptionLabel)
        contentView.addSubview(perLateMinuteFieldLabel)
        contentView.addSubview(perLateMinuteField)
        contentView.addSubview(perLateMinuteFieldBehindLabel)
        contentView.addSubview(latenessFineField)
        contentView.addSubview(latenessFineFieldBehindLabel)
        contentView.addSubview(absenceFineCountLabel)
        contentView.addSubview(absenceFineField)
        contentView.addSubview(absenceFineFieldBehindLabel)
        contentView.addSubview(fineDimmingView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        fineTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(18)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        fineDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(fineTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(fineTitleLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        perLateMinuteFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(fineDescriptionLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(40)
        }
        
        perLateMinuteField.snp.makeConstraints { make in
            make.top.equalTo(perLateMinuteFieldLabel.snp.bottom).offset(3)
            make.leading.equalTo(fineDescriptionLabel)
            make.width.equalTo(75)
        }
        
        perLateMinuteFieldBehindLabel.snp.makeConstraints { make in
            make.centerY.equalTo(perLateMinuteField)
            make.width.equalTo(30)
            make.leading.equalTo(perLateMinuteField.snp.trailing).offset(2)
        }
        
        latenessFineField.snp.makeConstraints { make in
            make.centerY.equalTo(perLateMinuteFieldBehindLabel)
            make.leading.equalTo(perLateMinuteFieldBehindLabel.snp.trailing).offset(2)
            make.width.greaterThanOrEqualTo(150)
        }
        
        latenessFineFieldBehindLabel.snp.makeConstraints { make in
            make.centerY.equalTo(latenessFineField)
            make.leading.equalTo(latenessFineField.snp.trailing).offset(2)
            make.width.equalTo(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(40)
        }
        
        absenceFineCountLabel.snp.makeConstraints { make in
            make.top.equalTo(perLateMinuteField.snp.bottom).offset(20)
            make.leading.equalTo(perLateMinuteField)
        }
        
        absenceFineField.snp.makeConstraints { make in
            make.top.equalTo(absenceFineCountLabel.snp.bottom).offset(3)
            make.leading.equalTo(perLateMinuteField)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        absenceFineFieldBehindLabel.snp.makeConstraints { make in
            make.centerY.equalTo(absenceFineField)
            make.leading.equalTo(absenceFineField.snp.trailing).offset(2)
            make.width.equalTo(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(40)
        }
        fineDimmingView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}

extension EditingStudyGeneralRuleAttendanceFineTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == perLateMinuteField {
            perLateMinuteFieldAction(textField.text?.toInt())
        }
    }
}
