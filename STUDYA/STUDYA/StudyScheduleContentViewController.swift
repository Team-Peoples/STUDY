//
//  StudyScheduleContentViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/22/22.
//

import UIKit

class StudyScheduleContentViewController: UIViewController {
    
    let topicTitleLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let topicTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 주제는 무엇인가요?", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    let topicTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    let placeTitleLabel = CustomLabel(title: "장소", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let placeTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 장소를 입력해주세요.", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    let placeTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(topicTitleLabel)
        view.addSubview(topicTextView)
        view.addSubview(topicTextViewCharactersCountLimitLabel)
        view.addSubview(placeTitleLabel)
        view.addSubview(placeTextView)
        view.addSubview(placeTextViewCharactersCountLimitLabel)
        
        topicTextView.delegate = self
        placeTextView.delegate = self
        
        topicTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        topicTextView.snp.makeConstraints { make in
            make.top.equalTo(topicTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(42)
        }
        topicTextViewCharactersCountLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(topicTextView).inset(20)
            make.bottom.equalTo(topicTextView.snp.top).offset(-13)
        }
        placeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topicTextView.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        placeTextView.snp.makeConstraints { make in
            make.top.equalTo(placeTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(42)
        }
        placeTextViewCharactersCountLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(placeTextView).inset(20)
            make.bottom.equalTo(placeTextView.snp.top).offset(-13)
        }
    }
}

extension StudyScheduleContentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        switch textView {
            case topicTextView:
                topicTextView.hidePlaceholder(true)
                
            case placeTextView:
                placeTextView.hidePlaceholder(true)
            default:
                return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            switch textView {
                case topicTextView:
                    topicTextView.hidePlaceholder(false)
                case placeTextView:
                    placeTextView.hidePlaceholder(false)
                default:
                    return
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        switch textView {
            case topicTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                topicTextViewCharactersCountLimitLabel.text = newLength > 20 ? "20/20" : "\(newLength)/20"
                return newLength <= 20
            case placeTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                placeTextViewCharactersCountLimitLabel.text = newLength > 20 ? "20/20" : "\(newLength)/20"
                return newLength <= 20
                
            default:
                return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        ///엔터 입력할때 안되도록...막아야함
        switch textView {
            case topicTextView:
                if topicTextView.text.contains(where: { $0 == "\n" }) {
                    topicTextView.text = topicTextView.text.replacingOccurrences(of: "\n", with: "")
                }
            case placeTextView:
                if placeTextView.text.contains(where: { $0 == "\n" }) {
                    placeTextView.text = placeTextView.text.replacingOccurrences(of: "\n", with: "")
                }
            default:
                break
        }
    }
}
