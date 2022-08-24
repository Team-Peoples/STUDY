//
//  NoticeViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/20.
//

import UIKit
import SwiftUI

class NoticeViewController: UIViewController {
    // MARK: - Properties
    
    var isMaster = false {
        didSet {
            if isMaster == true {
                titleTextField.isUserInteractionEnabled = true
                contentTextView.isEditable = true
            } else {
                titleTextField.isUserInteractionEnabled = false
                contentTextView.isEditable = false
            }
        }
    }
    
    var notice: Notice? {
        didSet {
            titleTextField.text = notice?.title
            contentTextView.text = notice?.content
            timeLabel.text = notice?.date
        }
    }
    
    private lazy var editButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        return btn
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 18)
        tf.isUserInteractionEnabled = false
        tf.placeholder = "제목을 입력해주세요."
        tf.tintColor = UIColor.appColor(.titleGeneral)
        return tf
    }()
    
    private let contentTextView: BaseTextView = {
        let tv = BaseTextView(placeholder: "내용을 입력해주세요.", fontSize: 14, height: 100)
        tv.textColor = UIColor.appColor(.subTitleGeneral)
        tv.tintColor = .black
        tv.isEditable = false
        tv.dataDetectorTypes = .link
        tv.isScrollEnabled = false
        tv.enablesReturnKeyAutomatically = true
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        return tv
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.appColor(.subTitleGeneral)
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        titleTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        view.addSubview(titleTextField)
        view.addSubview(timeLabel)
        view.addSubview(contentTextView)
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if contentTextView.text != "" {
            contentTextView.hidePlaceholder(true)
        }
    }

    // MARK: - Configure
    // MARK: - Actions
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(9)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
}

extension NoticeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.hidePlaceholder(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            contentTextView.hidePlaceholder(false)
        }
    }
}

extension NoticeViewController: UITextFieldDelegate {
    
}
