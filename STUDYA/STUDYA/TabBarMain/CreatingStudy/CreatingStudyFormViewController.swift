//
//  CreatingStudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/10.
//

import UIKit
import SnapKit

final class CreatingStudyFormViewController: UIViewController {
    
    // MARK: - Properties
    
    var studyViewModel = StudyViewModel()
    
    var categoryChoice: StudyCategory? {
        willSet(newCategory) {
            if categoryChoice == nil {
                
            } else {
                guard let indexPath = categoryChoice?.indexPath else { fatalError() }
                let cell = studyCategoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.toogleButton()
            }
            studyViewModel.study.category = newCategory?.rawValue
        }
    }
    private var token: NSObjectProtocol?
    
    private let titleLabel = CustomLabel(title: "어떤 스터디를\n만들까요", tintColor: .ppsBlack, size: 24, isBold: true)

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
    
    /// 다음 버튼
    private let bottomStickyView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        return v
    }()
    private let doneButton = BrandButton(title: "다음", isBold: true, isFill: false)

    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyViewModel.bind { [self] study in
            doneButton.isEnabled = study.formIsFilled
            doneButton.isEnabled ? doneButton.fillIn(title: "다음") : doneButton.fillOut(title: "다음")
        }
        
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
        tabBarController?.tabBar.isHidden = true
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
        
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        doneButton.isEnabled = false
    }

    // MARK: - Actions
    
    @objc func typeButtonDidTapped(_ sender: CheckBoxButton) {
        
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
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
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
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        
        bottomStickyView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.layoutIfNeeded()
        
        self.view.endEditing(true)
    }
    
    @objc func doneButtonDidTapped() {

        let vc = CreatingStudyRuleViewController()
        
        vc.creatingStudyRuleViewModel.study = studyViewModel.study
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func closeButtonDidTapped() {

        self.dismiss(animated: true)
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onKeyboardDisappear))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setNavigation() {
        
        self.navigationItem.title = "스터디 만들기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.rightBarButtonItem = closeButton
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
    
    // MARK: - Helpers
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
        ///domb: 엔터 입력할때 안되도록...막아야함
        switch textView {
            case studyNameTextView:
                if textView.text.contains(where: { $0 == "\n" }) {
                    textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                }
                studyViewModel.study.studyName = studyNameTextView.text
            case studyIntroductionTextView:
                if textView.text.contains(where: { $0 == "\n" }) {
                    textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                }
                studyViewModel.study.studyIntroduction = studyIntroductionTextView.text
            default:
                break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CreatingStudyFormViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StudyCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.title = StudyCategory.allCases[indexPath.row].rawValueWithKorean
        return cell
    }
}
