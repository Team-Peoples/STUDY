//
//  EditingStudySchduleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/8/22.
//

import UIKit

final class EditingStudySchduleViewController: UIViewController {
    
    // MARK: - Properties
    
    let editingStudyScheduleViewModel = StudyScheduleViewModel()
    
    private var selectedRepeatOptionCheckBox: CheckBoxButton? {
        didSet {
            selectedRepeatOptionCheckBox?.isSelected.toggle()
            oldValue?.isSelected.toggle()
        }
    }
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    private let startDateSelectableView = DateSelectableRoundedView(title: "날짜", isNecessary: true)
    private let timeLabel = CustomLabel(title: "시간", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let startTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let startTimeSuffixLabel = CustomLabel(title: "부터", tintColor: .ppsBlack, size: 16)
    private let endTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let endTimeSuffixLabel = CustomLabel(title: "까지", tintColor: .ppsBlack, size: 16)
    
    private let topicTitleLabel = CustomLabel(title: "주제", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let topicTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 주제는 무엇인가요?", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    private let topicTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    private let placeTitleLabel = CustomLabel(title: "장소", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private  let placeTextView: BaseTextView = {
        let bt = BaseTextView(placeholder: "모임 장소를 입력해주세요.", fontSize: 16)
        bt.backgroundColor = .appColor(.background)
        bt.layer.cornerRadius = 21
        return bt
    }()
    private let placeTextViewCharactersCountLimitLabel = CustomLabel(title: "0/20", tintColor: .ppsGray1, size: 12)
    
    private let repeatOptionTitle = CustomLabel(title: "이 일정을 반복할래요!", tintColor: .ppsBlack, size: 16)
    private lazy var repeatOptionStackView: UIStackView = {
        
        let everyDay = CheckBoxButton(title: "매일")
        let everyWeek = CheckBoxButton(title: "매주")
        let everyTwoWeeks = CheckBoxButton(title: "2주 마다")
        let everyMonth = CheckBoxButton(title: "매일")
        
        [everyDay, everyWeek, everyTwoWeeks, everyMonth].forEach { $0.addTarget(self, action: #selector(checkboxDidTapped), for: .touchUpInside)
        }
        
        let sv = UIStackView(arrangedSubviews: [everyDay, everyWeek, everyTwoWeeks, everyMonth])
        
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 2
        
        return sv
    }()
    private let repeatEndDateSelectableView = DateSelectableRoundedView(title: "이날까지", isNecessary: false)
    
    private lazy var doneButton = UIBarButtonItem(title: Const.OK, style: .done, target: self, action: #selector(doneButtonDidTapped))
    
    // MARK: - Life Cycle
    
    init(studySchedule: StudyScheduleComing) {
        
        editingStudyScheduleViewModel.studySchedule = EditingStudySchduleViewController.studyScheduleGoingConverted(from: studySchedule)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editingStudyScheduleViewModel.bind { [self] studySchedule in
            configureUI(studySchedule)
            
            doneButton.isEnabled = studySchedule.periodFormIsFilled && studySchedule.contentFormIsFilled && studySchedule.repeatOptionFormIsFilled
            
            repeatEndDateSelectableView.isUserInteractionEnabled = studySchedule.repeatOption != ""
            repeatEndDateSelectableView.alpha = studySchedule.repeatOption != "" ? 1 : 0.5
        }
        
        configureViews()
        setNavigation()
        enableTapGesture()
        addActionsAtButtons()
        
        topicTextView.delegate = self
        placeTextView.delegate = self
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonDidTapped() {
        editingStudyScheduleViewModel.updateStudySchedule {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func openDateSelectableViewTapped() {
        
        let studySchedule = editingStudyScheduleViewModel.studySchedule
        
        guard let startDate = DateFormatter.dottedDateFormatter.date(from: studySchedule.startDate) else { fatalError() }
        let popUpCalendarVC = PopUpCalendarViewController(type: .start, selectedDate: startDate)
        
        popUpCalendarVC.presentingVC = self

        present(popUpCalendarVC, animated: true)
    }
    
    @objc private func repeatEndDateSelectableViewTapped() {
        
        let studySchedule = editingStudyScheduleViewModel.studySchedule
        
        if let repeatEndDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.repeatEndDate) {
            
            guard let startDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.startDate) else { fatalError() }
            let popUpCalendarVC = PopUpCalendarViewController(type: .end, selectedDate: repeatEndDate)
            
            popUpCalendarVC.startDate = startDate
            popUpCalendarVC.presentingVC = self

            present(popUpCalendarVC, animated: true)
        } else {
            
            guard let startDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.startDate) else { fatalError() }
            let popUpCalendarVC = PopUpCalendarViewController(type: .end, selectedDate: startDate)
            
            popUpCalendarVC.startDate = startDate
            popUpCalendarVC.presentingVC = self
            
            present(popUpCalendarVC, animated: true)
        }
    }
    
    @objc private func checkboxDidTapped(_ sender: CheckBoxButton) {
       
        if selectedRepeatOptionCheckBox == sender {
            
            editingStudyScheduleViewModel.studySchedule.repeatOption = ""
            // 반복일정 끝나는 날짜 초기화
            editingStudyScheduleViewModel.studySchedule.repeatEndDate = ""
            selectedRepeatOptionCheckBox = nil
        } else {
            
            guard let title = sender.currentTitle else { return }
            let repeatOption = title.convertedEnglish()
            
            editingStudyScheduleViewModel.studySchedule.repeatOption = repeatOption
            selectedRepeatOptionCheckBox = sender
        }
    }
    
    @objc private func startTimeSelectButtonDidTapped(_ sender: CustomButton) {
        
        let alert = UIAlertController(title: "시간선택", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_gb")
        
        
        if let endTime = editingStudyScheduleViewModel.studySchedule.endTime {
            datePicker.maximumDate = DateFormatter.timeFormatter.date(from: endTime)
        }
        
        let okAction = UIAlertAction(title: Const.OK, style: .default) { _ in
            let startTime = DateFormatter.timeFormatter.string(from: datePicker.date)
            self.editingStudyScheduleViewModel.studySchedule.startTime = startTime
        }
        
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)
        
        /// picker 수정하기
        alert.view.addSubview(datePicker)
        
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalTo(alert.view.safeAreaLayoutGuide)
            make.top.equalTo(alert.view).offset(50)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func endTimeSelectButtonDidTapped(_ sender: CustomButton) {
        
        let alert = UIAlertController(title: "시간선택", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        
        datePicker.calendar = Calendar.current
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_gb")
        
        if let startTime = editingStudyScheduleViewModel.studySchedule.startTime {
            datePicker.minimumDate = DateFormatter.timeFormatter.date(from: startTime)
        }

        let okAction = UIAlertAction(title: Const.OK, style: .default) { _ in
            let endTime = DateFormatter.timeFormatter.string(from: datePicker.date)
            self.editingStudyScheduleViewModel.studySchedule.endTime = endTime
        }
        
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)
        
        /// picker 수정하기
        alert.view.addSubview(datePicker)
        
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(50)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        
    }
    
    @objc private func onKeyboardDisappear(_ notification: NSNotification) {
     
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onKeyboardDisappear))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(startDateSelectableView)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(startTimeSelectButton)
        containerView.addSubview(startTimeSuffixLabel)
        containerView.addSubview(endTimeSelectButton)
        containerView.addSubview(endTimeSuffixLabel)
      
        containerView.addSubview(topicTitleLabel)
        containerView.addSubview(topicTextView)
        containerView.addSubview(topicTextViewCharactersCountLimitLabel)
        
        containerView.addSubview(placeTitleLabel)
        containerView.addSubview(placeTextView)
        containerView.addSubview(placeTextViewCharactersCountLimitLabel)
        
        containerView.addSubview(repeatOptionTitle)
        containerView.addSubview(repeatOptionStackView)
        
        containerView.addSubview(repeatEndDateSelectableView)
    }
    
    private static func studyScheduleGoingConverted(from studySchedule: StudyScheduleComing) -> StudyScheduleGoing {
        
        let studyScheduleID = studySchedule.studyScheduleID
        let topic = studySchedule.topic
        let place = studySchedule.place
    
        let startDate = DateFormatter.dashedDateFormatter.string(from: studySchedule.startDateAndTime)
        let startTime = DateFormatter.timeFormatter.string(from: studySchedule.startDateAndTime)
        let endTime = DateFormatter.timeFormatter.string(from: studySchedule.endDateAndTime)

        return StudyScheduleGoing(studyID: nil, studyScheduleID: studyScheduleID, topic: topic, place: place, startDate: startDate, repeatEndDate: "", startTime: startTime, endTime: endTime)
    }
    
    private func configureUI(_ studySchedule: StudyScheduleGoing) {
        
        if let startDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.startDate) {
            startDateSelectableView.setUpCalendarLinkedDateLabel(at: startDate)
        }
        
        if let repeatEndDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.repeatEndDate) {
            repeatEndDateSelectableView.setUpCalendarLinkedDateLabel(at: repeatEndDate)
        } else {
            repeatEndDateSelectableView.calendarLinkedDateLabel.text = ""
        }
        
        if let startTime = studySchedule.startTime {
            startTimeSelectButton.setTitle(startTime, for: .normal)
            startTimeSelectButton.setTitleColor(.appColor(.ppsBlack), for: .normal)
        } else {
            startTimeSelectButton.setTitle("--:--", for: .normal)
            startTimeSelectButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
        }

        if let endTime = studySchedule.endTime {
            endTimeSelectButton.setTitle(endTime, for: .normal)
            endTimeSelectButton.setTitleColor(.appColor(.ppsBlack), for: .normal)
        } else {
            endTimeSelectButton.setTitle("--:--", for: .normal)
            endTimeSelectButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
        }

        if let place = studySchedule.place, !place.isEmpty {
            placeTextView.text = studySchedule.place
            placeTextView.hidePlaceholder(true)
            placeTextViewCharactersCountLimitLabel.text = "\(studySchedule.place?.count ?? 0)/20"
        }
        
        if let topic = studySchedule.topic, !topic.isEmpty {
            topicTextView.text = studySchedule.topic
            topicTextView.hidePlaceholder(true)
            topicTextViewCharactersCountLimitLabel.text = "\(studySchedule.topic?.count ?? 0)/20"
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addActionsAtButtons() {
        
        startDateSelectableView.addTapGesture(target: self, action: #selector(openDateSelectableViewTapped))
        repeatEndDateSelectableView.addTapGesture(target: self, action: #selector(repeatEndDateSelectableViewTapped))
        
        startTimeSelectButton.addTarget(self, action: #selector(startTimeSelectButtonDidTapped), for: .touchUpInside)
        endTimeSelectButton.addTarget(self, action: #selector(endTimeSelectButtonDidTapped), for: .touchUpInside)
    }
    
    private func setNavigation() {
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        
        navigationItem.title = "일정 수정"
        
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Const.cancel, style: .plain, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.height)
        }
        
        startDateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(30)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateSelectableView.snp.bottom).offset(40)
            make.leading.equalTo(containerView).inset(20)
        }
        startTimeSelectButton.snp.makeConstraints { make in
            make.leading.equalTo(containerView).inset(20)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
        }
        startTimeSuffixLabel.snp.makeConstraints { make in
            make.leading.equalTo(startTimeSelectButton.snp.trailing).offset(15)
            make.centerY.equalTo(startTimeSelectButton)
        }
        endTimeSelectButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(startTimeSuffixLabel.snp.trailing).offset(10)
            make.centerY.equalTo(startTimeSuffixLabel)
            make.width.equalTo(100)
        }
        endTimeSuffixLabel.snp.makeConstraints { make in
            make.leading.equalTo(endTimeSelectButton.snp.trailing).offset(15)
            make.trailing.equalTo(containerView).inset(20)
            make.centerY.equalTo(endTimeSelectButton)
        }
        placeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(startTimeSelectButton.snp.bottom).offset(40)
            make.leading.equalTo(containerView).inset(20)
        }
        placeTextView.snp.makeConstraints { make in
            make.top.equalTo(placeTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.height.equalTo(42)
        }
        placeTextViewCharactersCountLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(placeTextView).inset(20)
            make.bottom.equalTo(placeTextView.snp.top).offset(-13)
        }
        topicTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeTextView.snp.bottom).offset(60)
            make.leading.equalTo(containerView).inset(20)
        }
        topicTextView.snp.makeConstraints { make in
            make.top.equalTo(topicTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.height.equalTo(42)
        }
        topicTextViewCharactersCountLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(topicTextView).inset(20)
            make.bottom.equalTo(topicTextView.snp.top).offset(-13)
        }
        repeatOptionTitle.snp.makeConstraints { make in
            make.top.equalTo(topicTextView.snp.bottom).offset(40)
            make.leading.equalTo(containerView).inset(20)
        }
        repeatOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(repeatOptionTitle.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        repeatEndDateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(repeatOptionStackView.snp.bottom).offset(16)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
    }
}

// MARK: - UITextViewDelegate

extension EditingStudySchduleViewController: UITextViewDelegate {
    
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

        switch textView {
            case topicTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                topicTextViewCharactersCountLimitLabel.text = newLength > 20 ? "20/20" : "\(newLength)/20"
                return newLength <= 20
            case placeTextView:
                
                guard let inputedText = textView.text else { return true }
                let newLength = inputedText.count + text.count - range.length
                placeTextViewCharactersCountLimitLabel.text = newLength > 20 ? "20/20" : "\(newLength)/20"
                return newLength <= 20
                
            default:
                return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        ///엔터 입력할때 안되도록...막아야함
        switch textView {
        case topicTextView:
            if topicTextView.text.contains(where: { $0 == "\n" }) {
                topicTextView.text = topicTextView.text.replacingOccurrences(of: "\n", with: "")
            }
            editingStudyScheduleViewModel.studySchedule.topic = topicTextView.text
        case placeTextView:
            if placeTextView.text.contains(where: { $0 == "\n" }) {
                placeTextView.text = placeTextView.text.replacingOccurrences(of: "\n", with: "")
            }
            editingStudyScheduleViewModel.studySchedule.place = placeTextView.text
        default:
            break
        }
    }
}
