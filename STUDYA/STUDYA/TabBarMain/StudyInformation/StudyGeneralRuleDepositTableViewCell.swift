//
//  StudyGeneralRuleDepositTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

final class StudyGeneralRuleDepositTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StudyGeneralRuleDepositTableViewCell"
    
    let depositTitleLabel = CustomLabel(title: "보증금", tintColor: .ppsBlack, size: 16, isBold: true)
    let depositBehindLabel = CustomLabel(title: "원", tintColor: .ppsBlack, size: 16)
  
    /// 보증금
    let depositTextField = RoundedNumberField(numPlaceholder: 0, centerAlign: false, isPicker: false)
    
    var depositTextFieldAction: (Deposit) -> Void = { deposit in }
    
    lazy var depositDimmingView = UIView()

    // MARK: - Initialization
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        depositTextField.addTarget(self, action: #selector(roundedNumberFieldDidChanged), for: .editingChanged)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    
    @objc func roundedNumberFieldDidChanged(_ sender: RoundedNumberField) {

        switch sender {
        case depositTextField:
            depositTextFieldAction(depositTextField.text?.toInt() ?? 0)
        default:
            return
        }
    }
    
    
    // MARK: - Configure
    
    private func configureViews() {
        
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(depositTitleLabel)
        contentView.addSubview(depositTextField)
        contentView.addSubview(depositBehindLabel)
    }

    // MARK: - Setting Constraints
    
    private func setConstraints() {
        depositTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(18)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        depositTextField.snp.makeConstraints { make in
            make.top.equalTo(depositTitleLabel.snp.bottom).offset(7)
            make.leading.equalTo(depositTitleLabel)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(120)
        }
        depositBehindLabel.snp.makeConstraints { make in
            make.centerY.equalTo(depositTextField)
            make.width.equalTo(20)
            make.leading.equalTo(depositTextField.snp.trailing).offset(2)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(40)
        }
    }
}
