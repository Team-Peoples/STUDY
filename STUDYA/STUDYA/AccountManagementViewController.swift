//
//  AccountManagementViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/30.
//

import UIKit
import SnapKit
import PhotosUI
import Photos
import Kingfisher

//To be fixed: 입력칸 rightbutton 오른쪽 padding 10 넣기

final class AccountManagementViewController: UIViewController {
    
    // domb: 중복된 기능의 코드들 삭제.
    private var profileImage: UIImage? { willSet { profileImageView.setImageWith(newValue) } }
    private var nickName: String? { didSet { nickNameField.text = nickName } }
    private var email: String? { didSet { emailLabel.text = email } }
    private var sns: SNS = .none { didSet { snsImageView.image = UIImage(named: sns.rawValue + "Small") } }
    
    // domb: isAuthForAlbum 은 항상 Nil아니면 false인데 그러면 없어도 되는거 아닌가.
    private var isAuthForAlbum: Bool?
    private var profileImageChangeOkay = false
    private var passwordChangeStarted = false
    private var oldPasswordIsCorrect = true {
        didSet {
            if oldPasswordIsCorrect {
                oldPasswordValidationLabel.textColor = .appColor(.background)
            } else {
                oldPasswordValidationLabel.textColor = .appColor(.subColor1)
            }
        }
    }
    private var newPasswordValidationOkay = false {
        didSet {
            if newPasswordValidationOkay {
                newPasswordValidationLabel.textColor = .systemBackground
            } else {
                newPasswordValidationLabel.textColor = newPasswordField.text == "" ? UIColor.appColor(.ppsGray1) : UIColor.appColor(.subColor1)
            }
        }
    }
    private var newPasswordCheckValidationOkay = false {
        didSet {
            if newPasswordCheckValidationOkay {
                newPasswordCheckValidationLabel.alpha = 0
            } else {
                newPasswordCheckValidationLabel.alpha = newPasswordCheckField.text == "" ? 0 : 1
            }
        }
    }
    private var saveButtonOkay = false {
        didSet {
            rightButton.isEnabled = saveButtonOkay ? true : false
        }
    }
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let naviBar = UINavigationBar(frame: .zero)
    private lazy var leftButton = UIBarButtonItem(title: Const.cancel, style: .plain, target: self, action: #selector(cancel))
    private lazy var rightButton = UIBarButtonItem(title: Const.OK, style: .plain, target: self, action: #selector(save))
    private let profileImageView = ProfileImageView(size: 80)
    private let plusCircleView = PlusCircleFillView(size: 30)
    private let nickNameField = CustomTextField(placeholder: "닉네임", fontSize: 16)
    private let separator = UIView(backgroundColor: .appColor(.keyColor1))

    private lazy var snsImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setDimensions(height: 14, width: 14)
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    private let emailLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 12)
    private lazy var horizontalEmailStackView: UIStackView = {
       
        let view = UIStackView()
        
        if sns != .none {
            view.addArrangedSubview(snsImageView)
        }
        view.addArrangedSubview(emailLabel)
        view.spacing = 4
        
        return view
    }()
    private lazy var oldPasswordLabel = CustomLabel(title: "기존 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var oldPasswordInputField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var oldPasswordValidationLabel = CustomLabel(title: "기존 비밀번호를 올바르게 입력해주세요.", tintColor: .background, size: 12)
    private lazy var oldPasswordStackView: UIStackView = {
       
        let view = UIStackView(arrangedSubviews: [oldPasswordLabel, oldPasswordInputField, oldPasswordValidationLabel])
        
        view.spacing = 4
        view.axis = .vertical
        
        return view
    }()
    private lazy var newPasswordLabel = CustomLabel(title: "새 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var newPasswordValidationLabel = CustomLabel(title: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", tintColor: .ppsGray1, size: 12)
    private lazy var newPasswordStackView: UIStackView = {
        
         let view = UIStackView(arrangedSubviews: [newPasswordLabel, newPasswordField, newPasswordValidationLabel])
         
         view.spacing = 4
         view.axis = .vertical
         
         return view
    }()
    private lazy var newPasswordCheckLabel = CustomLabel(title: "비밀번호 확인", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordCheckField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var newPasswordCheckValidationLabel = CustomLabel(title: "비밀번호가 맞지 않아요.", tintColor: .subColor1, size: 12)
    private lazy var newPasswordCheckStackView: UIStackView = {
        
         let view = UIStackView(arrangedSubviews: [newPasswordCheckLabel, newPasswordCheckField, newPasswordCheckValidationLabel])
         
         view.spacing = 4
         view.axis = .vertical
         
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
        
        logoutLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logout)))
        leftLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leaveApp)))
        
        stackView.addArrangedSubview(logoutLabel)
        stackView.addArrangedSubview(separator2)
        stackView.addArrangedSubview(leftLabel)
        
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }()
    private lazy var alertToastMessage = ToastMessage(message: "먼저 기존 비밀번호를 입력해주세요.", messageColor: .whiteLabel, messageSize: 12, image: "emailCheck")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setDelegate()
        profileImageViewAddTapGesture()
        setScrollView()
        setNaviBar()
        addSubviews()
        enableScroll()
        setConstraints()
        setTextFields()
        
        getUserInfo { user in
            self.nickName = user.nickName
            self.email = user.id
            
            guard let imageURL = user.imageURL else { return }
            
            self.profileImageView.setImageWith(imageURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func save() {
        
        if let password = oldPasswordInputField.text , password != "" {
            self.checkOldPassword(password) { isCorrectOldPassword in
                if isCorrectOldPassword {
                    self.oldPasswordIsCorrect = isCorrectOldPassword
                    self.updateUserInfo()
                } else {
                    self.oldPasswordIsCorrect = isCorrectOldPassword
                }
            }
        } else {
            self.updateUserInfo()
        }
    }
    
    @objc private func toggleIsSecureTextEntry(_ sender: UIButton) {
        
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
        AppController.shared.deleteUserInformationAndLogout()
    }
    
    @objc private func leaveApp() {
        let alertController = UIAlertController(title: "정말 탈퇴하시겠어요?", message: "참여한 모든 스터디 기록이 삭제되고, 다시 가입해도 복구할 수 없어요.😥", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)
        let closeAccountAction = UIAlertAction(title: "탈퇴하기", style: .destructive) {
            _ in
            
            self.closeAccount()
        }
        
        alertController.addAction(closeAccountAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - TextField Validation Check
    
    private func validateCheck(_ textField: UITextField) {
        
        if let password = textField.text {
            let range = password.range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}", options: .regularExpression)
            switch textField {
            case newPasswordField: newPasswordValidationOkay = range != nil ? true : false
            case newPasswordCheckField: newPasswordCheckValidationOkay = textField.text == newPasswordField.text ? true : false
            default: break
            }
        }
    }
    
    private func checkSaveButtonPossible() {
        if passwordChangeStarted {
            if newPasswordValidationOkay &&
                newPasswordCheckValidationOkay {
                saveButtonOkay = true
            } else {
                saveButtonOkay = false
            }
        } else {
            saveButtonOkay = profileImageChangeOkay || nickName != nickNameField.text ? true : false
        }
    }
    
    private func setTextFields() {
        
        newPasswordField.text = ""
        newPasswordCheckField.text = ""
        newPasswordValidationLabel.textColor = UIColor.appColor(.ppsGray1)
        newPasswordCheckValidationLabel.alpha = 0
        
        passwordChangeStarted = false
        newPasswordValidationOkay = false
        newPasswordCheckValidationOkay = false
        
        nickNameField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        oldPasswordInputField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        oldPasswordInputField.rightView?.tag = 0
        newPasswordField.rightView?.tag = 1
        newPasswordCheckField.rightView?.tag = 2
    }
    
    // MARK: - Configure
    
    private func enableScroll() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func profileImageViewAddTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        
        plusCircleView.addGestureRecognizer(tapGesture)
        plusCircleView.isUserInteractionEnabled = true
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
            make.height.equalTo(scrollView.frameLayoutGuide).priority(250)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    private func setDelegate() {
        nickNameField.delegate = self
        oldPasswordInputField.delegate = self
        newPasswordField.delegate = self
        newPasswordCheckField.delegate = self
    }
    
    private func setNaviBar() {
        
        let navItem = UINavigationItem(title: "계정 관리")
        
        rightButton.isEnabled = false
       
        naviBar.tintColor = UIColor.appColor(.keyColor1)
        naviBar.barTintColor = .systemBackground
        naviBar.isTranslucent = false
        naviBar.shadowImage = UIImage()
        naviBar.setItems([navItem], animated: true)
        naviBar.topItem?.leftBarButtonItem = leftButton
        
        navItem.title = "계정 관리"
        navItem.titleView?.tintColor = UIColor.appColor(.ppsBlack)
        navItem.leftBarButtonItem = leftButton
        navItem.rightBarButtonItem = rightButton
    }
    
    private func addSubviews() {
        containerView.addSubview(naviBar)
        containerView.addSubview(profileImageView)
        containerView.addSubview(plusCircleView)
        containerView.addSubview(nickNameField)
        containerView.addSubview(separator)
        containerView.addSubview(horizontalEmailStackView)
        if sns == .none {
            containerView.addSubview(centerStackView)
        }
        containerView.addSubview(beneathStackView)
        view.addSubview(alertToastMessage)
    }
    

    private func showToastMessage() {
        oldPasswordInputField.isEnabled = false
        newPasswordField.isEnabled = false
        newPasswordCheckField.isEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            
            alertToastMessage.snp.updateConstraints { make in
                make.bottom.equalTo(view).offset(-100)
            }
            
            view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.alertToastMessage.alpha = 0
            } completion: {[self] _ in
                
                alertToastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(view).offset(50)
                }
                alertToastMessage.alpha = 0.9
                oldPasswordInputField.isEnabled = true
                newPasswordField.isEnabled = true
                newPasswordCheckField.isEnabled = true
            }
        }
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        naviBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(containerView)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(naviBar.snp.bottom).offset(40)
        }
        plusCircleView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
        }
        nickNameField.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
        }
        separator.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(nickNameField.snp.bottom).offset(1)
            make.width.equalTo(170)
            make.height.equalTo(2)
        }
        horizontalEmailStackView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(separator.snp.bottom).offset(5)
        }
        if sns == .none {
            centerStackView.snp.makeConstraints { make in
                make.top.equalTo(horizontalEmailStackView.snp.bottom).offset(60)
                make.leading.trailing.equalTo(containerView).inset(20)
            }
            
            alertToastMessage.snp.makeConstraints { make in
                make.centerX.equalTo(view)
                make.leading.trailing.equalTo(view).inset(20)
                make.height.equalTo(42)
                make.bottom.equalTo(view).offset(50)
            }
        }
        beneathStackView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(30)
            if sns == .none {
                make.top.greaterThanOrEqualTo(centerStackView).offset(40)
            }
        }
    }
    
    // MARK: - Networking
    
    private func getUserInfo(completion: @escaping (User) -> Void) {
        Network.shared.getUserInfo { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUserInfo() {
        Network.shared.updateUserInfo(oldPassword: oldPasswordInputField.text, password: newPasswordField.text, passwordCheck: newPasswordCheckField.text, nickname: nickNameField.text, image: profileImage) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func closeAccount() {
        
        guard let userId = KeyChain.read(key: Const.userId) else { return }
        
        Network.shared.closeAccount(userID: userId) { result in
            switch result {
            case .success(let isNotManager):
                switch isNotManager {
                case true:
                    print("참여중인 스터디의 스터디장이 아닐경우 탈퇴됨.")
                    
                    AppController.shared.deleteUserInformation()
                    
                    DispatchQueue.main.async {
                        let vc = ByeViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                    
                case false:
                    print("참여중인 스터디의 스터디장일 경우 양도하는 플로우로 연결")
                }
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func checkOldPassword(_ password: String, completion: @escaping (Bool) -> Void) {
        
        guard let email = email else { fatalError() }
        
        Network.shared.checkIfCorrectedOldPassword(userID: email, password: password) { result in
            switch result {
            case .success(let isCorrectOldPassword):
                completion(isCorrectOldPassword)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AccountManagementViewController: PHPickerViewControllerDelegate {
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    private func AuthSettingOpen() {
        
        let alert = UIAlertController(title: "", message: "📌프로필 사진 변경을\n위해 사진 접근 권한이\n필요합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Const.cancel, style: .default)
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
    
    @objc private func touchUpImageView() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectImageAction = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.openAlbum()
        }
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)
        
        if profileImage != nil {
            let defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
                self.profileImage = nil
                self.profileImageChangeOkay = true
            }
            
            alert.addAction(defaultImageAction)
        }
        
        alert.addAction(selectImageAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func openAlbum() {
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
            default:
                break
            }
        })
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                DispatchQueue.main.async {
                    
                    if let image = image as? UIImage {
                        self.profileImageView.setImageWith(image)
                        self.profileImageChangeOkay = true
                        self.checkSaveButtonPossible()
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

extension AccountManagementViewController: UITextFieldDelegate {
    
    @objc private func textDidChanged(_ textField: UITextField) {
       
        switch textField {
        case oldPasswordInputField:
            if textField.text == "" || textField.text == nil {
                oldPasswordValidationLabel.textColor = .appColor(.background)
                passwordChangeStarted = false
            } else {
                passwordChangeStarted = true
            }
        default:
            break
        }
        checkSaveButtonPossible()
        validateCheck(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        switch textField {
        case newPasswordField, newPasswordCheckField:
            if oldPasswordInputField.text == "" || oldPasswordInputField.text == nil {
                oldPasswordValidationLabel.textColor = .appColor(.background)
                showToastMessage()
                return false

            } else {
                return true
            }
        default:
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      
        switch textField {
        case oldPasswordInputField:
            if textField.text == "" || textField.text == nil {
                oldPasswordValidationLabel.textColor = .appColor(.background)
                passwordChangeStarted = false
               
            } else {
                passwordChangeStarted = true
            }
        default: break
        }
        validateCheck(textField)
        checkSaveButtonPossible()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nickNameField, oldPasswordInputField, newPasswordCheckField:
            textField.resignFirstResponder()
        case newPasswordField:
            newPasswordCheckField.becomeFirstResponder()
        default: break
        }
        return true
    }
    
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
}
