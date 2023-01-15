//
//  StudyScheduleFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/22/22.
//

import UIKit

final class CreatingStudySchedulePriodFormViewController: UIViewController {
    
    // MARK: - Properties
    
    var studyScheduleViewModel = StudyScheduleViewModel()
    
    private var selectedRepeatOptionCheckBox: CheckBoxButton? {
        didSet {
            selectedRepeatOptionCheckBox?.isSelected.toggle()
            oldValue?.isSelected.toggle()
        }
    }
    
    private let openDateSelectableView = DateSelectableRoundedView(title: "날짜", isNecessary: true)
    private let timeLabel = CustomLabel(title: "시간", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let startTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let startTimeSuffixLabel = CustomLabel(title: "부터", tintColor: .ppsBlack, size: 16)
    private let endTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let endTimeSuffixLabel = CustomLabel(title: "까지", tintColor: .ppsBlack, size: 16)
    private let repeatOptionTitle = CustomLabel(title: "이 일정을 반복할래요!", tintColor: .ppsBlack, size: 16)
    private lazy var repeatOptionStackView: UIStackView = {
        
        let everyDay = CheckBoxButton(title: "매일")
        let everyWeek = CheckBoxButton(title: "매주")
        let everyTwoWeeks = CheckBoxButton(title: "2주 마다")
        let everyMonth = CheckBoxButton(title: "매달")
        
        [everyDay, everyWeek, everyTwoWeeks, everyMonth].forEach { $0.addTarget(self, action: #selector(checkboxDidTapped), for: .touchUpInside)
        }
        
        let sv = UIStackView(arrangedSubviews: [everyDay, everyWeek, everyTwoWeeks, everyMonth])
        
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 2
        
        return sv
    }()
    private let deadlineDateSelectableView = DateSelectableRoundedView(title: "이날까지", isNecessary: false)
    private let nextButton = BrandButton(title: "다음", isBold: true, isFill: false)
    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close")?.withTintColor(.white), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyScheduleViewModel.bind { [self] studySchedule in
            configureUI(studySchedule)
            
            nextButton.isEnabled = studySchedule.periodFormIsFilled && studySchedule.deadlineFormIsFilled
            nextButton.isEnabled ? nextButton.fillIn(title: "다음") : nextButton.fillOut(title: "다음")
            
            deadlineDateSelectableView.isUserInteractionEnabled = studySchedule.repeatOption != ""
            deadlineDateSelectableView.alpha = studySchedule.repeatOption != "" ? 1 : 0.5
        }
        
        setNavigation()
        
        configureViews()
        addActionsAtButtons()
        setConstraints()
        
        nextButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonDidTapped() {
        
        let periodFormVC = CreatingStudyScheduleContentViewController()
        
        periodFormVC.studyScheduleViewModel = self.studyScheduleViewModel
        navigationController?.pushViewController(periodFormVC, animated: true)
    }
    
    @objc private func closeButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func openDateSelectableViewTapped() {
        
        guard let openDate = studyScheduleViewModel.studySchedule.openDate?.formatToDate() else { fatalError() }
        let popUpCalendarVC = PopUpCalendarViewController(type: .open, selectedDate: openDate)

        popUpCalendarVC.presentingVC = self

        present(popUpCalendarVC, animated: true)
    }
    
    @objc private func deadlineDateSelectableViewTapped() {
        if let deadlineDate = studyScheduleViewModel.studySchedule.deadlineDate?.formatToDate() {
            
            guard let openDate = studyScheduleViewModel.studySchedule.openDate?.formatToDate() else { return }
            let popUpCalendarVC = PopUpCalendarViewController(type: .deadline, selectedDate: deadlineDate)
            
            popUpCalendarVC.openDate = openDate
            popUpCalendarVC.presentingVC = self

            present(popUpCalendarVC, animated: true)
        } else {
            
            guard let openDate = studyScheduleViewModel.studySchedule.openDate?.formatToDate() else { return }
            let popUpCalendarVC = PopUpCalendarViewController(type: .deadline, selectedDate: openDate)
            
            popUpCalendarVC.openDate = openDate
            popUpCalendarVC.presentingVC = self
            
            present(popUpCalendarVC, animated: true)
        }
    }
    
    @objc private func checkboxDidTapped(_ sender: CheckBoxButton) {

        if selectedRepeatOptionCheckBox == sender {
            
            studyScheduleViewModel.studySchedule.repeatOption = ""
            // 반복일정 끝나는 날짜 초기화
            studyScheduleViewModel.studySchedule.deadlineDate = ""
            selectedRepeatOptionCheckBox = nil
        } else {
            
            guard let title = sender.currentTitle else { return }
            let repeatOption = title.convertedEnglish()
            
            studyScheduleViewModel.studySchedule.repeatOption = repeatOption
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
        
        
        if let endTime = studyScheduleViewModel.studySchedule.endTime {
            guard let hour = endTime.components(separatedBy: ":").first?.toInt(),
                  let minute = endTime.components(separatedBy: ":").last?.toInt() else { return }
            datePicker.maximumDate = Calendar.current.date(bySettingHour: hour, minute: minute - 1, second: 0, of: Date())
        }
        
        let okAction = UIAlertAction(title: Const.OK, style: .default) { _ in
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            
            guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
            
            self.studyScheduleViewModel.studySchedule.startTime = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
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
        
        if let startTime = studyScheduleViewModel.studySchedule.startTime {
            guard let hour = startTime.components(separatedBy: ":").first?.toInt(),
                  let minute = startTime.components(separatedBy: ":").last?.toInt() else { return }
            datePicker.minimumDate = Calendar.current.date(bySettingHour: hour, minute: minute + 1, second: 0, of: Date())
        }

        let okAction = UIAlertAction(title: Const.OK, style: .default) { _ in
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            
            guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
           
            self.studyScheduleViewModel.studySchedule.endTime = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
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
    
    private func addActionsAtButtons() {
        
        openDateSelectableView.addTapGesture(target: self, action: #selector(openDateSelectableViewTapped))
        deadlineDateSelectableView.addTapGesture(target: self, action: #selector(deadlineDateSelectableViewTapped))
        
        startTimeSelectButton.addTarget(self, action: #selector(startTimeSelectButtonDidTapped), for: .touchUpInside)
        endTimeSelectButton.addTarget(self, action: #selector(endTimeSelectButtonDidTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
    }
    
    private func configureUI(_ studySchedule: StudyScheduleGoing) {
        
        if let openDate = studySchedule.openDate?.formatToDate() {
            openDateSelectableView.setUpCalendarLinkedDateLabel(at: openDate)
        } else {
            openDateSelectableView.setUpCalendarLinkedDateLabel(at: Date())
        }
        
        if let deadlineDate = studySchedule.deadlineDate?.formatToDate() {
            deadlineDateSelectableView.setUpCalendarLinkedDateLabel(at: deadlineDate)
        } else {
            deadlineDateSelectableView.calendarLinkedDateLabel.text = ""
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
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(openDateSelectableView)
        view.addSubview(timeLabel)
        view.addSubview(startTimeSelectButton)
        view.addSubview(startTimeSuffixLabel)
        view.addSubview(endTimeSelectButton)
        view.addSubview(endTimeSuffixLabel)
        view.addSubview(repeatOptionTitle)
        view.addSubview(repeatOptionStackView)
        view.addSubview(deadlineDateSelectableView)
        view.addSubview(nextButton)
    }
    
    private func setNavigation() {
        self.navigationItem.title = "일정 만들기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        openDateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(openDateSelectableView.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        startTimeSelectButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(    timeLabel.snp.bottom).offset(10)
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
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.centerY.equalTo(endTimeSelectButton)
        }
        repeatOptionTitle.snp.makeConstraints { make in
            make.top.equalTo(startTimeSelectButton.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
        }
        repeatOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(repeatOptionTitle.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        deadlineDateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(repeatOptionStackView.snp.bottom).offset(16)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
}

// MARK: - DateSelectableRoundedView

final class DateSelectableRoundedView: UIView {
    
    // MARK: - Properties
    
    private let title: String
    private let isNecessary: Bool
    
    private lazy var titleLabel = CustomLabel(title: self.title, tintColor: .ppsBlack, size: 16, isNecessaryTitle: self.isNecessary)
    let calendarLinkedDateLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 16, isBold: true)
    let calendarIcon = UIImageView(image: UIImage(named: "calendar"))
    
    // MARK: - Initialization
    
    init(title: String, isNecessary: Bool) {
        self.title = title
        self.isNecessary = isNecessary
        
        super.init(frame: .zero)
    
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func addTapGesture(target: Any?, action: Selector) {
        
        [calendarLinkedDateLabel, calendarIcon].forEach {
            
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        }
    }
    
    func setUpCalendarLinkedDateLabel(at date: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day,
              let weekday = dateComponents.weekday else { return }
        
        calendarLinkedDateLabel.text = "\(year)년 \(month)월 \(day)일 \(calendar.weekday(weekday))요일"
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        backgroundColor = .appColor(.background)
        configureBorder(color: .background, width: 0, radius: 21)
        
        addSubview(titleLabel)
        addSubview(calendarLinkedDateLabel)
        addSubview(calendarIcon)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(20)
        }
        calendarIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(15)
            make.height.width.equalTo(20)
        }
        calendarLinkedDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarIcon)
            make.trailing.equalTo(calendarIcon.snp.leading).offset(-10)
        }
    }
}
