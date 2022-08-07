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

        configure(placeholder: title, isBold: isBold, isFill: isFill)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(placeholder: String, isBold: Bool, isFill: Bool) {
        
        setTitle(placeholder, for: .normal)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
      
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 18)
        
        backgroundColor = isFill ? UIColor.appColor(.purple) : .systemBackground
        isFill ? setTitleColor(.white, for: .normal) : setTitleColor(UIColor.appColor(.purple), for: .normal)

        heightAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    init(upperLabelTitle: String, isNeccessary: Bool = true, placeholder: String, maxCharactersNumber: Int, height: Int = 50) {
        super.init(frame: .zero)
        
        let titleLabel = TitleLabel(title: upperLabelTitle, isNecessaryTitle: isNeccessary)
        let grayBorderTextView = GrayBorderTextView(placeholder: placeholder, maxCharactersNumber: 10, height: 50)
        
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

    class TitleLabel: UILabel {
        
        init(title: String, isNecessaryTitle: Bool = true) {
            super.init(frame: .zero)

            configure(title: title, isNecessaryTitle: isNecessaryTitle)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setTitleAndRedStar(upperLabelTitle: String, label: UILabel) {
            
            let title = (upperLabelTitle + "*") as NSString
            let range = (title).range(of: "*")
            let attribute = NSMutableAttributedString(string: title as String)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            self.attributedText = attribute
        }
        
        private func configure(title: String, isNecessaryTitle: Bool) {
            font = UIFont.boldSystemFont(ofSize: 18)
            
            if isNecessaryTitle {
                setTitleAndRedStar(upperLabelTitle: title, label: self)
            } else {
                text = title
            }
        }
    }
    
    class GrayBorderTextView: UITextView {
        
        let charactersNumberLabel = UILabel(frame: .zero)
        
        init(placeholder: String, maxCharactersNumber: Int, height: Int) {
            super.init(frame: .zero, textContainer: nil)
            
            addSubview(charactersNumberLabel)
            
            configureTextView(placeholder: placeholder, height: height)
            configureCharactersNumberLabel(maxCharactersNumber: maxCharactersNumber)
            
            setConstraints(height: height)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureTextView(placeholder: String, height: Int) {
            
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
        
        
        private func setConstraints(height: Int) {
            
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            charactersNumberLabel.snp.makeConstraints { make in
                make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-8)
            }
        }
        
    }
}
/*
class ValidationInputView: BasicInputView {

    private let validationLabel = UILabel(frame: .zero)


    init(titleText: String, placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool, validationText: String, rightButtonImage: String?, target: UIViewController?, action: Selector?) {
        super.init(titleText: titleText, placeholder: placeholder, keyBoardType: keyBoardType, returnType: returnType, isFieldSecure: isFieldSecure)

        addSubview(validationLabel)

        configureValidationLabel(validationText: validationText)
        addRightViewOnField(imageName: rightButtonImage, target: target, action: action)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addRightViewOnField(imageName: String?, target: AnyObject?, action: Selector?) {

        let rightButton = UIButton(frame: .zero)
        let buttonImage: UIImage?

        guard let imageName = imageName, let action = action else { return }

        buttonImage = imageName == "xmark" ? UIImage(systemName: "xmark.circle.fill") : UIImage(named: imageName)
        rightButton.setBackgroundImage(buttonImage, for: .normal)
        rightButton.setBackgroundImage(UIImage(named: "eye-open"), for: .selected)
        rightButton.tintColor = UIColor.appColor(.brandLight)
        rightButton.frame = CGRect(origin: .zero, size: CGSize(width: 36, height: 36))
        rightButton.addTarget(target, action: action, for: .touchUpInside)

        inputField.rightView = rightButton
        inputField.rightViewMode = .always
    }

    private func configureValidationLabel(validationText: String) {
        validationLabel.text = validationText
        validationLabel.textColor = UIColor.appColor(.subTitleGeneral)    //description color로 바꿔야
        validationLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setConstraints() {

        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(10)
            make.leading.equalTo(separator.snp.leading)
        }
    }
}
*/

class ValidationInputView: UIStackView {
    // MARK: - Properties

    private let basicInputView: BasicInputView!
    private let validationLabel = UILabel()

    // MARK: - Actions

    func setSeparator(color: UIColor) {
        basicInputView?.setSeparatorColor(as: color)
    }

    // MARK: - Life Cycle

    init(titleText: String, placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool, validationText: String, isEraseButton: Bool? = nil, target: AnyObject? = nil, action: Selector? = nil) {

        basicInputView = BasicInputView(titleText: titleText, placeholder: placeholder, keyBoardType: keyBoardType, returnType: returnType, isFieldSecure: isFieldSecure)

        super.init(frame: .zero)

        addArrangedSubview(basicInputView!)
        addArrangedSubview(validationLabel)

        addRightViewOnField(isEraseButton: isEraseButton, target: target, action: action)
        configureValidationLabel(validationText: validationText)
        configureStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    internal func getInputview() -> BasicInputView {
        basicInputView
    }

    internal func getInputField() -> UITextField {
        basicInputView.getInputField()
    }

    internal func toggleSecureText() {
        basicInputView.getInputField().isSecureTextEntry = basicInputView.getInputField().isSecureTextEntry == true ? false : true
    }
    
     //MARK: - Configure Views

    private func addRightViewOnField(isEraseButton: Bool?, target: AnyObject?, action: Selector?) {

        let rightButton = UIButton(frame: .zero)
        let buttonImage: UIImage?

        guard let isEraseButton = isEraseButton, let action = action else { return }
        
        buttonImage = isEraseButton == true ? UIImage(systemName: "xmark.circle.fill") : UIImage(named: "eye-close")
        rightButton.setBackgroundImage(buttonImage, for: .normal)
        rightButton.setBackgroundImage(UIImage(named: "eye-open"), for: .selected)
        rightButton.tintColor = UIColor.appColor(.brandLight)
        rightButton.frame = CGRect(origin: .zero, size: CGSize(width: 36, height: 36))
        rightButton.addTarget(target, action: action, for: .touchUpInside)

        basicInputView.inputField.rightView = rightButton
        basicInputView.inputField.rightViewMode = .always
    }
    
    private func configureStackView() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 6
    }

    private func configureValidationLabel(validationText: String) {
        validationLabel.text = validationText
        validationLabel.textColor = UIColor.appColor(.subTitleGeneral)
        validationLabel.font = UIFont.systemFont(ofSize: 14)
    }
}


class BasicInputView: UIView {
    // MARK: - Properties
    
    fileprivate let nameLabel = UILabel()
    fileprivate var separator = UIView()
    fileprivate var inputField: CustomTextField!
    
    // MARK: - Actions
    
    init(titleText: String, placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isFieldSecure: Bool) {
        super.init(frame: .zero)
        
        inputField = CustomTextField(placeholder: placeholder, keyBoardType: keyBoardType, returnType: returnType, isFieldSecure: isFieldSecure)
        
        addSubview(nameLabel)
        addSubview(separator)
        addSubview(inputField)
        
        configure(title: titleText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setConstraints()
    }
    
    internal func getInputField() -> CustomTextField {
        inputField
    }
    
    internal func modifyTitle(size: CGFloat, isBold: Bool) {
        nameLabel.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    }
    
    internal func adjust(distance: Int) {
        inputField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(distance).priority(.high)
        }
    }
    
    internal func setSeparatorColor(as color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Cofigure Views
    
    private func configure(title: String) {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = title
        
        separator.backgroundColor = UIColor.appColor(.brandLight)
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.bottom.equalTo(separator.snp.top).offset(5)
            make.leading.trailing.equalTo(self)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(nameLabel.snp.bottom).offset(46)
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
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16)])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class CustomLabel: UILabel {
    // MARK: - Initialize
    
    init(title: String, color: AssetColor, isBold: Bool = false, size: CGFloat) {
        super.init(frame: .zero)
        
        text = title
        textColor = UIColor.appColor(color)
        font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
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
        
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
