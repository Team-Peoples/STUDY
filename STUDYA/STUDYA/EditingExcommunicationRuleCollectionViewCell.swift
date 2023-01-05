//
//  EditingExcommunicationRuleCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

final class EditingExcommunicationRuleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EditingExcommunicationRuleCollectionViewCell"
    
    var excommunication = Excommunication()
    var excommunicationRuleEditDoneAction: (Excommunication) -> Void = { Excommunication in }
    
    private let excommunicationTitleLabel = CustomLabel(title: "강퇴 조건", tintColor: .ppsBlack, size: 16, isBold: true)
    private let excommunicationDescriptionLabel = CustomLabel(title: "* 멤버가 강퇴 조건에 도달하면 관리자에게 알림이 전송돼요.\n* 지각과 결석 조건을 모두 입력하면, 둘 중 하나만 만족해도 강퇴 조건에 도달해요.", tintColor: .ppsGray1, size: 12)
    internal let latenessCountField = RoundedNumberField(numPlaceholder: 0, centerAlign: false, isPicker: false)
    private let latenessCountFieldBehindLabel = CustomLabel(title: "번 지각 시", boldPart: "지각")
    internal let absenceCountField = RoundedNumberField(numPlaceholder: 0, centerAlign: false, isPicker: false)
    private let absenceCountFieldBehindLabel = CustomLabel(title: "번 결석 시", boldPart: "결석")
    
    var latenessCountFieldAction: (Int?) -> Void = { latenessCount in }
    var absenceCountFieldAction: (Int?) -> Void = { absenceCount in }
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latenessCountField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        absenceCountField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        
        configureViews()
        setConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    
    @objc func roundedNumberFieldDidChanged(_ sender: RoundedNumberField) {
        switch sender {
        case latenessCountField:
            excommunication.lateness = sender.text?.toInt()
        case absenceCountField:
            excommunication.absence = sender.text?.toInt()
        default:
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Configure
    
    func configureViews() {
        backgroundColor = .systemBackground
        
        contentView.addSubview(excommunicationTitleLabel)
        contentView.addSubview(excommunicationDescriptionLabel)

        contentView.addSubview(latenessCountField)
        contentView.addSubview(latenessCountFieldBehindLabel)
        contentView.addSubview(absenceCountField)
        contentView.addSubview(absenceCountFieldBehindLabel)
        
    }
    // MARK: - Setting Constraints
    
    func setConstaints() {
        
        excommunicationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(17)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        excommunicationDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(excommunicationTitleLabel.snp.bottom)
            .offset(5)
            make.leading.equalTo(excommunicationTitleLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        latenessCountField.snp.makeConstraints { make in
            make.top.equalTo(excommunicationDescriptionLabel.snp.bottom).offset(12)
            make.leading.equalTo(excommunicationDescriptionLabel)
        }
        
        latenessCountFieldBehindLabel.snp.makeConstraints { make in
            make.leading.equalTo(latenessCountField.snp.trailing).offset(10)
            make.centerY.equalTo(latenessCountField)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.width.equalTo(70)
        }
        absenceCountField.snp.makeConstraints { make in
            make.top.equalTo(latenessCountField.snp.bottom).offset(13)
            make.leading.equalTo(latenessCountField)
        }
        absenceCountFieldBehindLabel.snp.makeConstraints { make in
            make.leading.equalTo(absenceCountField.snp.trailing).offset(10)
            make.centerY.equalTo(absenceCountField)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.width.equalTo(70)
        }
    }
}
