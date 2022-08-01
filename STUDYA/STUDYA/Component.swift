//
//  Component.swift
//  STUDYA
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    init(placeholder: String, isBold: Bool = true) {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        setTitle(placeholder, for: .normal)
        setTitleColor(UIColor.appColor(.purple), for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill() {
        backgroundColor = UIColor.appColor(.purple)
        setTitleColor(.white, for: .normal)
    }
}

class GrayBorderTextView: UITextView {
    
    init(placeholder: String, maxCharactersNumber: Int, height: Int = 50) {
        super.init(frame: .zero, textContainer: nil)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        text = placeholder
        font = UIFont.systemFont(ofSize: 16)
        textColor = .systemGray3
        textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.cornerRadius = 10
        
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true

        let charactersNumberLabel: UILabel = {
            
            let label = UILabel(frame: .zero)
            
            label.text = "0/\(maxCharactersNumber)"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .systemGray3
            translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        self.addSubview(charactersNumberLabel)
        
        charactersNumberLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        configureSeparator(color: UIColor.appColor(.defaultGray))
        
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
        setSeparator(color: UIColor.appColor(.purple))
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        setSeparator(color: UIColor.appColor(.defaultGray))
        return true
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
        validationLabel.textColor = UIColor.appColor(.black)
        validationLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    //MARK: - Setting Constraints
}

extension SignUpInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        basicInputView?.setSeparator(color: UIColor.appColor(.purple))
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        basicInputView?.setSeparator(color: UIColor.appColor(.defaultGray))
        return true
    }
}
