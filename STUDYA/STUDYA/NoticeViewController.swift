//
//  NoticeViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/20.
//

import UIKit

class NoticeViewController: UIViewController {
    // MARK: - Properties
    
    ///사용자가 스터디장인지 확인( user의 정보안에 들어잇는걸로 확인가능)
    var isMaster = false {
        didSet {
            if isMaster == true {
                titleTextView.isUserInteractionEnabled = true
                titleTextView.isEditable = true
                
                contentTextView.isUserInteractionEnabled = true
                contentTextView.isEditable = true
            } else {
                titleTextView.isUserInteractionEnabled = false
                titleTextView.isEditable = false
                
                contentTextView.isUserInteractionEnabled = false
                contentTextView.isEditable = false
            }
        }
    }
    
    var notice: Notice? {
        didSet {
            titleTextView.text = notice?.title
            contentTextView.text = notice?.content
            timeLabel.text = notice?.date
        }
    }
    
    private let titleTextView: BaseTextView = {
        let tv = BaseTextView(placeholder: "제목을 입력해주세요.", fontSize: 18, isBold: true, topInset: 0, leadingInset: 0)
        tv.textColor = UIColor.appColor(.titleGeneral)
        tv.tintColor = .black
        tv.isEditable = false

        tv.isScrollEnabled = false
        tv.enablesReturnKeyAutomatically = true
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    private let contentTextView: BaseTextView = {
        let tv = BaseTextView(placeholder: "내용을 입력해주세요.", fontSize: 14, topInset: 0, leadingInset: 0)
        tv.textColor = UIColor.appColor(.subTitleGeneral)
        tv.tintColor = .black
        tv.isEditable = false
        
        tv.dataDetectorTypes = .link
        tv.enablesReturnKeyAutomatically = true
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        return tv
    }()
    
    // 공지 만들기에서는 보이지않음.
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
        
        titleTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleTextView.delegate = self
        contentTextView.delegate = self
        
        checkIfUserIsMaster()
        
        view.addSubview(titleTextView)
        view.addSubview(timeLabel)
        view.addSubview(contentTextView)
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !contentTextView.text.isEmpty || !titleTextView.text.isEmpty {
            contentTextView.hidePlaceholder(true)
            titleTextView.hidePlaceholder(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }

    // MARK: - Configure
    // MARK: - Actions
    
    @objc func createNotice() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkIfUserIsMaster() {
        if isMaster {
            checkIfCreateOrEdit()
        }
    }
    
    private func checkIfCreateOrEdit() {
        
        if titleTextView.text.isEmpty && contentTextView.text.isEmpty {
            self.navigationItem.title = "공지사항 만들기"
        } else {
            self.navigationItem.title = "공지사항 수정"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(createNotice))
        self.navigationItem.rightBarButtonItem?.tintColor = .orange
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = .orange
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(9)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
}

extension NoticeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
            case titleTextView:
                titleTextView.hidePlaceholder(true)
            case contentTextView:
                contentTextView.hidePlaceholder(true)
            default:
                return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
            case titleTextView:
                titleTextView.text.isEmpty ? titleTextView.hidePlaceholder(false) : nil
            case contentTextView:
                contentTextView.text.isEmpty ? contentTextView.hidePlaceholder(false) : nil
            default:
                return
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
