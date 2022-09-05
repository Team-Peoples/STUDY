//
//  AccountManagementViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/30.
//

import UIKit
import PhotosUI
import Photos

//To be fixed: 입력칸 rightbutton 오른쪽 padding 10 넣기

enum SNS: String {
    case kakao
    case naver
}

final class AccountManagementViewController: UIViewController {
    
    internal var nickName: String? {
        didSet {
            nickNameField.text = nickName
        }
    }
    internal var email: String? {
        didSet {
            emailLabel.text = email
        }
    }
    internal var sns: SNS? {
        didSet {
            guard let sns = sns else { return }
            
            snsImageView.image = UIImage(named: sns.rawValue)
            
            switch sns {
            case .kakao:
                snsImageContainerView.backgroundColor = UIColor.appColor(.kakao)
            case .naver:
                snsImageContainerView.backgroundColor = UIColor.appColor(.naver)
            }
        }
    }
    private var isAuthForAlbum: Bool?
    private var profileImageChangeOkay = false
    private var nickNameChangeOkay = false
    private var passwordChangeStarted = false
    private var oldPasswordValidationOkay = false
    private var newPasswordValidationOkay = false
    private var newPasswordCheckValidationOkay = false
    private var saveButtonOkay = false {
        didSet {
            rightButton.isEnabled = saveButtonOkay ? true : false
        }
    }
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let naviBar = UINavigationBar(frame: .zero)
    private lazy var leftButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
    private lazy var rightButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(save))
    private let profileImageView = ProfileImageSelectorView(size: 80)
    private let plusCircleView = PlusCircleFillView(size: 30)
    private let nickNameField: UITextField = {
       
        let field = UITextField(frame: .zero)
        field.font = .boldSystemFont(ofSize: 16)
        
        return field
    }()
    private let separator: UIView = {
       
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.appColor(.keyColor1)
        
        return view
    }()
    
    
    
    
    
    
    
    
    private lazy var snsImageContainerView: UIView = {
       
        let view = UIView(frame: .zero)
        view.addSubview(snsImageView)
        snsImageView.centerXY(inView: view)
        snsImageView.setDimensions(height: 10, width: 10)
        view.layer.cornerRadius = 3
        
        return view
    }()
    private lazy var snsImageView = UIImageView(frame: .zero)
    private let emailLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 12)
    private lazy var horizontalEmailStackView: UIStackView = {
       
        let view = UIStackView()
        
        if sns != nil {
            view.addArrangedSubview(snsImageContainerView)
            snsImageContainerView.setDimensions(height: 14, width: 14)
        }
        view.addArrangedSubview(emailLabel)
        view.spacing = 4
        
        return view
    }()
    
    private let oldPasswordLabel = CustomLabel(title: "기존 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var oldPasswordInputField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecure))
    private lazy var oldPasswordStackView: UIStackView = {
       
        let view = UIStackView(arrangedSubviews: [oldPasswordLabel, oldPasswordInputField])
        
        view.spacing = 4
        view.axis = .vertical
//        view.alignment = .leading
        
        return view
    }()
    private let newPasswordLabel = CustomLabel(title: "새 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecure))
    private let newPasswordValidationLabel = CustomLabel(title: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", tintColor: .ppsGray1, size: 12)
    private lazy var newPasswordStackView: UIStackView = {
        
         let view = UIStackView(arrangedSubviews: [newPasswordLabel, newPasswordField, newPasswordValidationLabel])
         
         view.spacing = 4
         view.axis = .vertical
//        view.alignment = .leading
         
         return view
    }()
    private let newPasswordCheckLabel = CustomLabel(title: "비밀번호 확인", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordCheckField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecure))
    private let newPasswordCheckValidationLabel = CustomLabel(title: "", tintColor: .subColor1, size: 12)
    private lazy var newPasswordCheckStackView: UIStackView = {
        
         let view = UIStackView(arrangedSubviews: [newPasswordCheckLabel, newPasswordCheckField, newPasswordCheckValidationLabel])
         
         view.spacing = 4
         view.axis = .vertical
//        view.alignment = .leading
         
         return view
    }()
    private lazy var centerStackView: UIStackView = {
       
        let view = UIStackView(arrangedSubviews: [oldPasswordStackView, newPasswordStackView, newPasswordCheckStackView])
        
        view.spacing = 25
        view.axis = .vertical
        
        return view
    }()
    private let logoutLabel = CustomLabel(title: "로그아웃", tintColor: .keyColor2, size: 16)
    private let separator2 = CustomLabel(title: "|", tintColor: .ppsGray2, size: 16)
    private let leftLabel = CustomLabel(title: "회원탈퇴", tintColor: .keyColor2, size: 16)
    private lazy var beneathStackView: UIStackView = {
        
        let stackView = UIStackView(frame: .zero)
        
        logoutLabel.isUserInteractionEnabled = true
        leftLabel.isUserInteractionEnabled = true
        
        logoutLabel.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(logout)))
        leftLabel.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(leaveApp)))
        
        stackView.addArrangedSubview(logoutLabel)
        stackView.addArrangedSubview(separator2)
        stackView.addArrangedSubview(leftLabel)
        
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "계정관리"
        view.backgroundColor = .systemBackground
        
        nickNameField.delegate = self
        oldPasswordInputField.delegate = self
        newPasswordField.delegate = self
        newPasswordCheckField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        
        plusCircleView.addGestureRecognizer(tapGesture)
        plusCircleView.isUserInteractionEnabled = true
        
        setScrollView()
        setNaviBar()
        addSubviews()
        
        oldPasswordInputField.rightView?.tag = 0
        newPasswordField.rightView?.tag = 1
        newPasswordCheckField.rightView?.tag = 2
        
        enableScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        naviBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(containerView)
        }
        profileImageView.centerX(inView: containerView)
        profileImageView.anchor(top: naviBar.bottomAnchor, topConstant: 40)
        plusCircleView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
        }
        nickNameField.centerX(inView: containerView)
        nickNameField.anchor(top: profileImageView.bottomAnchor, topConstant: 24)
        separator.centerX(inView: containerView)
        separator.anchor(top: nickNameField.bottomAnchor, width: 170, height: 2)
        horizontalEmailStackView.centerX(inView: containerView)
        horizontalEmailStackView.anchor(top: separator.bottomAnchor, topConstant: 5)
        centerStackView.anchor(top: horizontalEmailStackView.bottomAnchor, topConstant: 60, leading: containerView.leadingAnchor, leadingConstant: 20, trailing: containerView.trailingAnchor, trailingConstant: 20)
        beneathStackView.centerX(inView: containerView)
        beneathStackView.anchor(top: centerStackView.bottomAnchor, topConstant: 70)
        beneathStackView.anchor(top: centerStackView.bottomAnchor, topConstant: 50)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func save() {
        dismiss(animated: true)
    }
    
    @objc private func touchUpImageView() {
        PHPhotoLibrary.requestAuthorization( { status in
            
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.setupImagePicker()
                }
            case .denied:
                if self.isAuthForAlbum == false {
                    DispatchQueue.main.async {
                        self.AuthSettingOpen()
                    }
                }
                self.isAuthForAlbum = false
                
            case .restricted, .notDetermined:
                break
            default:
                break
            }
        })
    }
    
    @objc private func toggleIsSecure(sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.isSelected.toggle()
            oldPasswordInputField.isSecureTextEntry = oldPasswordInputField.isSecureTextEntry ? false : true
        } else if sender.tag == 1 {
            
            sender.isSelected.toggle()
            newPasswordField.isSecureTextEntry = newPasswordField.isSecureTextEntry ? false : true
        } else {
            
            sender.isSelected.toggle()
            newPasswordCheckField.isSecureTextEntry = newPasswordCheckField.isSecureTextEntry ? false : true
        }
    }
    
    @objc private func logout() {
        print(#function)
    }
    
    @objc private func leaveApp() {
        navigationController?.pushViewController(ByeViewController(), animated: true)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    private func AuthSettingOpen() {

        let message = "📌프로필 사진 변경을\n위해 사진 접근 권한이\n필요합니다"
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let settingAction = UIAlertAction(title: "설정하기", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        
        //alert 사이즈 변경
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        
        alert.view.removeConstraints(widthConstraints)
        
        let newWidth = UIScreen.main.bounds.width * 0.6
        let widthConstraint = NSLayoutConstraint(item: alert.view!,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: newWidth)
        
        alert.view.addConstraint(widthConstraint)
        
        let firstContainer = alert.view.subviews[0]
        let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        
        firstContainer.removeConstraints(constraint)
        alert.view.addConstraint(NSLayoutConstraint(item: firstContainer,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: alert.view,
                                                    attribute: .width,
                                                    multiplier: 1.0,
                                                    constant: 0))
        
        let innerBackground = firstContainer.subviews[0]
        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        
        innerBackground.removeConstraints(innerConstraints)
        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: firstContainer,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var viewFrame = self.view.frame

        viewFrame.size.height -= keyboardSize.height

        let activeField: UITextField? = [nickNameField, oldPasswordInputField, newPasswordField, newPasswordCheckField].first { $0.isFirstResponder }

        if let activeField = activeField {

            if !viewFrame.contains(activeField.frame.origin) {

                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - keyboardSize.height)

                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func pullKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func validateCheck(_ textField: UITextField) {
        
        switch textField {
        case oldPasswordInputField:
            
            if let password = textField.text {
                let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}", options: .regularExpression)
                oldPasswordValidationOkay = range != nil ? true : false
            }
            
        case newPasswordField:

            if let password = textField.text {
                let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}", options: .regularExpression)
                newPasswordValidationOkay = range != nil ? true : false
            }
            
        case newPasswordCheckField:
            
            if let check = textField.text {
                newPasswordCheckValidationOkay = check == newPasswordField.text ? true : false
            }
        default: break
        }
    }
    
    private func checkSaveButtonPossible() {
        if passwordChangeStarted {
            if oldPasswordValidationOkay &&
                newPasswordValidationOkay &&
                newPasswordCheckValidationOkay {
                saveButtonOkay = true
            } else {
                saveButtonOkay = false
            }
        } else {
            saveButtonOkay = profileImageChangeOkay || nickName != nickNameField.text ? true : false
        }
    }
    
    private func enableScroll() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setScrollView() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        scrollView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(safeArea.snp.height)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func setNaviBar() {
        
        let navItem = UINavigationItem(title: "계정 관리")
        
        rightButton.isEnabled = false
        
        naviBar.tintColor = UIColor.appColor(.keyColor1)
        naviBar.barTintColor = .systemBackground
        naviBar.isTranslucent = false
        naviBar.shadowImage = UIImage()
        
        navItem.titleView?.tintColor = UIColor.appColor(.ppsBlack)
        navItem.leftBarButtonItem = leftButton
        navItem.rightBarButtonItem = rightButton
        
        naviBar.setItems([navItem], animated: true)
        
        naviBar.topItem?.leftBarButtonItem = leftButton
    }
    
    private func addSubviews() {
        containerView.addSubview(naviBar)
        containerView.addSubview(profileImageView)
        containerView.addSubview(plusCircleView)
        containerView.addSubview(nickNameField)
        containerView.addSubview(separator)
        containerView.addSubview(horizontalEmailStackView)
        containerView.addSubview(centerStackView)
        containerView.addSubview(beneathStackView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AccountManagementViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                DispatchQueue.main.async {
                    
                    if let image = image as? UIImage {
                        self.profileImageView.image = image
                        self.profileImageChangeOkay = true
                        
                        if self.passwordChangeStarted {
                            if self.oldPasswordValidationOkay &&
                                self.newPasswordValidationOkay &&
                                self.newPasswordCheckValidationOkay {
                                self.saveButtonOkay = true
                            } else {
                                self.saveButtonOkay = false
                            }
                        } else {
                            self.saveButtonOkay = true
                        }
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

extension AccountManagementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == nickNameField else { return true }
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)

        guard finalText.count <= 10 else { return false }
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.checkInvalidCharacters() || isBackSpace == -92 { return true }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        switch textField {
//        case nickNameField:
//            checkSaveButtonPossible()
//        case oldPasswordInputField:
//
//            validateCheck(textField)
//            checkSaveButtonPossible()
//
//        case newPasswordField:
//
//            validateCheck(textField)
//            checkSaveButtonPossible()
//
//        case newPasswordCheckField:
//
//            validateCheck(textField)
//            checkSaveButtonPossible()
//        default: break
//        }
//    }
}
