//
//  AttendanceBottomIndividualUpdateView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/23.
//

import UIKit

final class AttendanceBottomIndividualUpdateView: FullDoneButtonButtomView {
    
    internal var viewModel: AttendancesModificationViewModel?
    internal var indexPath: IndexPath? {
        didSet {
            guard let viewModel = viewModel, let indexPath = indexPath else { return }
            
            let attendanceInformation = viewModel.attendancesForATime?.value[indexPath.item]
            
            nicknameLabel.text = attendanceInformation?.userID  //🛑여기 userID아니고 닉네임
//            🛑프로필 이미지 넣기
        }
    }
    
    private let profileImageView = ProfileImageView(size: 40)
    private let nicknameLabel = CustomLabel(title: "다나카상", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {
       
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .appColor(.ppsGray3)
        
        return v
    }()
    private lazy var attendedButton = CustomButton(fontSize: 14, isBold: true, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "출석", selectedBackgroundColor: .attendedMain, selectedTitleColor: .whiteLabel, selectedBorderColor: .attendedMain, contentEdgeInsets: UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23), target: self, action: #selector(buttonTapped))
    private lazy var lateButton = CustomButton(fontSize: 14, isBold: true, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "지각", selectedBackgroundColor: .lateMain, selectedTitleColor: .whiteLabel, selectedBorderColor: .lateMain, contentEdgeInsets: UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23), target: self, action: #selector(buttonTapped))
    private lazy var absentButton = CustomButton(fontSize: 14, isBold: true, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "결석", selectedBackgroundColor: .absentMain, selectedTitleColor: .whiteLabel, selectedBorderColor: .absentMain, contentEdgeInsets: UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23), target: self, action: #selector(buttonTapped))
    private lazy var allowedButton = CustomButton(fontSize: 14, isBold: true, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "사유", selectedBackgroundColor: .allowedMain, selectedTitleColor: .whiteLabel, selectedBorderColor: .allowedMain, contentEdgeInsets: UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23), target: self, action: #selector(buttonTapped))
    private lazy var stackView: UIStackView = {
       
        let v = UIStackView(arrangedSubviews: [attendedButton, lateButton, absentButton, allowedButton])
        
        v.spacing = 5
        v.axis = .horizontal
        v.distribution = .fillEqually
        
        return v
    }()
    private lazy var penaltyFeeInputField: PurpleRoundedInputField = {
       
        let f = PurpleRoundedInputField(target: nil, action: nil)
        
        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
        f.leftViewMode = .always
        f.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 0))
        f.rightViewMode = .always
        f.attributedPlaceholder = NSAttributedString(string: "0", attributes: [.foregroundColor: UIColor.appColor(.ppsGray2), .font: UIFont.boldSystemFont(ofSize: 16)])
        f.keyboardType = .numberPad
        f.isSecureTextEntry = false
        f.textAlignment = .right
        f.textColor = .appColor(.ppsBlack)
        
        let l = CustomLabel(title: "벌금", tintColor: .ppsBlack, size: 16)
        
        f.addSubview(l)
        l.snp.makeConstraints { make in
            make.leading.equalTo(f).inset(22)
            make.centerY.equalTo(f)
        }
        
        return f
    }()
    
    override init(doneButtonTitle: String) {
        super.init(doneButtonTitle: doneButtonTitle)
        
        backgroundColor = .systemBackground

        penaltyFeeInputField.delegate = self
        
        doneButton.isSelected = false
        titleButton.isSelected = false
        
        addSubviews()
        setConstraints()
        configureDoneButton(on: self, under: penaltyFeeInputField, constant: 52)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if attendedButton.isSelected {
            attendedButton.isSelected = false
        }
        if lateButton.isSelected {
            lateButton.isSelected = false
        }
        if absentButton.isSelected {
            absentButton.isSelected = false
        }
        if allowedButton.isSelected {
            allowedButton.isSelected = false
        }
        
        guard let sender = sender as? CustomButton else { return }
        sender.isSelected = true
    }
    
    override func doneButtonTapped() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        endEditing(true)
    }
    
    private func addSubviews() {
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(separator)
        addSubview(stackView)
        addSubview(penaltyFeeInputField)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(20)
            make.top.equalTo(self.snp.top).inset(30)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(self)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(30)
            make.top.equalTo(separator).offset(20)
        }
        penaltyFeeInputField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(18)
        }
    }
}

extension AttendanceBottomIndividualUpdateView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        guard finalText.count <= 6 else { return false }
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        guard string.checkOnlyNumbers() || isBackSpace == -92 else { return false }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
        if let groupingSeparator = formatter.groupingSeparator {
            
            if string == groupingSeparator {
                return true
            }
            
            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string.isEmpty {
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                   let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                    
                    textField.text = formattedText
                    return false
                }
            }
        }
        return true
    }
}
