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
    
    let profileSettingView = ProfileSettingView(frame: .zero)
    let isButtonFilled = false
    
    override func loadView() {
        view = profileSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSettingView.assignDelegate(to: self)
        profileSettingView.nickNameTextFieldAddTarget(target: self, action: #selector(textFieldDidChange))
        profileSettingView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
    }
    
    
    @objc private func touchUpImageView() {
        checkAlbumPermission()
    }
    
    @objc func textFieldDidChange() {
        profileSettingView.toggleDoneButton()
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    private func checkAlbumPermission(){
            PHPhotoLibrary.requestAuthorization( { status in
                switch status {
                case .authorized:
                    self.setupImagePicker()
                case .denied:
                    print("Album: 권한 거부")
                case .restricted, .notDetermined:
                    print("Album: 선택하지 않음")
                default:
                    break
                }
                
            })
        }
}

extension ProfileSettingViewController: PHPickerViewControllerDelegate {
//    권한 묻기
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileSettingView.setProfileImage(into: image as? UIImage)
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
}

extension String {
    func checkInvalidCharacters() -> Bool{
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) { return true }
        } catch {
            print(error.localizedDescription)
            
            return false
        }
        
        return false
    }
}
