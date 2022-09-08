//
//  StudyFreeRuleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/02.
//
// 스터디 만들기 - 스터디 진행방식

import UIKit
import SnapKit

class StudyFreeRuleViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    private let completeButton = CustomButton(title: "완료", isBold: true, size: 20, height: 50)
    private var isRepeat: Bool = false
    
    var freeStudyRule: FreeStudyRule?
    var completion: ((FreeStudyRule) -> ())?
    
    // MARK: - Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(completeButton)
        textView.delegate = self
        cancelButton.action = #selector(cancelButtonDidTapped)
        completeButton.isUserInteractionEnabled = false
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        setConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: - Configure
    
    // MARK: - Actions
    
    @objc func cancelButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func completeButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func didReceiveKeyboardNotification(_ sender: Notification) {
            
        switch sender.name {
            case UIResponder.keyboardWillShowNotification:
                guard let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardFrameRect = keyboardFrame.cgRectValue
                
                UIView.animate(withDuration: 0.3) {
                    self.completeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrameRect.height + 26)
                }
                
            case UIResponder.keyboardWillHideNotification :
                completeButton.transform = .identity
                
            default : break
        }
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(320)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - UITextViewDelegate

extension StudyFreeRuleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            placeholderLabel.isHidden = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range == NSRange(location: 0, length: 1) {
            completeButton.isUserInteractionEnabled = false
            completeButton.fillOut(title: "완료")
            isRepeat = false
        } else if text != "" {
            if !isRepeat {
                print(#function)
                completeButton.fillIn(title: "완료")
                completeButton.isUserInteractionEnabled = true
                isRepeat = true
            }
        }
        return true
    }
}
