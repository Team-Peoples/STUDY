//
//  Component.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

enum CustomColor {
    case purple
    case black
    case placeholder
    case defaultGray
}

extension CustomColor {
    var color: UIColor {
        switch self {
            case .purple:
                return UIColor(red: 0.424, green: 0.275, blue: 0.91, alpha: 1)
            case .black:
                return UIColor(red: 0.208, green: 0.178, blue: 0.283, alpha: 1)
            case .placeholder:
                return UIColor(red: 0.827, green: 0.824, blue: 0.863, alpha: 1)
            case .defaultGray:
                return UIColor(red: 0.839, green: 0.82, blue: 0.91, alpha: 1)
        }
    }
}

class SignUpInputView: UIStackView {
    //MARK: - Properties
    
    let basicInputView: BasicInputView?
    private let validationLabel = UILabel()
    
    //MARK: - Actions
    
    func setSeparator(color: UIColor) {
        
        basicInputView?.setSeparator(color: color)
    }
    
    //MARK: - Life Cycle
    
    init(titleText: String, placeholderText: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, validationLText: String, isSecure: Bool? = nil) {
        basicInputView = BasicInputView(titleText: titleText, placeholderText: placeholderText, keyBoardType: keyBoardType, returnType: returnType, isSecure: isSecure)
        
        super.init(frame: .zero)
        basicInputView?.textField.delegate = self
        
        addArrangedSubview(basicInputView!)
        addArrangedSubview(validationLabel)
        
        configureStackView()
        configureValidationLabel(text: validationLText)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Views
    
    private func configureStackView() {
        
        axis = .vertical
        distribution = .equalSpacing
        spacing = 5
    }
    
    private func configureValidationLabel(text: String) {
        
        validationLabel.text = text
        validationLabel.textColor = CustomColor.black.color
        validationLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    //MARK: - Setting Constraints
}

extension SignUpInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        basicInputView?.setSeparator(color: CustomColor.purple.color)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        basicInputView?.setSeparator(color: CustomColor.defaultGray.color)
        return true
    }
}

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
