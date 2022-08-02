//
//  Component.swift
//  STUDYA
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    init(placeholder: String, isFill: Bool = false) {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        backgroundColor = isFill ? UIColor.appColor(.purple) : .systemBackground
        isFill ? setTitleColor(.white, for: .normal) : setTitleColor(UIColor.appColor(.purple), for: .normal)
        setTitle(placeholder, for: .normal)
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
    
    // MARK: - Actions
    
    func setSeparator(color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Initialize
    
    init(titleText: String) {
        super.init(frame: .zero)
       
        addSubview(nameLabel)
        addSubview(separator)
        
        configureNameLabel(title: titleText)
        configureSeparator(color: UIColor.appColor(.defaultGray))
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cofigure Views
    
    private func configureNameLabel(title: String) {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = title
    }
    
    
    private func configureSeparator(color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Setting Constraints
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(nameLabel.snp.bottom).offset(46)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}

class SignUpInputView: UIStackView {
    // MARK: - Properties

    private let basicInputView: BasicInputView?
    private let validationLabel = UILabel()

    // MARK: - Actions

    func setSeparator(color: UIColor) {
        basicInputView?.setSeparator(color: color)
    }

    // MARK: - Initialize

    init(titleText: String, validationLText: String) {
        basicInputView = BasicInputView(titleText: titleText)

        super.init(frame: .zero)

        addArrangedSubview(basicInputView!)
        addArrangedSubview(validationLabel)

        configureStackView()
        configureValidationLabel(text: validationLText)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Views

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
}

class CustomLabel: UILabel {
    // MARK: - Initialize
    
    init(title: String, color: AssetColor, isBold: Bool = false, size: CGFloat) {
        super.init(frame: .zero)
        
        text = title
        textColor = UIColor.appColor(.black)
        font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextField: UITextField {
    // MARK: - Initialize
    
    init(placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isSecure: Bool? = nil) {
        super.init(frame: .zero)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        font = UIFont.systemFont(ofSize: 18)
        keyboardType = keyboardType
        borderStyle = .none
        returnKeyType = returnType
        isSecureTextEntry = isSecure ?? false
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16)])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
