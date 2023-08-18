//
//  StudyScheduleContentViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/22/22.
//

import UIKit

final class CreatingStudyScheduleContentViewController: UIViewController {
    
    // MARK: - Properties
    
    var studySchedulePostingViewModel = StudySchedulePostingViewModel()
    
    private let topicTitleLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let topicTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 주제는 무엇인가요?", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    private let topicTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    private let placeTitleLabel = CustomLabel(title: "장소", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let placeTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 장소를 입력해주세요.", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    private let placeTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    private let bottomStickyView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        return v
    }()
    private let creatingScheduleButton = BrandButton(title: "일정만들기", isBold: true, isFill: false)
    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close")?.withTintColor(.white), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studySchedulePostingViewModel.bind { [self] studySchedule in
            creatingScheduleButton.isEnabled = studySchedule.contentFormIsFilled
            creatingScheduleButton.isEnabled ? creatingScheduleButton.fillIn(title: "일정 만들기") : creatingScheduleButton.fillOut(title: "일정 만들기")
        }
        
        configureViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func creatingScheduleButtonDidTapped() {
        
        studySchedulePostingViewModel.postStudySchedule() { [weak self] in
            NotificationCenter.default.post(name: .updateStudySchedule, object: nil)
            let studyID = self?.studySchedulePostingViewModel.studySchedule.studyID
            NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil, userInfo: [Constant.studyID: studyID])
        }
        self.dismiss(animated: true)
    }
    
    @objc private func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        
        bottomStickyView.snp.updateConstraints { make in
            make.bottom.equalTo(view).inset(keyboardSize.height - 30)
        }
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardDisappear(_ notification: NSNotification) {
        bottomStickyView.snp.updateConstraints { make in
            make.bottom.equalTo(view)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        creatingScheduleButton.addTarget(self, action: #selector(creatingScheduleButtonDidTapped), for: .touchUpInside)
        
        topicTextView.delegate = self
        placeTextView.delegate = self
        
        topicTextView.text = studySchedulePostingViewModel.studySchedule.topic
        placeTextView.text = studySchedulePostingViewModel.studySchedule.place
        
        addNotification()
        setNavigation()
        
        addSubviewsWithConstraints()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setNavigation() {

        navigationController?.setupNavigationBarBackButtonDisplayMode()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        
        navigationItem.title = "일정 만들기"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func addSubviewsWithConstraints() {
        
        view.addSubview(topicTitleLabel)
        view.addSubview(topicTextView)
        view.addSubview(topicTextViewCharactersCountLimitLabel)
        view.addSubview(placeTitleLabel)
        view.addSubview(placeTextView)
        view.addSubview(placeTextViewCharactersCountLimitLabel)
        view.addSubview(bottomStickyView)
        
        bottomStickyView.addSubview(creatingScheduleButton)
        
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
        bottomStickyView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(100 + 30)
        }
        creatingScheduleButton.snp.makeConstraints { make in
            make.top.equalTo(bottomStickyView).inset(16)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(bottomStickyView).inset(20)
            make.centerX.equalTo(bottomStickyView)
        }
    }
}

// MARK: - UITextViewDelegate

extension CreatingStudyScheduleContentViewController: UITextViewDelegate {
    
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
        
        if text == "\n" {
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        switch textView {
            case topicTextView:
            
            let maxLength = 20
            
            topicTextView.limitCharactersNumber(maxLength: maxLength)
            
            let currentTextCount = textView.text.count
            topicTextViewCharactersCountLimitLabel.text = "\(currentTextCount)/\(maxLength)"
            studySchedulePostingViewModel.studySchedule.topic = topicTextView.text
        case placeTextView:
            
            let maxLength = 20
            
            placeTextView.limitCharactersNumber(maxLength: maxLength)
            
            let currentTextCount = textView.text.count
            placeTextViewCharactersCountLimitLabel.text = "\(currentTextCount)/\(maxLength)"
            studySchedulePostingViewModel.studySchedule.place = placeTextView.text
        default:
            break
        }
    }
}
