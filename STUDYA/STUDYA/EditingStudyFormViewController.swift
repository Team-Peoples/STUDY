//
//  EditingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/10/22.
//

import UIKit

final class EditingStudyFormViewController: UIViewController {
    
    // MARK: - Properties
    
    var studyViewModel: StudyViewModel? {
        didSet {
            guard let study = studyViewModel?.study else { return }
            bind(study)
        }
    }
   
    var categoryChoice: StudyCategory? {
        willSet(value) {
            if categoryChoice == nil {
                
            } else {
                guard let indexPath = categoryChoice?.indexPath else { fatalError() }
                let cell = studyCategoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.toogleButton()
            }
            studyViewModel?.study.category = value?.rawValue
        }
    }
    private var token: NSObjectProtocol?
    
    /// 스크롤 구현
    private let scrollView = UIScrollView()
    let containerView = UIView()
    
    /// 스터디 카테고리
    let studyCategoryLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let studyCategoryCollectionView: UICollectionView = {

        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        return cv
    }()
    
    /// 스터디명
    private let studyNameLabel = CustomLabel(title: "스터디명", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let studyNameTextView = CharactersNumberLimitedTextView(placeholder: "스터디명을 입력해주세요.", maxCharactersNumber: 10, radius: 21, position: .center, fontSize: 12)
    
    /// 스터디 형태 on/off
    private let studyTypeLabel = CustomLabel(title: "형태", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyTypeGuideLabel = CustomLabel(title: "중복 선택 가능", tintColor: .ppsGray1, size: 12, isBold: false)
    let onlineButton = CheckBoxButton(title: "온라인")
    let offlineButton = CheckBoxButton(title: "오프라인")
    
    /// 스터디 한줄 소개
    private let studyIntroductionLabel = CustomLabel(title: "한 줄 소개", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let studyIntroductionTextView = CharactersNumberLimitedTextView(placeholder: "시작 계기, 목적, 목표 등을 적어주세요.", maxCharactersNumber: 50, radius: 24, position: .bottom, fontSize: 12, topInset: 19, leadingInset: 30)
    private lazy var doneButton = UIBarButtonItem(title: Const.OK, style: .plain, target: self, action: #selector(barButtonDidTapped))
    private lazy var cancelButton = UIBarButtonItem(title: Const.cancel, style: .plain, target: self, action: #selector(barButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 스터디 불러와서 스터디 뷰모델을 생성해줌.
        
        configureViews()
        setDelegate()
        enableTapGesture()
        onlineButton.addTarget(self, action: #selector(typeButtonDidTapped), for: .touchUpInside)
        offlineButton.addTarget(self, action: #selector(typeButtonDidTapped), for: .touchUpInside)
        setConstraints()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        NotificationCenter.default.removeObserver(self)
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    // MARK: - Configure
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(containerView)

        containerView.addSubview(studyCategoryLabel)
        containerView.addSubview(studyCategoryCollectionView)
        containerView.addSubview(studyNameLabel)
        containerView.addSubview(studyNameTextView)
        containerView.addSubview(studyTypeLabel)
        containerView.addSubview(studyTypeGuideLabel)
        containerView.addSubview(onlineButton)
        containerView.addSubview(offlineButton)
        containerView.addSubview(studyIntroductionLabel)
        containerView.addSubview(studyIntroductionTextView)
    }
    
    func bind(_ study: Study) {
        
        studyNameTextView.text = study.studyName
        studyIntroductionTextView.text = study.studyIntroduction
        
        onlineButton.isSelected = study.studyOn ? true : false
        offlineButton.isSelected = study.studyOff ? true : false
        
        if studyNameTextView.text != "" {
            studyNameTextView.hidePlaceholder(true)
            studyNameTextView.getCharactersNumerLabel().text = "\(study.studyName!.count)/10"
        }
        
        if studyIntroductionTextView.text != "" {
            studyIntroductionTextView.hidePlaceholder(true)
            studyIntroductionTextView.getCharactersNumerLabel().text = "\(study.studyIntroduction!.count)/10"
        }
    }
    
    // MARK: - Actions
    
    @objc func typeButtonDidTapped(_ sender: CheckBoxButton) {
        
        sender.toggleState()
        
        switch sender {
        case onlineButton:
            studyViewModel?.study.studyOn = sender.isSelected ? true : false
        case offlineButton:
            studyViewModel?.study.studyOff = sender.isSelected ? true : false
        default:
            return
        }
    }
    
    @objc func barButtonDidTapped(sender: UIBarButtonItem) {
        
        switch sender {
            case doneButton:
                print("수정 완료")
                self.dismiss(animated: true)
            case  cancelButton:
                print("수정 취소")
                self.dismiss(animated: true)
            default:
                return
        }
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollView.contentInset = insets
        
        var viewFrame = self.view.frame
        
        viewFrame.size.height -= keyboardSize.height
        
        let activeTextView: UITextView? = [studyNameTextView, studyIntroductionTextView].first { $0.isFirstResponder }
        
        if let activeTextView = activeTextView {
            
            if !viewFrame.contains(activeTextView.frame.origin) {
                print(activeTextView.frame.origin)
                
                let scrollPoint = CGPoint(x: 0, y: activeTextView.frame.origin.y - keyboardSize.height + activeTextView.frame.height)
                
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        self.view.endEditing(true)
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onKeyboardDisappear))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setNavigation() {
        
        self.navigationItem.title = "스터디 정보관리"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.height)
        }
        studyCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(containerView.snp.leading).inset(26)
        }
        studyCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyCategoryLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.height.equalTo(110)
        }
        studyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(studyCategoryCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(studyCategoryLabel)
        }
        studyNameTextView.snp.makeConstraints { make in
            make.top.equalTo(studyNameLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(studyCategoryCollectionView)
            make.height.equalTo(42).priority(.low)
        }
        studyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(studyNameTextView.snp.bottom).offset(40)
            make.leading.equalTo(studyCategoryLabel)
        }
        studyTypeGuideLabel.snp.makeConstraints { make in
            make.leading.equalTo(studyTypeLabel.snp.trailing).offset(7)
            make.bottom.equalTo(studyTypeLabel.snp.bottom)
        }
        onlineButton.snp.makeConstraints { make in
            make.top.equalTo(studyTypeLabel.snp.bottom).offset(17)
            make.leading.equalTo(studyTypeLabel)
        }
        offlineButton.snp.makeConstraints { make in
            make.top.equalTo(onlineButton.snp.bottom).offset(4)
            make.leading.equalTo(studyTypeLabel)
        }
        studyIntroductionLabel.snp.makeConstraints { make in
            make.top.equalTo(offlineButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(studyCategoryLabel)
        }
        studyIntroductionTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(105)
            make.top.equalTo(studyIntroductionLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(containerView).inset(30)
            make.bottom.equalTo(containerView).inset(140)
        }
    }
    
    // MARK: - Helpers
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        token = NotificationCenter.default.addObserver(forName: .categoryDidChange, object: nil, queue: .main) { [self] noti in
            guard let cellInfo = noti.object as? [String: Any] else { return }
            let title = cellInfo["title"] as! String
            let selectedCategory = StudyCategory.allCases.filter { category in
                category.rawValueWithKorean == title
            }.first
            
            categoryChoice = selectedCategory
        }
    }
    
    private func setDelegate() {
        
        studyNameTextView.delegate = self
        studyIntroductionTextView.delegate = self
        studyCategoryCollectionView.dataSource = self
    }
}

// MARK: - UITextViewDelegate

extension EditingStudyFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        switch textView {
            case studyNameTextView:
                studyNameTextView.hidePlaceholder(true)
                
            case studyIntroductionTextView:
                studyIntroductionTextView.hidePlaceholder(true)
            default:
                return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            switch textView {
                case studyNameTextView:
                    studyNameTextView.hidePlaceholder(false)
                case studyIntroductionTextView:
                    studyIntroductionTextView.hidePlaceholder(false)
                default:
                    return
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        switch textView {
            case studyNameTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                studyNameTextView.getCharactersNumerLabel().text = newLength > 10 ? "10/10" : "\(newLength)/10"
                return newLength <= 10
            case studyIntroductionTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                studyIntroductionTextView.getCharactersNumerLabel().text = newLength > 50 ? "50/50" : "\(newLength)/50"
                return newLength <= 50
                
            default:
                return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        ///엔터 입력할때 안되도록...막아야함
        switch textView {
            case studyNameTextView:
                if textView.text.contains(where: { $0 == "\n" }) {
                    textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                }
                studyViewModel?.study.studyName = studyNameTextView.text
            case studyIntroductionTextView:
                if textView.text.contains(where: { $0 == "\n" }) {
                    textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                }
                studyViewModel?.study.studyIntroduction = studyIntroductionTextView.text
            default:
                break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EditingStudyFormViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StudyCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.title = StudyCategory.allCases[indexPath.row].rawValueWithKorean
    
        if let rawValue = studyViewModel?.study.category, let category = StudyCategory(rawValue: rawValue)?.rawValueWithKorean, category == cell.title {
            cell.isSameTitle = true
        }
        
        return cell
    }
}
