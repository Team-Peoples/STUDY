//
//  CreatingStudyViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/10.
//

//🛑한줄소개 최대숫자가 50이었다가 100이었다가 달라짐
import UIKit
import SnapKit

enum StudyCategory: String, CaseIterable {
    case language = "어학"
    case dev_prod_design = "개발/기획/디자인"
    case project = "프로젝트"
    case getJob = "취업"
    case certificate = "자격시험/자격증"
    case pastime = "자기계발/취미"
    case etc = "그 외"
}


final class CreatingStudyViewController: UIViewController {
    // MARK: - Properties
    
    var studyViewModel = StudyViewModel()
    private var token: NSObjectProtocol?
    
    var categoryChoice: (String, IndexPath)? {
        willSet(value) {
            if categoryChoice == nil {
                
            } else {
                guard let indexPath = categoryChoice?.1 else { fatalError() }
                let cell = studyCategoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.toogleButton()
            }
            studyViewModel.study.category = value?.0
            buttonStateUpdate()
        }
    }
    
    /// 스크롤 구현
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    /// 화면 타이틀
    private let titleLabel = CustomLabel(title: "어떤 스터디를\n만들까요", tintColor: .ppsBlack, size: 24, isBold: true)
    
    /// 스터디 카테고리
    private let studyCategoryLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private lazy var studyCategoryCollectionView: UICollectionView = getCollectionView()
    
    /// 스터디명
    private let studyNameLabel = CustomLabel(title: "스터디명", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyNameTextView = CharactersNumberLimitedTextView(placeholder: "스터디명을 입력해주세요.", maxCharactersNumber: 10, radius: 21, position: .center, fontSize: 8)
    
    /// 스터디 형태 on/off
    private let studyTypeLabel = CustomLabel(title: "형태", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyTypeGuideLabel = CustomLabel(title: "중복 선택 가능", tintColor: .ppsGray1, size: 12, isBold: false)
    private lazy var studyTypeStackView: UIStackView = getCheckBoxStackView()
    
    /// 스터디 한줄 소개
    private let studyIntroductionLabel = CustomLabel(title: "한 줄 소개", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyIntroductionTextView = CharactersNumberLimitedTextView(placeholder: "시작 계기, 목적, 목표 등을 적어주세요.", maxCharactersNumber: 50, radius: 24, position: .bottom, fontSize: 12, topInset: 19, leadingInset: 30)
    
    /// 다음 버튼
    private let nextButton = CustomButton(title: "다음", isBold: true, isFill: false)

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setDelegate()
        enableTapGesture()
        studyNameTextView.textContainer.maximumNumberOfLines = 1
        
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
        nextButton.isEnabled = false
        
        setConstraints()
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
        containerView.addSubview(studyTypeStackView)
        containerView.addSubview(studyIntroductionLabel)
        containerView.addSubview(studyIntroductionTextView)
        containerView.addSubview(nextButton)
    }
    
    // MARK: - Actions
    
    @objc func buttonDidTapped(sender: CheckBoxButton) {
        
        if studyViewModel.study.onoff == nil {
            studyViewModel.study.onoff = sender.titleLabel?.text == OnOff.on.kor ? OnOff.on.eng : OnOff.off.eng
        } else if studyViewModel.study.onoff == OnOff.on.eng, sender.titleLabel?.text == OnOff.off.kor {
            studyViewModel.study.onoff = OnOff.onoff.eng
        } else if studyViewModel.study.onoff == OnOff.on.eng, sender.titleLabel?.text == OnOff.on.kor {
            studyViewModel.study.onoff = nil
        } else if studyViewModel.study.onoff == OnOff.off.eng, sender.titleLabel?.text == OnOff.on.kor {
        studyViewModel.study.onoff = OnOff.onoff.eng
        } else if studyViewModel.study.onoff == OnOff.off.eng, sender.titleLabel?.text == OnOff.off.kor {
            studyViewModel.study.onoff = nil
        } else if studyViewModel.study.onoff == OnOff.onoff.eng {
            studyViewModel.study.onoff = sender.titleLabel?.text == OnOff.on.kor ? OnOff.off.eng : OnOff.on.eng
        }
        
        sender.toggleState()
        buttonStateUpdate()
        
    }
    
    @objc func nextButtonDidTapped() {
        
        let vc = CreatingStudyRuleViewController()
        
        vc.studyRuleViewModel.study = studyViewModel.study
        navigationController?.pushViewController(vc, animated: true)
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

                let scrollPoint = CGPoint(x: 0, y: activeTextView.frame.origin.y - keyboardSize.height)
                
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
    
    // MARK: - Setting Constraints
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(view)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(41)
            make.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(17)
        }
        studyCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }
        studyCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyCategoryLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(110)
        }
        studyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(studyCategoryCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(studyCategoryCollectionView)
        }
        studyNameTextView.snp.makeConstraints { make in
            make.top.equalTo(studyNameLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(studyCategoryCollectionView)
            make.height.equalTo(42).priority(.low)
        }
        studyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(studyNameTextView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }
        studyTypeGuideLabel.snp.makeConstraints { make in
            make.leading.equalTo(studyTypeLabel.snp.trailing).offset(7)
            make.bottom.equalTo(studyTypeLabel.snp.bottom)
        }
        studyTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(studyTypeLabel.snp.bottom).offset(17)
            make.leading.equalTo(studyCategoryCollectionView)
            make.height.equalTo(46)
        }
        studyIntroductionLabel.snp.makeConstraints { make in
            make.top.equalTo(studyTypeStackView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(titleLabel)
        }
        studyIntroductionTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(105)
            make.top.equalTo(studyIntroductionLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(studyCategoryCollectionView)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(320)
            make.centerX.equalTo(containerView)
            make.top.greaterThanOrEqualTo(studyIntroductionTextView.snp.bottom).offset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(40)
        }
    }
    // MARK: - Helpers
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        token = NotificationCenter.default.addObserver(forName: .categoryDidChange, object: nil, queue: .main) { [self] noti in
            guard let cellInfo = noti.object as? [String: Any] else { return }
            let title = cellInfo["title"] as! String
            let indexPath = cellInfo["indexPath"] as! IndexPath

            categoryChoice = (title, indexPath)
        }
    }
    
    private func getCheckBoxStackView() -> UIStackView {
        
        let onlineButton = CheckBoxButton(title: "온라인", selected: "on", unselected: "off")
        let offlineButton = CheckBoxButton(title: "오프라인", selected: "on", unselected: "off")
        
        onlineButton.addTarget(nil, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        offlineButton.addTarget(nil, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        
        let sv = UIStackView(arrangedSubviews: [onlineButton, offlineButton])
        
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 6
        sv.distribution = .fillEqually
        
        return sv
    }

    private func getCollectionView() -> UICollectionView {
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        return cv
    }
    
    private func setDelegate() {
        studyNameTextView.delegate = self
        studyIntroductionTextView.delegate = self
        studyCategoryCollectionView.dataSource = self
    }
    
    private func buttonStateUpdate() {
        nextButton.isEnabled = studyViewModel.formIsValid
        nextButton.isEnabled ? nextButton.fillIn(title: "완료") : nextButton.fillOut(title: "완료")
    }
}

// MARK: - UITextViewDelegate

extension CreatingStudyViewController: UITextViewDelegate {
    
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
                studyIntroductionTextView.getCharactersNumerLabel().text = newLength > 100 ? "100/100" : "\(newLength)/100"
                return newLength <= 100
                
            default:
                return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == studyNameTextView {
            textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
        }
        
        switch textView {
            case studyNameTextView:
                studyViewModel.study.title = studyNameTextView.text
            case studyIntroductionTextView:
                studyViewModel.study.studyDescription = studyIntroductionTextView.text
            default:
                break
        }
        
        buttonStateUpdate()
    }
}

// MARK: - UICollectionViewDataSource

extension CreatingStudyViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StudyCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CategoryCell
        cell.title = StudyCategory.allCases[indexPath.row].rawValue
        cell.indexPath = indexPath
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
