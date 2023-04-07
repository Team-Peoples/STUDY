//
//  AnnouncementViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/20.
//

import UIKit
import SnapKit

// domb: textview에서 커서를 옮겼을때 레이아웃이 이상하게 잡혀버리는 현상이 발생.

final class AnnouncementViewController: UIViewController {
    // MARK: - Properties
    
    enum Task {
        case creating
        case editing
        case viewing
    }
    
    let task: Task
    let studyID: ID
    let studyName: String?
    
    var isMaster = false {
        didSet {
            if isMaster == true {
                titleTextView.isEditable = true
                contentTextView.isEditable = true
            } else {
                titleTextView.isEditable = false
                contentTextView.isEditable = false
            }
        }
    }
    var announcement: Announcement? {
        didSet {
            titleTextView.text = announcement?.title
            contentTextView.text = announcement?.content
            
            if let createdDate = announcement?.createdDate {
                timeLabel.text = DateFormatter.dottedDateFormatter.string(from: createdDate)
            }
        }
    }
    
    private let headerView: UIView = {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constant.screenWidth, height: 48)))
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
        tv.isScrollEnabled = false
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
    
    lazy var createButton = UIBarButtonItem(title: Constant.OK, style: .done, target: self, action: #selector(createButtonDidTapped))
    lazy var editButton = UIBarButtonItem(title: Constant.edit, style: .done, target: self, action: #selector(editButtonDidTapped))
    lazy var cancelButton = UIBarButtonItem(title: Constant.cancel, style: .done, target: self, action: #selector(cancel))
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // MARK: - Initialization
    
    init(task: Task, studyID: ID, studyName: String? = nil) {
        self.task = task
        self.studyID = studyID
        self.studyName = studyName
        
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
        
        createButton.isEnabled = false
        editButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !contentTextView.text.isEmpty || !titleTextView.text.isEmpty {
            contentTextView.hidePlaceholder(true)
            titleTextView.hidePlaceholder(true)
        }
        
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        removeNotification()
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        titleTextView.delegate = self
        contentTextView.delegate = self
        
        navigationController?.setBrandNavigation()
        enableTapGesture()
        
        addSubviewsWithConstraints()
    }
    
    // MARK: - Actions
    
    @objc func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
    }
    
    @objc func keyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        view.endEditing(true)
    }
    
    @objc func createButtonDidTapped() {
        
        guard let title = titleTextView.text else { return }
        guard let content = contentTextView.text else { return }
        
        Network.shared.createAnnouncement(title: title, content: content, studyID: studyID) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .updateAnnouncement, object: nil)
                self.dismiss(animated: true)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    @objc func editButtonDidTapped() {
        
        guard let title = titleTextView.text else { return }
        guard let content = contentTextView.text else { return }
        guard let announcementID = announcement?.id else { return }
        
        Network.shared.updateAnnouncement(title: title, content: content, announcementID: announcementID) { result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: .updateAnnouncement, object: nil)
                self.dismiss(animated: true)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    @objc func cancel() {
        let simpleAlert = SimpleAlert(title: "작성을 중단할까요?", message: "페이지를 나가면 작성하던 내용이 사라져요.", firstActionTitle: "나가기", actionStyle: .destructive, firstActionHandler: { _ in
            self.dismiss(animated: true)
        }, cancelActionTitle: "남아있기")
        
        present(simpleAlert, animated: true)
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDisappear))
        
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
            navigationItem.rightBarButtonItem = createButton
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        case .editing:
            navigationItem.title = "공지사항 수정"
            navigationItem.rightBarButtonItem = editButton
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        case .viewing:
            navigationItem.title = studyName
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        navigationController?.navigationBar.tintColor = .appColor(.cancel)
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addSubviewsWithConstraints() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(timeLabel)
        
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
            contentView.addSubview(headerView)
            
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView {
            if text == "\n" {
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == titleTextView {
            let maxLength = 40
            textView.limitCharactersNumber(maxLength: maxLength)
        }
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        let titleTextViewIsEmpty = titleTextView.text == nil || titleTextView.text == String()
        let contentTextViewIsEmpty = contentTextView.text == nil || contentTextView.text == String()
        
        if !titleTextViewIsEmpty && !contentTextViewIsEmpty {
            createButton.isEnabled = true
            editButton.isEnabled = true
        } else {
            createButton.isEnabled = false
            editButton.isEnabled = false
        }
    }
}

