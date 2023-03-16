//
//  EditingStudyFreeRuleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/12/27.
//
// 스터디 만들기 - 스터디 진행방식

import UIKit

final class EditingStudyFreeRuleViewController: UIViewController {

    // MARK: - Properties
    
    static let identifier = "EditingStudyFreeRuleViewController"
    
    let studyViewModel = StudyViewModel()
    
    @IBOutlet weak var freeRuletextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: - Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        studyViewModel.bind { study in
            self.freeRuletextView.text = study.freeRule
            self.placeholderLabel.isHidden = study.freeRule == nil || study.freeRule == "" ? false : true
        }
        
        freeRuletextView.delegate = self
        
        self.navigationItem.title = "진행방식"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(ruleEditDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    @objc func ruleEditDone() {
        
        studyViewModel.updateStudy {
            NotificationCenter.default.post(name: .studyInfoShouldUpdate, object: nil)
            self.dismiss(animated: true)
        }
    }
    
    @objc func cancel() {
        
        let simpleAlert = SimpleAlert(title: "작성을 중단할까요?", message: "페이지를 나가면 작성하던 내용이 사라져요.", firstActionTitle: "나가기", actionStyle: .destructive, firstActionHandler: { _ in
            self.dismiss(animated: true)
        }, cancelActionTitle: "남아있기")
        
        present(simpleAlert, animated: true)
    }
    
    // MARK: - Setting Constraints
}

// MARK: - UITextViewDelegate

extension EditingStudyFreeRuleViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        studyViewModel.study.freeRule = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            placeholderLabel.isHidden = false
        }
    }
}
