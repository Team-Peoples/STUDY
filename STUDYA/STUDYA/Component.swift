//
//  Component.swift
//  STUDYA
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    
    init(title: String, isBold: Bool = true, isFill: Bool = false, size: CGFloat = 18, height: CGFloat = 50) {
        super.init(frame: .zero)

        configure(title: title, isBold: isBold, isFill: isFill, size: size, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(title: String, isBold: Bool, isFill: Bool, size: CGFloat, height: CGFloat) {
        
        setTitle(title, for: .normal)
        layer.borderColor = UIColor.appColor(.keyColor1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = height / 2
      
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        
        if isFill {
            backgroundColor = UIColor.appColor(.keyColor1)
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .systemBackground
            setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        }

        setHeight(height)
    }
    
    internal func fillOut(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = .systemBackground
        setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
    }
    
    internal func fillIn(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = UIColor.appColor(.keyColor1)
        setTitleColor(.white, for: .normal)
    }

    func resetColorFor(normal: AssetColor, forSelected: AssetColor) {
        setTitleColor(UIColor.appColor(forSelected), for: .selected)
        setTitleColor(UIColor.appColor(normal), for: .normal)
    }
}

class BaseTextView: UITextView {
    
    private let placeHolderLabel = UILabel()
    
    init(placeholder: String, fontSize: CGFloat, isBold: Bool = false, topInset: CGFloat, leadingInset: CGFloat) {
        super.init(frame: .zero, textContainer: nil)
        
        addSubview(placeHolderLabel)
        
        configureTextView(placeholder: placeholder, size: fontSize, isBold: isBold)
        
        setConstraints(topConstant: topInset, leadingConstant: leadingInset)
    }
    
    convenience init(placeholder: String, fontSize: CGFloat, isBold: Bool = false) {
        self.init(placeholder: placeholder, fontSize: fontSize, isBold: isBold, topInset: 11, leadingInset: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView(placeholder: String, size: CGFloat, isBold: Bool = false) {
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        placeHolderLabel.text = placeholder
        placeHolderLabel.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        placeHolderLabel.textColor = .appColor(.ppsGray2)
        
        font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        textColor = UIColor.appColor(.ppsBlack)
        textContainerInset = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 15)
        
        isScrollEnabled = false
    }
    
    
    func hidePlaceholder(_ isHided: Bool) {
        placeHolderLabel.isHidden = isHided ? true : false
    }
    
    private func setConstraints(topConstant: CGFloat, leadingConstant: CGFloat) {

        placeHolderLabel.anchor(top: self.topAnchor, topConstant: topConstant, leading: self.leadingAnchor, leadingConstant: leadingConstant)
    }
}
// gray 아니라서 바꿔야함.
class GrayBorderTextView: BaseTextView {
    
    let charactersNumberLabel = UILabel(frame: .zero)
    
    init(placeholder: String, maxCharactersNumber: Int, height: CGFloat) {
        super.init(placeholder: placeholder, fontSize: 16, topInset: 11, leadingInset: 15)
        
        addSubview(charactersNumberLabel)
        
        configureTextView()
        configureCharactersNumberLabel(maxCharactersNumber: maxCharactersNumber)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        backgroundColor = UIColor.appColor(.background)
        layer.cornerRadius = 20
    }
    
    private func configureCharactersNumberLabel(maxCharactersNumber: Int) {
        
        charactersNumberLabel.text = "0/\(maxCharactersNumber)"
        charactersNumberLabel.font = UIFont.systemFont(ofSize: 12)
        charactersNumberLabel.textColor = .systemGray3
    }
    
    private func setConstraints() {
        
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
        validationLabel.textColor = UIColor.appColor(.ppsGray1)
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
        
        rightButton.tintColor = UIColor.appColor(.keyColor3)
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
        
        setUnderlineColor(as: .keyColor3)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints(padding: CGFloat) {
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(padding)
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
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.appColor(.ppsGray2), .font: UIFont.systemFont(ofSize: 18)])
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
        layer.borderColor = UIColor.appColor(.keyColor3).cgColor
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

class CheckBoxButton: UIButton {
    // MARK: - Properties
    
    // MARK: - Initialize
    init(title: String, selected: String, unselected: String) {
        super.init(frame: .zero)

        configure(title: title, selected: selected, unselected: unselected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure(title: String, selected: String, unselected: String) {
        titleLabel?.font = .systemFont(ofSize: 16)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        setTitle(title, for: .normal)
        [.normal, .selected].forEach { setTitleColor(.appColor(.ppsBlack), for: $0) }
        setImage(UIImage(named: unselected), for: .normal)
        setImage(UIImage(named: selected), for: .selected)
    }
    // MARK: - Actions
    
    func toggleState() {
        isSelected.toggle()
    }
    // MARK: - Setting Constraints
}

final class BrandSwitch: UIControl {
    private enum Constant {
        static let duration = 0.25
    }
    
    // MARK: UI
    private let outerView: RoundableView = {
        let view = RoundableView()
        
        view.backgroundColor = UIColor.appColor(.keyColor1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    private let barView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = UIColor.appColor(.background)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Properties
    var isOn = false {
        didSet {
            self.sendActions(for: .valueChanged)
            
            UIView.animate(
                withDuration: Constant.duration,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.barView.backgroundColor = self.isOn ? self.barTintColor : self.barColor
                    self.outerView.backgroundColor = self.isOn ? UIColor.appColor(.ppsGray3) : UIColor.appColor(.keyColor2)
                    
                    self.circleViewConstraints.forEach { $0.isActive = false }
                    self.circleViewConstraints.removeAll()
                    
                    if self.isOn {
                        self.circleViewConstraints = [
                            self.circleView.rightAnchor.constraint(equalTo: self.barView.rightAnchor, constant: -2),
                            self.circleView.bottomAnchor.constraint(equalTo: self.barView.bottomAnchor, constant: -2),
                            self.circleView.topAnchor.constraint(equalTo: self.barView.topAnchor, constant: 2),
                            self.circleView.heightAnchor.constraint(equalToConstant: 24),
                            self.circleView.widthAnchor.constraint(equalToConstant: 24)
                        ]
                    } else {
                        self.circleViewConstraints = [
                            self.circleView.leftAnchor.constraint(equalTo: self.barView.leftAnchor, constant: 2),
                            self.circleView.bottomAnchor.constraint(equalTo: self.barView.bottomAnchor, constant: -2),
                            self.circleView.topAnchor.constraint(equalTo: self.barView.topAnchor, constant: 2),
                            self.circleView.heightAnchor.constraint(equalToConstant: 24),
                            self.circleView.widthAnchor.constraint(equalToConstant: 24)
                        ]
                    }
                    
                    NSLayoutConstraint.activate(self.circleViewConstraints)
                    self.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    var barColor = UIColor.appColor(.background) {
        didSet { self.barView.backgroundColor = self.barColor }
    }
    var barTintColor = UIColor.appColor(.keyColor1)
    var circleColor = UIColor.white {
        didSet { self.circleView.backgroundColor = self.circleColor }
    }
    private var circleViewConstraints = [NSLayoutConstraint]()
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("xib is not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(outerView)
        self.addSubview(self.barView)
        self.barView.addSubview(self.circleView)
        setDimensions(height: 28, width: 50)
        outerView.anchor(top: topAnchor, topConstant: -1, bottom: bottomAnchor, bottomConstant: -1, leading: leadingAnchor, leadingConstant: -1, trailing: trailingAnchor, trailingConstant: -1)
        NSLayoutConstraint.activate([
            self.barView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.barView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.barView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.barView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        self.circleViewConstraints = [
            self.circleView.leftAnchor.constraint(equalTo: self.barView.leftAnchor, constant: 2),
            self.circleView.bottomAnchor.constraint(equalTo: self.barView.bottomAnchor, constant: -2),
            self.circleView.topAnchor.constraint(equalTo: self.barView.topAnchor, constant: 2),
            self.circleView.heightAnchor.constraint(equalToConstant: 24),
            self.circleView.widthAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(self.circleViewConstraints)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isOn = !self.isOn
    }
}

final class RoundableView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

final class RoundedNumberField: UITextField {
    
    init(numPlaceholder: Int?, centerAlign: Bool, enable: Bool = true) {
        super.init(frame: .zero)
        
        backgroundColor = enable ? UIColor.appColor(.background) : UIColor.appColor(.ppsGray3)
        isEnabled = enable ? true : false
        font = .boldSystemFont(ofSize: 20)
        textColor = UIColor.appColor(.ppsGray1)
        textAlignment = centerAlign ? .center : .right
        rightView = centerAlign ? nil : UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        rightViewMode = .always
        
        if let placeholder = numPlaceholder {
            text = Formatter.formatIntoDecimal(number: placeholder)
        } else {
            text = "--"
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        self.layer.cornerRadius = self.frame.height / 2
        setHeight(42)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
