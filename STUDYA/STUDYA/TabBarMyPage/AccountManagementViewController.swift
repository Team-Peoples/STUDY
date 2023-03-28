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
import Combine

final class AccountManagementViewController: UIViewController {

    let viewModel = AccountMangementViewModel()
    private var saveButtonEnableCondition: (profileIsChanged: Bool, passwordIsChangedAndValidated: Bool) = (false, true) {
        willSet(newValue) {
            switch newValue {
            case (false, false):
                saveButton.isEnabled = false
            case (true, false):
                saveButton.isEnabled = false
            default:
                saveButton.isEnabled = true
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private lazy var cancelButton = UIBarButtonItem(title: Constant.cancel, style: .plain, target: self, action: #selector(cancel))
    private lazy var saveButton = UIBarButtonItem(title: Constant.OK, style: .plain, target: self, action: #selector(save))
    
    private let profileImageView = ProfileImageContainerView(size: 80)
    private let plusCircleView = PlusCircleFillView(size: 30)
    private let nickNameField = CustomTextField(placeholder: "닉네임", fontSize: 16)
    private let nickNameFieldUnderLine = UIView(backgroundColor: .appColor(.keyColor1))
    private lazy var snsImageView = UIImageView(backgroundColor: .white, cornerRadius: 3)
    
    private let emailLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 12)
    private lazy var horizontalEmailStackView = UIStackView()
    private lazy var oldPasswordLabel = CustomLabel(title: "기존 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var oldPasswordInputField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var oldPasswordValidationLabel = CustomLabel(title: "기존 비밀번호를 올바르게 입력해주세요.", tintColor: .background, size: 12)
    private lazy var oldPasswordStackView = UIStackView(arrangedSubviews: [oldPasswordLabel, oldPasswordInputField, oldPasswordValidationLabel])
    
    private lazy var newPasswordLabel = CustomLabel(title: "새 비밀번호", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var newPasswordValidationLabel = CustomLabel(title: "특수문자, 문자, 숫자를 포함해 8글자 이상으로 설정해주세요.", tintColor: .ppsGray1, size: 12)
    private lazy var newPasswordStackView = UIStackView(arrangedSubviews: [newPasswordLabel, newPasswordField, newPasswordValidationLabel])
         
    private lazy var newPasswordCheckLabel = CustomLabel(title: "비밀번호 확인", tintColor: .ppsBlack, size: 16)
    private lazy var newPasswordCheckField = PurpleRoundedInputField(target: self, action: #selector(toggleIsSecureTextEntry))
    private lazy var newPasswordCheckValidationLabel = CustomLabel(title: "비밀번호가 맞지 않아요.", tintColor: .subColor1, size: 12)
    private lazy var newPasswordCheckStackView = UIStackView(arrangedSubviews: [newPasswordCheckLabel, newPasswordCheckField, newPasswordCheckValidationLabel])

    private lazy var centerStackView = UIStackView(arrangedSubviews: [oldPasswordStackView, newPasswordStackView, newPasswordCheckStackView])
    
    private let logoutLabel = CustomLabel(title: "로그아웃", tintColor: .keyColor2, size: 16)
    private let separator = CustomLabel(title: "|", tintColor: .ppsGray2, size: 16)
    private let leftLabel = CustomLabel(title: "회원탈퇴", tintColor: .keyColor2, size: 16)
    private lazy var beneathStackView: UIStackView = {
        
        let stackView = UIStackView(frame: .zero)
        
        logoutLabel.isUserInteractionEnabled = true
        leftLabel.isUserInteractionEnabled = true
        
        logoutLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logout)))
        leftLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leaveApp)))
        
        stackView.addArrangedSubview(logoutLabel)
        stackView.addArrangedSubview(separator)
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
        
        setScrollView()
        setStackView()
        setTextFields()
        setNaviBar()
        
        profileImageViewAddTapGesture()
    
        configureViews()
        
        viewModel.getUserInfo { [weak self] user in
            print(user)
            self?.nickNameField.text = user.nickName
            self?.emailLabel.text = user.id
            
            if let kakaoLogin = user.isKakaoLogin, kakaoLogin {
                self?.snsImageView.image = UIImage(named: SNS.kakao.rawValue + "Small")
                self?.centerStackView.isHidden = true
            } else if let naverLogin = user.isNaverLogin, naverLogin {
                self?.snsImageView.image = UIImage(named: SNS.naver.rawValue + "Small")
                self?.centerStackView.isHidden = true
            }
            
            guard let imageURL = user.imageURL else { return }
            self?.profileImageView.setImageWith(imageURL)
        }
        
        addPublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        viewModel.cancellables.forEach { $0.cancel() }
    }
    // MARK: - Actions
    
    @objc private func cancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func save() {
        viewModel.updateUserInfo() {
            self.dismiss(animated: true)
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
        let simpleAlert = SimpleAlert(title: "로그아웃", message: "로그아웃 하시겠어요?", firstActionTitle: "로그아웃", actionStyle: .destructive, firstActionHandler: { _ in
            AppController.shared.deleteUserInformationAndLogout()
        }, cancelActionTitle: "취소")
        
        present(simpleAlert, animated: true)
    }
    
    @objc private func leaveApp() {
        let alertController = SimpleAlert(title: "정말 탈퇴하시겠어요?", message: "참여한 모든 스터디 기록이 삭제되고, 다시 가입해도 복구할 수 없어요.😥", firstActionTitle: "탈퇴하기", actionStyle: .destructive, firstActionHandler: { [weak self] _ in
            self?.viewModel.closeAccount{ result in
                switch result {
                case .success(let isNotManager):
                    if isNotManager {
                        print("참여중인 스터디의 스터디장이 아닐경우 탈퇴됨.")
                        
                        AppController.shared.deleteUserInformation()
                        
                        self?.deleteAllUserDefaults()
                        self?.presentByeViewController()
                    } else {
                        print("참여중인 스터디의 스터디장일 경우 양도하는 플로우로 연결")
                    }
                    
                case .failure(let error):
                    UIAlertController.handleCommonErros(presenter: self!, error: error)
                }
            }
        }, cancelActionTitle: Constant.cancel)
        
        present(alertController, animated: true)
    }
    
    @objc func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardDisappear(_ notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func pullKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addPublisher() {
        
        oldPasswordInputField.textPublisher
            .assign(to: \.oldPassword, on: viewModel)
            .store(in: &viewModel.cancellables)

        newPasswordField.textPublisher
            .assign(to: \.newPassword, on: viewModel)
            .store(in: &viewModel.cancellables)


        newPasswordCheckField.textPublisher
            .assign(to: \.newPasswordCheck, on: viewModel)
            .store(in: &viewModel.cancellables)
        
        viewModel.profileIsChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (profileIsChanged) in
                self?.saveButtonEnableCondition.profileIsChanged = profileIsChanged
            }
            .store(in: &viewModel.cancellables)

        viewModel.passwordFormIsValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (oldpasswordIsEmpty,
                                 oldPasswordIsValid,
                                 newPasswordIsValid,
                                 newPasswordCheckIsValid) in

                if oldPasswordIsValid {
                    self?.oldPasswordValidationLabel.textColor = .appColor(.ppsBlack)
                    self?.oldPasswordValidationLabel.text = "기존 비밀번호가 맞습니다. 아래에 변경할 비밀번호를 입력해주세요."
                    self?.oldPasswordInputField.isEnabled = false
                } else {
                    if oldpasswordIsEmpty {
                        self?.oldPasswordValidationLabel.textColor = .appColor(.whiteLabel)
                    } else {
                        self?.oldPasswordValidationLabel.textColor = .appColor(.subColor1)
                        self?.oldPasswordValidationLabel.text = "기존 비밀번호를 올바르게 입력해주세요."
                    }
                }

                if newPasswordIsValid {
                    self?.newPasswordValidationLabel.textColor = .white
                } else {
                    if oldpasswordIsEmpty {
                        self?.newPasswordValidationLabel.textColor = .white
                    } else {
                        self?.newPasswordValidationLabel.textColor = UIColor.appColor(.ppsGray1)
                    }
                }

                if newPasswordCheckIsValid || self?.newPasswordField.text == String() {
                    self?.newPasswordCheckValidationLabel.alpha = 0
                } else {
                    self?.newPasswordCheckValidationLabel.alpha = 1
                }

                self?.saveButtonEnableCondition.passwordIsChangedAndValidated = oldpasswordIsEmpty || (oldPasswordIsValid && newPasswordIsValid && newPasswordCheckIsValid)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setStackView() {
        
        horizontalEmailStackView.spacing = 4
        horizontalEmailStackView.axis = .horizontal
        
        oldPasswordStackView.spacing = 4
        oldPasswordStackView.axis = .vertical
        newPasswordStackView.spacing = 4
        newPasswordStackView.axis = .vertical
        newPasswordCheckStackView.spacing = 4
        newPasswordCheckStackView.axis = .vertical
        
        centerStackView.spacing = 25
        centerStackView.axis = .vertical
    }
    
    private func setTextFields() {
        
        nickNameField.delegate = self
        oldPasswordInputField.delegate = self
        newPasswordField.delegate = self
        newPasswordCheckField.delegate = self
        
        newPasswordValidationLabel.textColor = UIColor.appColor(.ppsGray1)
        newPasswordCheckValidationLabel.alpha = 0
        
        nickNameField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        oldPasswordInputField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        oldPasswordInputField.rightView?.subviews.first?.tag = 0
        newPasswordField.rightView?.subviews.first?.tag = 1
        newPasswordCheckField.rightView?.subviews.first?.tag = 2
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
        
        scrollView.showsVerticalScrollIndicator = false
        enableScroll()
    }
    
    private func setNaviBar() {
        
        navigationItem.title = "계정 관리"

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.ppsBlack)]
        navigationController?.navigationBar.tintColor = .appColor(.keyColor1)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        saveButton.isEnabled = false
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(plusCircleView)
        containerView.addSubview(nickNameField)
        containerView.addSubview(nickNameFieldUnderLine)
        containerView.addSubview(horizontalEmailStackView)
        containerView.addSubview(beneathStackView)
        horizontalEmailStackView.addArrangedSubview(snsImageView)
        
        containerView.addSubview(centerStackView)
        
        
        horizontalEmailStackView.addArrangedSubview(emailLabel)
        
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
            
            UIView.animate(withDuration: 1, delay: 2, options: .curveLinear) {
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
        
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.height.equalTo(safeArea)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(250)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(containerView).offset(40)
        }
        plusCircleView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
        }
        nickNameField.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
        }
        nickNameFieldUnderLine.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(nickNameField.snp.bottom).offset(1)
            make.width.equalTo(170)
            make.height.equalTo(2)
        }
        horizontalEmailStackView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(nickNameFieldUnderLine.snp.bottom).offset(5)
        }
        snsImageView.snp.makeConstraints { make in
            make.height.width.equalTo(14)
        }
        
        if viewModel.sns == .none {
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
            if viewModel.sns == .none {
                make.top.greaterThanOrEqualTo(centerStackView).offset(40)
            }
        }
    }
    
    private func deleteAllUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
           UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    private func presentByeViewController() {
        let vc = ByeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension AccountManagementViewController: PHPickerViewControllerDelegate {
    
    private func openImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    private func requestAuthorization() {
        
        let alert = UIAlertController(title: "", message: "📌프로필 사진 변경을\n위해 사진 접근 권한이\n필요합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .default)
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
        let selectImageAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            self?.openAlbum()
        }
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        if profileImageView.internalImage != nil {
            let defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { [weak self] _ in
                self?.profileImageView.internalImage = nil
                self?.viewModel.profileImage = nil
                
                if self?.viewModel.profileImageChanged == false  {
                    self?.viewModel.profileImageChanged = true
                }
            }

            alert.addAction(defaultImageAction)
        }
        
        alert.addAction(selectImageAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func openAlbum() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in

            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self?.openImagePicker()
                }
            case .denied:
                DispatchQueue.main.async {
                    self?.requestAuthorization()
                }
            default:
                break
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        guard let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            
            DispatchQueue.main.async {

                guard let image = image as? UIImage else { return }
                self?.viewModel.profileImage = image
                self?.profileImageView.setImageWith(image)
                
                if self?.viewModel.profileImageChanged == false  {
                    self?.viewModel.profileImageChanged = true
                }
            }
        }
    }
}

extension AccountManagementViewController: UITextFieldDelegate {

    
    @objc private func textDidChanged(_ textField: UITextField) {
        if textField == nickNameField {
            viewModel.nickName = nickNameField.text
            
            if !viewModel.nicknameChanged  {
                viewModel.nicknameChanged = true
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == newPasswordField || textField == newPasswordCheckField {
            if viewModel.oldPasswordIsValidated {
                return true
            } else {
                showToastMessage()
                return false
            }
        } else {
            return true
        }
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

