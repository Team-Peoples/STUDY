//
//  Component.swift
//  STUDYA
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    
    init(title: String, isBold: Bool = true, isFill: Bool = false) {
        super.init(frame: .zero)

        configure(title: title, isBold: isBold, isFill: isFill)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(title: String, isBold: Bool, isFill: Bool) {
        
        setTitle(title, for: .normal)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
      
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 18)
        
        if isFill {
            backgroundColor = UIColor.appColor(.purple)
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .systemBackground
            setTitleColor(UIColor.appColor(.purple), for: .normal)
        }

        setHeight(50)
    }
    
    internal func fillOut(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = .systemBackground
        setTitleColor(UIColor.appColor(.brandThick), for: .normal)
    }
    
    internal func fillIn(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = UIColor.appColor(.brandThick)
        setTitleColor(.white, for: .normal)
    }
}

class TitleLabelAndTextViewStackView: UIStackView {
    
    init(title: String, isNeccessary: Bool = true, placeholder: String, maxCharactersNumber: Int, height: CGFloat = 50) {
        super.init(frame: .zero)
        
        let titleLabel = CustomLabel(title: title, tintColor: .black, size: 18, isBold: true, isNecessaryTitle: isNeccessary)
        let grayBorderTextView = GrayBorderTextView(placeholder: placeholder, maxCharactersNumber: 10, height: height)
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(grayBorderTextView)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        spacing = 20
        distribution = .fillEqually
        axis = .vertical
    }
}

class GrayBorderTextView: UITextView {
    
    let charactersNumberLabel = UILabel(frame: .zero)
    
    init(placeholder: String, maxCharactersNumber: Int, height: CGFloat) {
        super.init(frame: .zero, textContainer: nil)
        
        addSubview(charactersNumberLabel)
        
        configureTextView(placeholder: placeholder, height: height)
        configureCharactersNumberLabel(maxCharactersNumber: maxCharactersNumber)
        
        setConstraints(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView(placeholder: String, height: CGFloat) {
        
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
    }
    
    private func configureCharactersNumberLabel(maxCharactersNumber: Int) {
        
        charactersNumberLabel.text = "0/\(maxCharactersNumber)"
        charactersNumberLabel.font = UIFont.systemFont(ofSize: 12)
        charactersNumberLabel.textColor = .systemGray3
    }
    
    
    private func setConstraints(height: CGFloat) {
        
        setHeight(height)
        charactersNumberLabel.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, bottomConstant: 8, trailing: safeAreaLayoutGuide.trailingAnchor, trailingConstant: 8)
    }
}

class ValidationInputView: UIStackView {
    // MARK: - Properties

    private let basicInputView: BasicInputView!
    private let validationLabel = UILabel()

    // MARK: - Ininitalize

    init(titleText: String, fontSize: CGFloat = 20, titleBottomPadding: CGFloat = 16, placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool = false, validationText: String, cancelButton: Bool = false, target: AnyObject? = nil, textFieldAction: Selector) {

        basicInputView = BasicInputView(titleText: titleText, fontSize: fontSize, titleBottomPadding: titleBottomPadding, placeholder: placeholder, keyBoardType: keyBoardType, returnType: returnType, isFieldSecure: isFieldSecure, isCancel: cancelButton, target: target, textFieldAction: textFieldAction)

        super.init(frame: .zero)

        addArrangedSubview(basicInputView)
        addArrangedSubview(validationLabel)

        configureValidationLabel(text: validationText)
        configureStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions

    func setUnderlineColor(as color: AssetColor) {
        basicInputView?.setUnderlineColor(as: color)
    }

    internal func getInputview() -> BasicInputView {
        basicInputView
    }

    internal func getInputField() -> UITextField {
        basicInputView.getInputField()
    }

    internal func toggleSecureText() {
        basicInputView.getInputField().isSecureTextEntry.toggle()
    }
    func getValidationLabel() -> UILabel {
        validationLabel
    }

     //MARK: - Configure Views
    
    private func configureStackView() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 6
    }

    private func configureValidationLabel(text: String) {
        validationLabel.text = text
        validationLabel.textColor = UIColor.appColor(.subTitleGeneral)
        validationLabel.font = UIFont.systemFont(ofSize: 14)
    }
}

class BasicInputView: UIView {
    // MARK: - Properties
    
    fileprivate let nameLabel = UILabel()
    fileprivate var underline = UIView()
    fileprivate var inputField: CustomTextField!
    
    // MARK: - Initialize
    
    init(titleText: String, fontSize: CGFloat = 20, titleBottomPadding: CGFloat = 16, placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool = false, isCancel: Bool = false, target: AnyObject? = nil, textFieldAction: Selector) {
        super.init(frame: .zero)
        
        inputField = CustomTextField(placeholder: placeholder, keyBoardType: keyBoardType, returnType: returnType, isFieldSecure: isFieldSecure)
        
        addSubview(nameLabel)
        addSubview(underline)
        addSubview(inputField)
        
        configure(text: titleText, fontSize: fontSize)
        addRightViewOnField(cancel: isCancel, target: target, action: textFieldAction)
        
        setConstraints(padding: titleBottomPadding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    internal func getInputField() -> CustomTextField {
        inputField
    }
    
    internal func setUnderlineColor(as color: AssetColor) {
        underline.backgroundColor = UIColor.appColor(color)
    }
    
    internal func toggleSecureText() {
        inputField.isSecureTextEntry.toggle()
    }
    
    private func addRightViewOnField(cancel: Bool, target: AnyObject?, action: Selector) {
        
        let rightButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 36)))
        
        rightButton.tintColor = UIColor.appColor(.brandLight)
        rightButton.addTarget(target, action: action, for: .touchUpInside)
        
        if cancel {
            rightButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        } else {
            rightButton.setBackgroundImage(UIImage(named: "eye-close"), for: .normal)
            rightButton.setBackgroundImage(UIImage(named: "eye-open"), for: .selected)
        }
        
        inputField.rightView = rightButton
        inputField.rightViewMode = .always
    }
    
    // MARK: - Cofigure Views
    
    private func configure(text: String, fontSize size: CGFloat) {
        nameLabel.font = UIFont.boldSystemFont(ofSize: size)
        nameLabel.text = text
        
        setUnderlineColor(as: .brandLight)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints(padding: CGFloat) {
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(underline.snp.top).offset(-5)
            make.leading.trailing.equalTo(self)
        }
        
        underline.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(inputField.snp.bottom).offset(4)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}

class CustomTextField: UITextField {
    // MARK: - Initialize
    
    init(placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool? = nil) {
        super.init(frame: .zero)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        font = UIFont.systemFont(ofSize: 18)
    
        keyboardType = keyboardType
        borderStyle = .none
        returnKeyType = returnType
        isSecureTextEntry = isFieldSecure ?? false
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 18)])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class CustomLabel: UILabel {
    // MARK: - Initialize
    
    init(title: String, tintColor: AssetColor, size: CGFloat, isBold: Bool = false, isNecessaryTitle: Bool = false) {
        super.init(frame: .zero)
        
        textColor = UIColor.appColor(tintColor)
        font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        numberOfLines = 0
        
        configure(title: title, isNecessaryTitle: isNecessaryTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func setTitleAndRedStar(upperLabelTitle: String, label: UILabel) {
        
        let title = (upperLabelTitle + "*") as NSString
        let range = (title).range(of: "*")
        let attribute = NSMutableAttributedString(string: title as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        attributedText = attribute
    }
    
    // MARK: - Configure
    
    private func configure(title: String, isNecessaryTitle: Bool) {

        if isNecessaryTitle {
            setTitleAndRedStar(upperLabelTitle: title, label: self)
        } else {
            text = title
        }
    }
}

class SimpleAlert: UIAlertController {
    // MARK: - Initialize
    convenience init(message: String?) {
        self.init(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        self.addAction(okAction)
    }
}

class ProfileImageSelectorView: UIImageView {
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        
        image = UIImage(named: "defaultProfile")
        layer.borderWidth = 2
        layer.borderColor = UIColor.appColor(.brandLight).cgColor
        layer.cornerRadius = size / 2
        
        clipsToBounds = true
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        
        setDimensions(height: size, width: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlusCircleFillView: UIImageView {
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        
        image = UIImage(named: "plusCircleFill")
        layer.cornerRadius = size / 2
        
        clipsToBounds = true
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        
        setDimensions(height: size, width: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
