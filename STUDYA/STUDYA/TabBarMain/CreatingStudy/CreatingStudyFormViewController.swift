//
//  CreatingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/10.
//

import UIKit

final class CreatingStudyFormViewController: UIViewController {
    
    // MARK: - Properties
    
    private var studyViewModel = StudyViewModel()
    private var categoryChoice: StudyCategory? {
        willSet(newCategory) {
            if categoryChoice != nil {
                guard let indexPath = categoryChoice?.indexPath else { fatalError() }
                let cell = studyCategoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.toogleButton()
            }
            studyViewModel.study.category = newCategory?.rawValue
        }
    }

    /// 스크롤 구현
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let titleLabel = CustomLabel(title: "어떤 스터디를\n만들까요", tintColor: .ppsBlack, size: 24, isBold: true)
    /// 스터디 카테고리
    private let studyCategoryLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyCategoryCollectionView: UICollectionView = {
        
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        return cv
    }()
    /// 스터디명
    private let studyNameLabel = CustomLabel(title: "스터디명", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyNameTextView = CharactersNumberLimitedTextView(placeholder: "스터디명을 입력해주세요.", maxCharactersNumber: 10, radius: 21, position: .center, fontSize: 12)
    /// 스터디 형태 on/off
    private let studyTypeLabel = CustomLabel(title: "형태", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyTypeGuideLabel = CustomLabel(title: "중복 선택 가능", tintColor: .ppsGray1, size: 12, isBold: false)
    private let onlineButton = CheckBoxButton(title: "온라인")
    private let offlineButton = CheckBoxButton(title: "오프라인")
    /// 스터디 한줄 소개
    private let studyIntroductionLabel = CustomLabel(title: "한 줄 소개", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyIntroductionTextView = CharactersNumberLimitedTextView(placeholder: "시작 계기, 목적, 목표 등을 적어주세요.\n ※ 줄바꿈은 불가능합니다.", maxCharactersNumber: 50, radius: 24, position: .bottom, fontSize: 12, topInset: 19, leadingInset: 30)
    /// 다음 버튼
    private let bottomStickyView = UIView(backgroundColor: .white)
    private let doneButton: BrandButton = BrandButton(title: "다음", isBold: true, isFill: false)
    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyViewModel.bind { [self] study in
            print(study)
            doneButton.isEnabled = study.formIsFilled
            doneButton.isEnabled ? doneButton.fillIn(title: "다음") : doneButton.fillOut(title: "다음")
        }
        
        configureViews()
        setDelegate()
        enableTapGesture()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        removeNotification()
    }

    // MARK: - Configure Views
    
    private func configureViews() {
        view.backgroundColor = .white
        
        onlineButton.addTarget(self, action: #selector(typeButtonDidTapped), for: .touchUpInside)
        offlineButton.addTarget(self, action: #selector(typeButtonDidTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        addSubviewsWithConstraints()
    }

    // MARK: - Actions
    
    @objc private func typeButtonDidTapped(_ sender: CheckBoxButton) {

        sender.toggleState()
        
        switch sender {
        case onlineButton:
            studyViewModel.study.studyOn = sender.isSelected ? true : false
        case offlineButton:
            studyViewModel.study.studyOff = sender.isSelected ? true : false
        default:
            return
        }
    }
    
    @objc private func categoryDidChanged(_ notification: Notification) {
        
        guard let cellInfo = notification.object as? [String: Any] else { return }
        let title = cellInfo["title"] as! String
        
        let selectedCategory = StudyCategory.allCases.filter { category in
            category.translatedKorean == title
        }.first
        
        categoryChoice = selectedCategory
    }
    
    @objc private func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        scrollView.contentInset = insets

        var viewFrame = self.view.frame

        viewFrame.size.height -= (keyboardSize.height + view.safeAreaInsets.bottom + 130)

        guard let activeTextView = [studyNameTextView, studyIntroductionTextView].first(where: { $0.isFirstResponder }) else { return }

        let scrollPoint = CGPoint(x: 0, y: activeTextView.frame.origin.y - keyboardSize.height + activeTextView.frame.height + 30)

        scrollView.setContentOffset(scrollPoint, animated: true)

        bottomStickyView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardSize.height - view.safeAreaInsets.bottom)
        }
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardDisappear(_ notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
        bottomStickyView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.layoutIfNeeded()

    }
    
    @objc private func pullKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func doneButtonDidTapped() {

        let vc = CreatingStudyRuleViewController()
        
        vc.creatingStudyRuleViewModel.study = studyViewModel.study
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func closeButtonDidTapped() {

        self.dismiss(animated: true)
    }
    
    private func enableTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullKeyboard))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setNavigation() {
        
        navigationItem.title = "스터디 만들기"
        navigationItem.rightBarButtonItem = closeButton
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryDidChanged), name: .categoryDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setDelegate() {
        
        studyNameTextView.delegate = self
        studyIntroductionTextView.delegate = self
        studyCategoryCollectionView.dataSource = self
    }
    
    // MARK: - Add SubViews with Constraints
    
    private func addSubviewsWithConstraints() {
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(containerView)

        containerView.addSubview(titleLabel)
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
        
        view.addSubview(bottomStickyView)
        bottomStickyView.addSubview(doneButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(41)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(17)
        }
        studyCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
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
        bottomStickyView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(bottomStickyView).inset(16)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(bottomStickyView).inset(20)
            make.centerX.equalTo(bottomStickyView)
        }
    }
}

// MARK: - UITextViewDelegate

extension CreatingStudyFormViewController: UITextViewDelegate {
    
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

        if textView.text.isEmpty {
            
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
        
        if text == "\n" {
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        switch textView {
            case studyNameTextView:
            
            let maxLength = 10
            
            limitCharactersNumber(with: studyNameTextView, maxLength: maxLength)
            
            let currentTextCount = textView.text.count
            studyNameTextView.getCharactersNumberLabel().text = "\(currentTextCount)/\(maxLength)"
            studyViewModel.study.studyName = studyNameTextView.text
        case studyIntroductionTextView:
            
            let maxLength = 50
            
            limitCharactersNumber(with: studyNameTextView, maxLength: maxLength)
            
            let currentTextCount = textView.text.count
            studyIntroductionTextView.getCharactersNumberLabel().text = "\(currentTextCount)/\(maxLength)"
            studyViewModel.study.studyIntroduction = studyIntroductionTextView.text
        default:
            break
        }
    }
    
    private func limitCharactersNumber(with textView: UITextView, maxLength: Int) {
        guard let currentText = textView.text else { return }
        guard currentText.count > maxLength else { return }
        
        let selection = textView.selectedTextRange
        let newEnd = textView.position(from: selection!.start, offset: 0)!
        
        textView.text = String(currentText.prefix(maxLength))
        textView.selectedTextRange = textView.textRange(from: newEnd, to: newEnd)
    }
}

// MARK: - UICollectionViewDataSource

extension CreatingStudyFormViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StudyCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else { return CategoryCell() }
        cell.title = StudyCategory.allCases[indexPath.row].translatedKorean
        return cell
    }
}
