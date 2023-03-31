//
//  CreatingStudyFreeRuleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/02.
//
// 스터디 만들기 - 스터디 진행방식

import UIKit

final class CreatingStudyFreeRuleViewController: UIViewController {

    // MARK: - Properties
    
    static let identifier = "CreatingStudyFreeRuleViewController"
    
    var completeButtonTapped: (String) -> () = { freeRule in }
    var viewDidUpdated: (UITextView) -> () = { view in }
    
    @IBOutlet weak var freeRuletextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private let completeButton = BrandButton(title: Constant.done, isBold: true, isFill: true, fontSize: 18, height: 50)
    
    // MARK: - Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        freeRuletextView.delegate = self
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        
        enableTapGesture()
        addNotification()
        viewDidUpdated(freeRuletextView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(completeButton)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        placeholderLabel.isHidden = freeRuletextView.text != "" ? true : false
        
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc func completeButtonDidTapped() {
        completeButtonTapped(freeRuletextView.text)
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
    
    @objc func pullKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func enableTapGesture() {

        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))

        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false

        view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(320)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - UITextViewDelegate

extension CreatingStudyFreeRuleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            placeholderLabel.isHidden = false
        }
    }
}
