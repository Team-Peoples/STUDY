//
//  ProfileSettingViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/03.
//

import UIKit
import PhotosUI
import Photos

class ProfileSettingViewController: UIViewController {

    private var isAuthForAlbum: Bool?
    private var nickName: String?
//    private var isButtonFilled = false
    
    private var profileImage: UIImage?
    
    private let titleLabel = CustomLabel(title: "프로필 설정", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var nickNameInputView = ValidationInputView(titleText: "닉네임을 설정해주세요", fontSize: 18, titleBottomPadding: 20, placeholder: "한글/영어/숫자를 사용할 수 있어요", keyBoardType: .default, returnType: .done, isFieldSecure: false, validationText: "*닉네임은 프로필에서 언제든 변경할 수 있어요", cancelButton: true, target: self, textFieldAction: #selector(clearButtonDidTapped))
    private let askingRegisterProfileLabel = CustomLabel(title: "프로필 사진을 등록할까요?", tintColor: .ppsBlack, size: 24)
    private let descriptionLabel = CustomLabel(title: "등록하지 않으면 기본 이미지로 시작돼요", tintColor: .ppsGray1, size: 12, isBold: false)
    private let profileImageSelectorView = ProfileImageContainerView(size: 120)
    private let plusCircleView = PlusCircleFillView(size: 30)
    private let doneButton = BrandButton(title: Constant.done, isBold: true, isFill: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureViews()
    }
    
    @objc private func clearButtonDidTapped() {
        nickNameInputView.getInputField().text = nil
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
    
    @objc private func toggleDoneButton() {
        if let nickName = nickNameInputView.getInputField().text {
            
            if nickName.count > 0 {
                
                doneButton.isEnabled = true
                doneButton.fillIn(title: Constant.done)
            } else {
                
                doneButton.isEnabled = false
                doneButton.fillOut(title: Constant.done)
            }
        }
    }
    
    @objc private func doneButtonDidTapped() {
        view.endEditing(true)
        
        if let isSNSFirstLogin = KeyChain.read(key: Constant.tempIsFirstSNSLogin), isSNSFirstLogin == "1" {
            setProfileWhenSNSSignUp()
        } else {
            signUp()
        }
    }
    
    private func signUp() {
        guard let email = KeyChain.read(key: Constant.tempUserId),
              let password = KeyChain.read(key: Constant.tempPassword),
              let passwordCheck = KeyChain.read(key: Constant.tempPasswordCheck) else {
            
            let alert = SimpleAlert(message: Constant.unknownErrorMessage)
            present(alert, animated: true)
            return
        }
        
        Network.shared.signUp(userId: email, pw: password, pwCheck: passwordCheck, nickname: nickName, image: profileImage) { result in
            switch result {
            case .success(let user):
                
                if let nickName = user.nickName {
                    
                    KeyChain.create(key: Constant.tempNickname, value: nickName)
                    
                    let vc = MailCheckViewController()
                    vc.modalPresentationStyle = .fullScreen
                    
                    self.present(vc, animated: true)
                } else {
                    
                    let alert = SimpleAlert(message: Constant.unknownErrorMessage + " code = 2")
                    
                    self.present(alert, animated: true)
                }
                
            case .failure(let error):
                var alert = SimpleAlert(message: "")
                
                switch error {
                case .duplicatedEmail:
                    alert = SimpleAlert(buttonTitle: Constant.OK, message: "이미 사용중인 이메일이예요. 이전화면에서 다른 이메일을 입력해주세요.", completion: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                case .wrongPassword:
                    alert = SimpleAlert(buttonTitle: Constant.OK, message: "비밀번호와 비밀번호 확인이 서로 달라요. 이전화면에서 비밀번호를 다시 확인해주세요.", completion: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
                
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setProfileWhenSNSSignUp() {
        Network.shared.updateUserInfo(oldPassword: "", password: "", passwordCheck: "", nickname: nickName, image: profileImage) { result in
            switch result {
            case .success:
                KeyChain.delete(key: Constant.tempIsFirstSNSLogin)
                UserDefaults.standard.set(true, forKey: Constant.isLoggedin)
                NotificationCenter.default.post(name: .authStateDidChange, object: nil)
            case .failure(let error):

                switch error {
                case .imageNotFound:
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(message: "이미지를 불러올 수 없습니다. 이미지를 확인해주세요.")
                        self.present(alert, animated: true)
                    }
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
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
    
    private func configureViews() {
        nickNameInputView.getInputField().delegate = self
        nickNameInputView.getInputField().addTarget(target, action: #selector(toggleDoneButton), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        
        profileImageSelectorView.addGestureRecognizer(tapGesture)
        profileImageSelectorView.isUserInteractionEnabled = true
        profileImageSelectorView.setImageWith(UIImage(named: "defaultProfile"))
        
        
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(nickNameInputView)
        view.addSubview(askingRegisterProfileLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(profileImageSelectorView)
        view.addSubview(plusCircleView)
        view.addSubview(doneButton)
    }
    
    private func addConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 40, leading: view.leadingAnchor, leadingConstant: 20)
        nickNameInputView.anchor(top: titleLabel.bottomAnchor, topConstant: 44, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
        
        askingRegisterProfileLabel.anchor(top: nickNameInputView.bottomAnchor, topConstant: 70, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)

        descriptionLabel.anchor(top: askingRegisterProfileLabel.bottomAnchor, topConstant: 8, leading: askingRegisterProfileLabel.leadingAnchor)

        profileImageSelectorView.anchor(top: descriptionLabel.bottomAnchor, topConstant: 46)
        profileImageSelectorView.centerX(inView: view)

        plusCircleView.anchor(bottom: profileImageSelectorView.bottomAnchor, trailing: profileImageSelectorView.trailingAnchor)

        doneButton.anchor(bottom: view.bottomAnchor, bottomConstant: 30, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20)
    }
}

extension ProfileSettingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                DispatchQueue.main.async {
                    
                    if let image = image as? UIImage {
                        self.profileImageSelectorView.setImageWith(image)
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickName = textField.text
    }
}
