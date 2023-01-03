//
//  EditingStudyFreeRuleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/12/27.
//
// 스터디 만들기 - 스터디 진행방식

import UIKit
import SnapKit

class EditingStudyFreeRuleViewController: UIViewController {

    // MARK: - Properties
    
    var study: Study?
    
    @IBOutlet weak var freeRuletextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: - Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        freeRuletextView.delegate = self
        
        self.navigationItem.title = "진행방식"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(ruleEditDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        freeRuletextView.text = study?.freeRule
        placeholderLabel.isHidden = study?.freeRule == nil ? false : true
    }
    // MARK: - Configure
    
    // MARK: - Actions
    
    @objc func ruleEditDone() {
        
        guard let study = study else { return }
        guard let studyID = study.id else { return }
        Network.shared.updateStudy(study, id: studyID) { result in
            switch result {
            case .success(let success):
                print(success)
                self.dismiss(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @objc func cancel() {
        
        self.dismiss(animated: true)
    }
    
    // MARK: - Setting Constraints
}

// MARK: - UITextViewDelegate

extension EditingStudyFreeRuleViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        study?.freeRule = textView.text
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
