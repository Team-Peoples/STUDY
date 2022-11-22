//
//  Component.swift
//  STUDYA
//
//  Created by 서동운 on 2022/07/27.
//

import UIKit
import SnapKit

extension UIView {
    func configureBorder(color: AssetColor, width: CGFloat, radius: CGFloat) {
        layer.borderColor = UIColor.appColor(color).cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
}

class CustomButton: UIButton {
    
    init(title: String, isBold: Bool = true, fontSize: CGFloat, backgroundColor: UIColor, textColor: UIColor, radius: CGFloat) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        setTitleColor(textColor, for: .normal)
    
        setHeight(42)
        layer.cornerRadius = radius
    }
    
    init(title: String, isBold: Bool = true, isFill: Bool = false, fontSize: CGFloat = 18, height: CGFloat = 50) {
        super.init(frame: .zero)

        configure(title: title, isBold: isBold, isFill: isFill, fontSize: fontSize, height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        configure(title: "완료", isBold: true, isFill: true, fontSize: 18, height: 50)
    }
    
    private func configure(title: String, isBold: Bool, isFill: Bool, fontSize: CGFloat, height: CGFloat) {
        
        setTitle(title, for: .normal)
        configureBorder(color: .keyColor1, width: 1, radius: height / 2)
        
        if isFill {
            backgroundColor = UIColor.appColor(.keyColor1)
            setTitleColor(.white, for: .normal)

        } else {
            backgroundColor = .systemBackground
            setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        }
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        setHeight(height)
    }
    
    internal func fillIn(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = UIColor.appColor(.keyColor1)
        setTitleColor(.white, for: .normal)
    }
    
    internal func fillOut(title: String) {
        
        setTitle(title, for: .normal)
        backgroundColor = .systemBackground
        setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
    }
    
    internal func easyConfigure(title: String, backgroundColor: UIColor, textColor: UIColor, borderColor: AssetColor, radius: CGFloat) {
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        setTitleColor(textColor, for: .normal)
        configureBorder(color: borderColor, width: 1, radius: radius)
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
        
        configureTextView(placeholder: placeholder, size: fontSize, isBold: isBold, topInset: topInset, leadingInset: leadingInset, trailingInset: leadingInset)
        
        setPlaceHolderLabelConstraints(topConstant: topInset, leadingConstant: leadingInset)
    }
    
    convenience init(placeholder: String, fontSize: CGFloat, isBold: Bool = false) {
        self.init(placeholder: placeholder, fontSize: fontSize, isBold: isBold, topInset: 11, leadingInset: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView(placeholder: String, size: CGFloat, isBold: Bool = false, topInset: CGFloat, leadingInset: CGFloat, trailingInset: CGFloat) {
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        placeHolderLabel.text = placeholder
        placeHolderLabel.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        placeHolderLabel.textColor = .appColor(.ppsGray2)
        
        font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        textColor = UIColor.appColor(.ppsGray1)
        textContainerInset = UIEdgeInsets(top: topInset, left: leadingInset, bottom: 11, right: trailingInset)
        
        isScrollEnabled = false
    }
    
    
    func hidePlaceholder(_ isHided: Bool) {
        placeHolderLabel.isHidden = isHided ? true : false
    }
    
    private func setPlaceHolderLabelConstraints(topConstant: CGFloat, leadingConstant: CGFloat) {

        placeHolderLabel.anchor(top: self.topAnchor, topConstant: topConstant, leading: self.leadingAnchor, leadingConstant: leadingConstant)
    }
}

final class CharactersNumberLimitedTextView: BaseTextView {
    // MARK: - Properties
    
    enum Position {
        case center
        case bottom
    }
    
    private let charactersNumberLabel = UILabel(frame: .zero)
    
    // MARK: - Initialize
    
    init(placeholder: String, maxCharactersNumber: Int, radius: CGFloat, position: Position, fontSize: CGFloat, topInset: CGFloat = 11, leadingInset: CGFloat = 15) {
        super.init(placeholder: placeholder, fontSize: 16, topInset: topInset, leadingInset: leadingInset)
        
        addSubview(charactersNumberLabel)
        
        configureTextView(radius)
        configureCharactersNumberLabel(maxCharactersNumber: maxCharactersNumber, fontSize: fontSize)
        
        setConstraints(position: position)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configureTextView(_ radius: CGFloat) {
        backgroundColor = UIColor.appColor(.background)
        layer.cornerRadius = radius
    }
    
    private func configureCharactersNumberLabel(maxCharactersNumber: Int, fontSize: CGFloat) {
        
        charactersNumberLabel.text = "0/\(maxCharactersNumber)"
        charactersNumberLabel.font = UIFont.systemFont(ofSize: fontSize)
        charactersNumberLabel.textColor = .appColor(.ppsGray1)
    }
    
    // MARK: - Actions
    
    func getCharactersNumerLabel() -> UILabel {
        charactersNumberLabel
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints(position: Position) {
        switch position {
            case .center:
                charactersNumberLabel.centerY(inView: self)
                charactersNumberLabel.anchor(trailing: safeAreaLayoutGuide.trailingAnchor, trailingConstant: 15)
                
            case .bottom:
                charactersNumberLabel.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, bottomConstant: 10, trailing: safeAreaLayoutGuide.trailingAnchor, trailingConstant: 15)
                
        }
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
    fileprivate let underline = UIView()
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
    
    convenience init(title: String, boldPart: String) {
        self.init(title: title, tintColor: .ppsBlack, size: 16)
        
        let fontSize = self.font.pointSize
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: boldPart)
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func setTitleAndRedStar(upperLabelTitle: String) {
        
        let title = (upperLabelTitle + "*") as NSString
        let range = (title).range(of: "*")
        let attribute = NSMutableAttributedString(string: title as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        attributedText = attribute
    }
    
    // MARK: - Configure
    
    private func configure(title: String, isNecessaryTitle: Bool) {

        if isNecessaryTitle {
            setTitleAndRedStar(upperLabelTitle: title)
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


class ProfileImageSelectorView: UIView {

    private let backgroundView = UIView(frame: .zero)
    private let internalImageView = UIImageView(frame: .zero)
    private let adminMark = UIImageView(image: UIImage(named: "adminMark")!)
    private let roleMark = UIButton(frame: .zero)
    
    init(size: CGFloat, image: UIImage? = nil, isManager: Bool = false, role: String? = nil) {
        super.init(frame: .zero)
        addSubviews()
        
        backgroundView.clipsToBounds = true
        backgroundView.centerXY(inView: self)
        configure(size: size, image: image, isManager: isManager, role: role)
        
        hideMarks()
    }
    
    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(internalImageView)
        addSubview(adminMark)
        addSubview(roleMark)
    }
    
    internal func configure(size: CGFloat, image: UIImage? = nil, isManager: Bool = false, role: String? = nil) {
        
        let radius = size / 2
        
        configureInternalImageView(image, radius, size)
        configureLargerCirlcle(isManager, radius, size)
        
        guard let role = role else { return }
        
        configureRoleView(role)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInternalImageView(_ image: UIImage?, _ radius: CGFloat, _ size: CGFloat) {
        configure(image)
        internalImageView.clipsToBounds = true
        internalImageView.contentMode = .scaleAspectFill
        internalImageView.configureBorder(color: .keyColor3, width: 1, radius: radius)
        
        internalImageView.centerXY(inView: self)
        internalImageView.setDimensions(height: size, width: size)
    }
    
    
    internal func configure(_ image: UIImage?) {
        internalImageView.image = image == nil ? UIImage(named: "defaultProfile") : image
    }

    
    private func configureLargerCirlcle(_ isManager: Bool, _ radius: CGFloat, _ size: CGFloat) {
        if isManager {
            
            backgroundView.configureBorder(color: .keyColor1, width: 1, radius: radius + 2)
            setDimensions(height: size + 4, width: size + 4)
            
            configureAdminMark()

        } else {
            
            setDimensions(height: size + 2, width: size + 2)
        }
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func configureAdminMark() {
        adminMark.isHidden = false
        adminMark.snp.makeConstraints { make in
            make.top.leading.equalTo(backgroundView)
        }
    }
    
    private func configureRoleView(_ role: String) {
        roleMark.isHidden = false
        roleMark.isUserInteractionEnabled = false
        roleMark.backgroundColor = .systemBackground
        roleMark.setTitle(role, for: .normal)
        roleMark.setTitleColor(.black, for: .normal)
        roleMark.titleLabel?.font = .boldSystemFont(ofSize: 10)
        roleMark.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 0, blur: 4, spread: 0)
        roleMark.layer.cornerRadius = 10
        roleMark.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        roleMark.anchor(bottom: backgroundView.bottomAnchor, bottomConstant: -6, trailing: backgroundView.trailingAnchor, height: 20)
    }
    
    internal func hideMarks() {
        adminMark.isHidden = true
        roleMark.isHidden = true
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
    init(title: String) {
        super.init(frame: .zero)

        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure(title: String) {
        titleLabel?.font = .systemFont(ofSize: 16)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        setTitle(title, for: .normal)
        [.normal, .selected].forEach { setTitleColor(.appColor(.ppsBlack), for: $0) }
        setImage(UIImage(named: "off"), for: .normal)
        setImage(UIImage(named: "on"), for: .selected)
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
        
        let l = CustomLabel(title: "일반", tintColor: .keyColor1, size: 10, isBold: true)
        let l1 = CustomLabel(title: "관리", tintColor: .whiteLabel, size: 10, isBold: true)
        
        view.addSubview(l)
        view.addSubview(l1)
        
        l.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(view).inset(7)
        }
        
        l1.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(view).inset(7)
        }
        
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
        setDimensions(height: 28, width: 55)
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
        print(#function)
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

final class RoundedNumberField: UITextField, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let strArray: [String] = {
       
        var array = (1...99).map{ String($0) }
        array.insert("--", at: 0)
        
        return array
    }()
    
    var isNecessaryField = false
    
    private lazy var picker = UIPickerView()
    
    init(numPlaceholder: Int?, centerAlign: Bool, enable: Bool = true, isPicker: Bool = true, isNecessary: Bool = false) {
        super.init(frame: .zero)
        
        delegate = self
        
        configure(centerAlign: centerAlign)
        isNecessaryField = isNecessary
        
        if let placeholder = numPlaceholder {
            text = Formatter.formatIntoDecimal(number: placeholder)
        } else {
            text = "--"
        }
        
        if isPicker {
            setPicker()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        delegate = self
        backgroundColor = UIColor.appColor(.background)
        font = .boldSystemFont(ofSize: 20)
        textColor = UIColor.appColor(.ppsGray1)
        textAlignment = .center
        text = "--"
        setPicker()
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        self.layer.cornerRadius = self.frame.height / 2
        setHeight(42)
    }
    
    private func configure(centerAlign: Bool) {
        backgroundColor = UIColor.appColor(.background)
        font = .boldSystemFont(ofSize: 20)
        textColor = UIColor.appColor(.ppsGray1)
        textAlignment = centerAlign ? .center : .right
        rightView = centerAlign ? nil : UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        rightViewMode =  centerAlign ? .never : .always
    }
    
    private func setPicker() {
        picker.delegate = self
        picker.dataSource = self
        self.inputView = picker
        picker.backgroundColor = .systemBackground
        configureToolbar()
    }
    
    private func configureToolbar() {
        // toolbar를 만들어준다.
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.barTintColor = UIColor.appColor(.keyColor1)
        toolBar.isTranslucent = false
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        // 만들어줄 버튼
        // flexibleSpace는 취소~완료 간의 거리를 만들어준다.
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        // 만든 아이템들을 세팅해주고
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // 악세사리로 추가한다.
        self.inputAccessoryView = toolBar
    }
    
    // "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc private func donePicker() {
        let row = self.picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.text = self.strArray[row]
        self.resignFirstResponder()
    }
    
    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc private func cancelPicker() {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        guard finalText.count <= 2 else { return false }
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.checkOnlyNumbers() || isBackSpace == -92 { return true }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("🇨🇦")
        if textField.text == "--" {
            text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let intText = Int(text) {
            self.text = Formatter.formatIntoDecimal(number: intText)
        } else {
            self.text = "--"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    // pickerview의 선택지는 데이터의 개수만큼
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }
    
    // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        strArray[row]
    }
}

class ToastMessage: UIView {
    
    private var messageLabel = UILabel()
    private var messageImageView = UIImageView()
    
    init(message: String, messageColor: AssetColor, messageSize: CGFloat, image: String) {
        super.init(frame: .zero)
        
        messageLabel = CustomLabel(title: message, tintColor: messageColor, size: messageSize, isBold: true, isNecessaryTitle: false)
        messageImageView = UIImageView(image: UIImage(named: image))
        
        self.addSubview(messageImageView)
        self.addSubview(messageLabel)
        
        self.layer.cornerRadius = 5
        self.backgroundColor = .appColor(.ppsBlack)
        self.alpha = 0.9
        
        messageImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(26)
            make.leading.equalTo(self).offset(10)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageImageView.snp.trailing).offset(10)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PurpleRoundedInputField: UITextField {
    
    init(target: AnyObject?, action: Selector?) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.appColor(.background)
        textColor = UIColor.appColor(.ppsGray1)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        leftViewMode = .always
        isSecureTextEntry = true
        
        guard let action = action, let target = target else { return }
        
        addRightViewOnField(target: target, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        self.layer.cornerRadius = self.frame.height / 2
        setHeight(40)
    }
    
    private func addRightViewOnField(target: AnyObject?, action: Selector) {
        
        let rightButton = UIButton(frame: .zero)
        
        rightButton.tintColor = UIColor.appColor(.keyColor3)
        rightButton.addTarget(target, action: action, for: .touchUpInside)
    
        rightButton.setBackgroundImage(UIImage(named: "eye-close"), for: .normal)
        rightButton.setBackgroundImage(UIImage(named: "eye-open"), for: .selected)
        
        rightView = rightButton
        rightViewMode = .always
    }
    
    func update(alpha: CGFloat, of view: UIView) {
        view.alpha = alpha
    }
}

extension String {
    func checkOnlyNumbers() -> Bool{
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) { return true }
        } catch {
            print(error.localizedDescription)
            
            return false
        }
        return false
    }
}

class SwitchableViewController: UIViewController {

    var myStudyList = [Study]() {
        didSet {
            if myStudyList.count < 5 {
                dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: CGFloat(myStudyList.count * 50) + createStudyButtonHeight)
            } else {
                dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: 200 + createStudyButtonHeight)
            }
            print(dropdownHeight)
            /// 스터디가 없을때는 안되지않나
//            currentStudy = myStudyList[0]
        }
    }
    var currentStudy: Study?
    var willDropDown = false
    var isAdmin = true
    var dropDownCellNumber: CGFloat {
        if myStudyList.count == 0 {
            return 0
        } else if myStudyList.count > 0, myStudyList.count < 5 {
            return CGFloat(myStudyList.count)
        } else {
            return 4
        }
    }
    
    lazy var dropdownButton = UIButton()
    lazy var dropdownContainerView = UIView()
    lazy var dropdownTableView: UITableView = {

        let t = UITableView()
        
        t.delegate = self
        t.dataSource = self
        t.separatorColor = UIColor.appColor(.ppsGray3)
        t.bounces = false
        t.showsVerticalScrollIndicator = false
        t.register(MainDropDownTableViewCell.self, forCellReuseIdentifier: MainDropDownTableViewCell.identifier)

        return t
    }()
    lazy var dropdownDimmingView: UIView = {

        let v = UIView()

        v.isUserInteractionEnabled = true
        let recog = UITapGestureRecognizer(target: self, action: #selector(dropdownButtonDidTapped))
        v.addGestureRecognizer(recog)
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        v.isHidden = true

        return v
    }()
    lazy var createStudyButton: UIButton = {
       
        let b = UIButton()
        
        b.backgroundColor = UIColor.appColor(.brandMilky)
        b.setImage(UIImage(named: "plusCircleFill"), for: .normal)
        b.setTitle("   스터디 만들기", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        return b
    }()
    private lazy var masterSwitch = BrandSwitch()
    private let createStudyButtonHeight: CGFloat = 50
    private lazy var dropdownHeightZero = dropdownContainerView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: createStudyButtonHeight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
    }
    
    @objc func dropdownButtonDidTapped() {
        toggleDropdown()
        masterSwitch.isHidden.toggle()
        dropdownButton.isSelected.toggle()
        dropdownDimmingView.isHidden.toggle()
    }
    
    @objc func toggleNavigationBarBy(sender: BrandSwitch) {
        dropdownButton.isHidden.toggle()
        
        if sender.isOn {

            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
        } else {

            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.backgroundColor = .appColor(.background2)
        }
    }
    
    @objc func createStudyButtonDidTapped() {
        dropdownButtonDidTapped()
        let creatingStudyFormVC = CreatingStudyFormViewController()
        
        creatingStudyFormVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let presentVC = UINavigationController(rootViewController: creatingStudyFormVC)
        
        presentVC.navigationBar.backIndicatorImage = UIImage(named: "back")
        presentVC.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        presentVC.modalPresentationStyle = .fullScreen
        
        present(presentVC, animated: true)
    }
    
    func configureNavigationItem() {
        configureDropdownButton()
        configureDropdown()
        
        if isAdmin {
            navigationItem.title = "관리자 모드"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
            masterSwitch.addTarget(self, action: #selector(toggleNavigationBarBy), for: .valueChanged)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
        }
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: dropdownButton)]
    }
    
    func configureDropdownButton() {
        guard let dropdownTitle = myStudyList.first?.title else { return }

        dropdownButton.setTitle("\(dropdownTitle)  ", for: .normal)
        dropdownButton.setTitleColor(UIColor.appColor(.ppsGray1), for: .normal)
        dropdownButton.setTitleColor(UIColor.appColor(.ppsGray1), for: .selected)
        dropdownButton.tintColor = UIColor.appColor(.background)
        dropdownButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        dropdownButton.setImage(UIImage(named: "dropDown")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .normal)
        dropdownButton.setImage(UIImage(named: "dropUp")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .selected)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.addTarget(self, action: #selector(dropdownButtonDidTapped), for: .touchUpInside)
    }
    
    func configureDropdown() {
        guard !myStudyList.isEmpty else { return }
        
        if let tabBarView = tabBarController?.view {
            tabBarView.addSubview(dropdownDimmingView)
            tabBarView.addSubview(dropdownContainerView)
            
            dropdownDimmingView.snp.makeConstraints { make in
                make.top.equalTo(navigationController!.navigationBar.snp.bottom)
                make.leading.trailing.bottom.equalTo(tabBarView)
            }
            
            dropdownContainerView.snp.makeConstraints { make in
                make.top.equalTo(dropdownDimmingView.snp.top)
                make.leading.trailing.equalTo(dropdownDimmingView).inset(9)
            }
        } else {
            view.addSubview(dropdownDimmingView)
            view.addSubview(dropdownContainerView)
            
            dropdownDimmingView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            dropdownContainerView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.trailing.equalTo(view).inset(9)
            }
        }
        
        dropdownContainerView.addSubview(dropdownTableView)
        dropdownContainerView.addSubview(createStudyButton)
        
        dropdownTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(dropdownContainerView)
            make.bottom.equalTo(createStudyButton.snp.top)
        }
        
        createStudyButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(dropdownContainerView)
        }
        
        dropdownHeight.isActive = false
        dropdownHeightZero.isActive = true
    }
    
    private func animateDropdown() {
        let tabBarView = self.tabBarController?.view
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            tabBarView == nil ? self.view.layoutIfNeeded() : tabBarView?.layoutIfNeeded()
        }
    }
    
    private func toggleDropdown() {

        willDropDown.toggle()
        
        var indexPaths = [IndexPath]()
        var row = 0
        
        while row < myStudyList.count {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
            row += 1
        }
        
        if willDropDown {
            
            dropdownHeightZero.isActive = false
            dropdownHeight.isActive = true
            
            dropdownTableView.insertRows(at: indexPaths, with: .top)
            
            createStudyButton.isHidden = false
            createStudyButton.setHeight(50)
            
            dropdownContainerView.layer.cornerRadius = 24
            dropdownContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            dropdownContainerView.clipsToBounds = true
            
            animateDropdown()
        } else {
            
            dropdownTableView.deleteRows(at: indexPaths, with: .top)

            dropdownHeight.isActive = false
            dropdownHeightZero.isActive = true
            createStudyButton.isHidden = true
            
            animateDropdown()
        }
    }
    
}

extension SwitchableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return willDropDown ? myStudyList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let currentStudyID = currentStudy?.id else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainDropDownTableViewCell.identifier) as! MainDropDownTableViewCell
        
        if currentStudyID == myStudyList[indexPath.row].id {
            cell.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 249/255, alpha: 1)
        }
        
        cell.title = myStudyList[indexPath.row].title!
        
        return cell
    }
}

extension SwitchableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class RoundedCornersField: UITextField {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        keyboardType = .numberPad
    }
}

final class RoundedCornersView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
