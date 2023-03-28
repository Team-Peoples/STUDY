//
//  AttendanceBottomIndividualUpdateViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/23.
//

import UIKit

final class AttendanceBottomIndividualUpdateViewController: FullDoneButtonButtonViewController {
    
    internal var viewModel: AttendancesModificationViewModel?
    
    private var singleUserAnAttendanceInformation: SingleUserAnAttendanceInformation?
    private let profileImageView = ProfileImageContainerView(size: 40)
    private let nicknameLabel = CustomLabel(title: "?", tintColor: .ppsBlack, size: 16, isBold: true)
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
    private lazy var fineInputField: PurpleRoundedInputField = {
       
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        fineInputField.delegate = self
        enableDoneButton()
        
        addSubviews()
        setConstraints()
        configureDoneButton(under: fineInputField, constant: 52)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let sender = sender as? CustomButton else { return }
        
        switch sender {
        case attendedButton:
            singleUserAnAttendanceInformation?.attendanceStatus = Constant.attendance
        case lateButton:
            singleUserAnAttendanceInformation?.attendanceStatus = Constant.late
        case absentButton:
            singleUserAnAttendanceInformation?.attendanceStatus = Constant.absent
        case allowedButton:
            singleUserAnAttendanceInformation?.attendanceStatus = Constant.allowed
        default: break
        }
        
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
        
        sender.isSelected = true
    }
    
    override func doneButtonTapped() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard let viewModel = viewModel,
              let strFine = fineInputField.text,
              let fine = formatter.number(from: strFine) as? Int,
              let singleUserAnAttendanceInformation = singleUserAnAttendanceInformation,
              absentButton.isSelected || lateButton.isSelected || absentButton.isSelected || allowedButton.isSelected else { return }
        
        let newAttendanceInformation = SingleUserAnAttendanceInformationForPut(fine: fine, attendanceStatus: singleUserAnAttendanceInformation.attendanceStatus, userID: singleUserAnAttendanceInformation.userID, attendanceID: singleUserAnAttendanceInformation.attendanceID)

        viewModel.updateAttendance(newAttendanceInformation) {
            self.dismiss(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    internal func configure(with anUserAttendanceInformation: SingleUserAnAttendanceInformation, viewModel: AttendancesModificationViewModel) {
        self.viewModel = viewModel
        self.singleUserAnAttendanceInformation = anUserAttendanceInformation
        
        profileImageView.setImageWith(anUserAttendanceInformation.imageURL)
        nicknameLabel.text = anUserAttendanceInformation.nickName
        
        let attendance = AttendanceSeperator(inputString: anUserAttendanceInformation.attendanceStatus).attendance
        
        switch attendance {
        case .attended:
            attendedButton.isSelected = true
        case .late:
            lateButton.isSelected = true
        case .absent:
            absentButton.isSelected = true
        case .allowed:
            allowedButton.isSelected = true
        }
        
        fineInputField.text = anUserAttendanceInformation.fine.toString()
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(separator)
        view.addSubview(stackView)
        view.addSubview(fineInputField)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(20)
            make.top.equalTo(view.snp.top).inset(30)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(30)
            make.top.equalTo(separator).offset(20)
        }
        fineInputField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(18)
        }
    }
}

extension AttendanceBottomIndividualUpdateViewController: UITextFieldDelegate {
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
