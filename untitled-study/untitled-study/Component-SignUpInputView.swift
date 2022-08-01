//
//  Component-SignUpInputView.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

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
