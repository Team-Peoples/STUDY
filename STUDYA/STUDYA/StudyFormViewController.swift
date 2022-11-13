//
//  StudyFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/11/22.
//

import UIKit

enum StudyCategory: String, CaseIterable {
    case language = "어학"
    case dev_prod_design = "개발/기획/디자인"
    case project = "프로젝트"
    case getJob = "취업"
    case certificate = "자격시험/자격증"
    case pastime = "자기계발/취미"
    case etc = "그 외"
}

class StudyFormViewController: UIViewController {
    // MARK: - Properties
    
    var studyViewModel: StudyViewModel?
    private var token: NSObjectProtocol?
    
    private var categoryChoice: (String, IndexPath)? {
        willSet(value) {
            if categoryChoice == nil {
                
            } else {
                guard let indexPath = categoryChoice?.1 else { fatalError() }
                let cell = studyCategoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.toogleButton()
            }
            studyViewModel?.study.category = value?.0
        }
    }
    
    /// 스크롤 구현
    private let scrollView = UIScrollView()
    let containerView = UIView()
    
    /// 스터디 카테고리
    let studyCategoryLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private lazy var studyCategoryCollectionView: UICollectionView = getCollectionView()
    
    /// 스터디명
    private let studyNameLabel = CustomLabel(title: "스터디명", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let studyNameTextView = CharactersNumberLimitedTextView(placeholder: "스터디명을 입력해주세요.", maxCharactersNumber: 10, radius: 21, position: .center, fontSize: 12)
    
    /// 스터디 형태 on/off
    private let studyTypeLabel = CustomLabel(title: "형태", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let studyTypeGuideLabel = CustomLabel(title: "중복 선택 가능", tintColor: .ppsGray1, size: 12, isBold: false)
    private lazy var studyTypeStackView: UIStackView = getCheckBoxStackView()
    
    /// 스터디 한줄 소개
    private let studyIntroductionLabel = CustomLabel(title: "한 줄 소개", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let studyIntroductionTextView = CharactersNumberLimitedTextView(placeholder: "시작 계기, 목적, 목표 등을 적어주세요.", maxCharactersNumber: 50, radius: 24, position: .bottom, fontSize: 12, topInset: 19, leadingInset: 30)
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setDelegate()
        enableTapGesture()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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

        containerView.addSubview(studyCategoryLabel)
        containerView.addSubview(studyCategoryCollectionView)
        containerView.addSubview(studyNameLabel)
        containerView.addSubview(studyNameTextView)
        containerView.addSubview(studyTypeLabel)
        containerView.addSubview(studyTypeGuideLabel)
        containerView.addSubview(studyTypeStackView)
        containerView.addSubview(studyIntroductionLabel)
        containerView.addSubview(studyIntroductionTextView)
    }
    
    // MARK: - Actions
    
    @objc func buttonDidTapped(sender: CheckBoxButton) {
        
        if studyViewModel?.study.onoff == nil {
            studyViewModel?.study.onoff = sender.titleLabel?.text == OnOff.on.kor ? OnOff.on.eng : OnOff.off.eng
        } else if studyViewModel?.study.onoff == OnOff.on.eng, sender.titleLabel?.text == OnOff.off.kor {
            studyViewModel?.study.onoff = OnOff.onoff.eng
        } else if studyViewModel?.study.onoff == OnOff.on.eng, sender.titleLabel?.text == OnOff.on.kor {
            studyViewModel?.study.onoff = nil
        } else if studyViewModel?.study.onoff == OnOff.off.eng, sender.titleLabel?.text == OnOff.on.kor {
            studyViewModel?.study.onoff = OnOff.onoff.eng
        } else if studyViewModel?.study.onoff == OnOff.off.eng, sender.titleLabel?.text == OnOff.off.kor {
            studyViewModel?.study.onoff = nil
        } else if studyViewModel?.study.onoff == OnOff.onoff.eng {
            studyViewModel?.study.onoff = sender.titleLabel?.text == OnOff.on.kor ? OnOff.off.eng : OnOff.on.eng
        }
        
        sender.toggleState()
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
        studyTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(studyTypeLabel.snp.bottom).offset(17)
            make.leading.equalTo(studyTypeLabel)
            make.height.equalTo(46)
        }
        studyIntroductionLabel.snp.makeConstraints { make in
            make.top.equalTo(studyTypeStackView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(studyCategoryLabel)
        }
        studyIntroductionTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(105)
            make.top.equalTo(studyIntroductionLabel.snp.bottom).offset(17)
            make.leading.trailing.equalTo(containerView).inset(30)
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
}

// MARK: - UITextViewDelegate

extension StudyFormViewController: UITextViewDelegate {
    
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
                studyViewModel?.study.title = studyNameTextView.text
            case studyIntroductionTextView:
                if textView.text.contains(where: { $0 == "\n" }) {
                    textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                }
                studyViewModel?.study.studyDescription = studyIntroductionTextView.text
            default:
                break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension StudyFormViewController: UICollectionViewDataSource {
    
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

