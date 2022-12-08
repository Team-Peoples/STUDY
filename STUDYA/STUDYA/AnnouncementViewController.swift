//
//  AnnouncementViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/20.
//

import UIKit
import SnapKit

// to be fixed:  textview에서 커서를 옮겼을때 레이아웃이 이상하게 잡혀버리는 현상이 발생.

class AnnouncementViewController: UIViewController {
    // MARK: - Properties
    
    let task: Task
    
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
    var announcement: Announcement? {
        didSet {
            
            titleTextView.text = announcement?.title
            contentTextView.text = announcement?.content
            timeLabel.text = announcement?.createdDate?.formatToString(language: .eng)
        }
    }
    
    private let headerView: UIView = {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Const.screenWidth, height: 48)))
        let titleLabel = CustomLabel(title: "공지사항", tintColor: .ppsBlack, size: 16, isBold: true)
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.leading.equalTo(30)
        }
        
        return headerView
    }()
    
    private let titleTextView: BaseTextView = {
        let tv = BaseTextView(placeholder: "제목을 입력해주세요.", fontSize: 18, isBold: true, topInset: 0, leadingInset: 0)
        
        tv.textColor = UIColor.appColor(.ppsBlack)
        tv.tintColor = .black
        tv.isEditable = false
        tv.isScrollEnabled = true
//        tv.textContainer.maximumNumberOfLines = 1
        tv.enablesReturnKeyAutomatically = true
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    private let contentTextView: BaseTextView = {
        let tv = BaseTextView(placeholder: "내용을 입력해주세요.", fontSize: 16, topInset: 0, leadingInset: 0)
        
        tv.textColor = UIColor.appColor(.ppsGray1)
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
        
        lbl.textColor = UIColor.appColor(.ppsGray1)
        lbl.font = UIFont.systemFont(ofSize: 12)
        
        return lbl
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // MARK: - Initialization
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        checkIfUserIsMaster()
        
        titleTextView.delegate = self
        contentTextView.delegate = self
        
        addNotification()
        enableTapGesture()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !contentTextView.text.isEmpty || !titleTextView.text.isEmpty {
            contentTextView.hidePlaceholder(true)
            titleTextView.hidePlaceholder(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        switch task {
        case .viewing:
            contentView.addSubview(headerView)
        case .creating, .editing:
            break
        }
        
        contentView.addSubview(titleTextView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(timeLabel)
    }
    
    // MARK: - Actions
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        view.endEditing(true)
    }
    
    @objc func doneButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onKeyboardDisappear))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func checkIfUserIsMaster() {
        if isMaster {
            checkIfCreateOrEdit()
        }
    }
    
    private func checkIfCreateOrEdit() {
    
        switch task {
        case .creating:
            navigationItem.title = "공지사항 만들기"
        case .editing:
            navigationItem.title = "공지사항 수정"
        case .viewing:
            navigationItem.title = "스터디 이름"
        }
        
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonDidTapped))
        navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.centerX.width.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.width.top.bottom.equalTo(scrollView)
        }
        
        switch task {
        case .creating:
            titleTextView.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(30)
                make.leading.trailing.equalTo(contentView).inset(30)
            }
        case .editing:
            titleTextView.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(50)
                make.leading.trailing.equalTo(contentView).inset(30)
            }
        case .viewing:
            headerView.snp.makeConstraints({ make in
                make.leading.top.trailing.equalTo(contentView)
                make.height.equalTo(48)
            })
            titleTextView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom).offset(30)
                make.leading.trailing.equalTo(contentView).inset(30)
            }
        }
    
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(25)
            make.bottom.equalTo(contentView.snp.bottom).inset(110)
            make.leading.trailing.equalTo(titleTextView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(30)
            make.bottom.equalTo(titleTextView.snp.top).offset(-8)
        }
    }
}

// MARK: - UITextViewDelegate

extension AnnouncementViewController: UITextViewDelegate {
    
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
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

