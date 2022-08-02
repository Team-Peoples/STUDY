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
        
        configure(placeholder: placeholder, isBold: isBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(placeholder: String, isBold: Bool) {
        
        setTitle(placeholder, for: .normal)
        setTitleColor(UIColor.appColor(.purple), for: .normal)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24

        if isBold {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func fill() {
        
        backgroundColor = UIColor.appColor(.purple)
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

class BasicInputView: UIView {
    // MARK: - Properties
    
    private let nameLabel = UILabel()
    private var separator = UIView()
    
    // MARK: - Actions
    
    func setSeparator(color: UIColor) {
        separator.backgroundColor = color
    }
    
    // MARK: - Life Cycle
    
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
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
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

    // MARK: - Life Cycle

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

class TitleLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 0.95
        attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: -0.24, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        textColor = UIColor.appColor(.black)
        font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextField: UITextField {
    
    init(placeholder: String, keyBoardType: UIKeyboardType, returnType: UIReturnKeyType, isSecure: Bool? = nil) {
        super.init(frame: .zero)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        font = UIFont.systemFont(ofSize: 16)
        keyboardType = keyboardType
        borderStyle = .none
        returnKeyType = returnType
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor: UIColor.lightGray,
                                                                .font: UIFont.systemFont(ofSize: 16)])
        isSecureTextEntry = isSecure ?? false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
