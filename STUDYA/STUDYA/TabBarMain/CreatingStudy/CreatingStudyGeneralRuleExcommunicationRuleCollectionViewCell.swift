//
//  CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/02.
//

import UIKit

final class CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell"
    
    var generalRuleViewModel: GeneralRuleViewModel? {
        didSet {
            configure(generalRuleViewModel?.generalRule)
        }
    }
    
    private let titleLabel = CustomLabel(title: "강퇴 조건", tintColor: .ppsBlack, size: 16, isBold: true)
    private let descriptionLabel = CustomLabel(title: "* 멤버가 강퇴 조건에 도달하면 관리자에게 알림이 전송돼요.\n* 지각과 결석 조건을 모두 입력하면, 둘 중 하나만 만족해도\n강퇴 조건에 도달해요.", tintColor: .ppsGray1, size: 12)
    internal let lateNumberField = RoundedNumberField(numPlaceholder: nil, centerAlign: false, isNecessary: true)
    private let lateLabel = CustomLabel(title: "번 지각 시", boldPart: "지각")
    internal let absenceNumberField = RoundedNumberField(numPlaceholder: nil, centerAlign: false, isNecessary: true)
    private let absenceLabel = CustomLabel(title: "번 결석 시", boldPart: "결석")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        lateNumberField.delegate = self
        absenceNumberField.delegate = self
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(lateNumberField)
        addSubview(lateLabel)
        addSubview(absenceNumberField)
        addSubview(absenceLabel)
        
        titleLabel.anchor(top: topAnchor, topConstant: 17, leading: leadingAnchor, leadingConstant: 30)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 5, leading: titleLabel.leadingAnchor)
        lateNumberField.anchor(top: descriptionLabel.bottomAnchor, topConstant: 12, leading: titleLabel.leadingAnchor, trailing: lateLabel.leadingAnchor, trailingConstant: 9)
        lateNumberField.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width - 123).isActive = true
        lateLabel.centerY(inView: lateNumberField)
        lateLabel.anchor(trailing: trailingAnchor, trailingConstant: 30)
        absenceNumberField.anchor(top: lateNumberField.bottomAnchor, topConstant: 13, leading: lateNumberField.leadingAnchor, trailing: lateNumberField.trailingAnchor)
        absenceNumberField.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width - 123).isActive = true
        absenceLabel.centerY(inView: absenceNumberField)
        absenceLabel.anchor(trailing: lateLabel.trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ generalRule: GeneralStudyRule?) {
        lateNumberField.text = generalRule?.excommunication.lateness?.toString() ?? "--"
        absenceNumberField.text = generalRule?.excommunication.absence?.toString() ?? "--"
    }
}

extension CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == lateNumberField {
            generalRuleViewModel?.generalRule.excommunication.lateness = textField.text?.toInt()
        }
        if textField == absenceNumberField {
            generalRuleViewModel?.generalRule.excommunication.lateness = textField.text?.toInt()
        }
    }
}
