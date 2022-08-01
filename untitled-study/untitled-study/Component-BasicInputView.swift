//
//  Component.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

class BasicInputView: UIView {
    // MARK: - Properties
    
    private let nameLabel = UILabel()
    private var separator = UIView()
    let textField = UITextField()
    
    // MARK: - Actions
    
    func toggleSecureTextEntry() {
        if textField.isSecureTextEntry == true {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
    }
    
    func setSeparator(color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Life Cycle
    
    init(titleText: String, placeholderText: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isSecure: Bool?) {
        super.init(frame: .zero)
       
        addSubview(nameLabel)
        addSubview(textField)
        addSubview(separator)
        
        configureNameLabel(title: titleText)
        configureTextField(placeholder: placeholderText, keyboardType: keyBoardType, returnType: returnType, isSecure: isSecure)
        configureSeparator(color: CustomColor.defaultGray.color)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cofigure Views
    
    private func configureNameLabel(title: String) {
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.text = title
    }
    
    private func configureTextField(placeholder: String, keyboardType: UIKeyboardType, returnType: UIReturnKeyType, isSecure: Bool?) {
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = keyboardType
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.returnKeyType = returnType
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16)])
        textField.isSecureTextEntry = isSecure ?? false
        textField.delegate = self
    }
    
    private func configureSeparator(color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.leading.trailing.equalTo(self)
        }
        separator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}

extension BasicInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setSeparator(color: CustomColor.purple.color)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        setSeparator(color: CustomColor.defaultGray.color)
        return true
    }
}

protocol ValidationCheckDelegate {
    
}
