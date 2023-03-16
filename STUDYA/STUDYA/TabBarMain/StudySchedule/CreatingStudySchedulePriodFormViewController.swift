//
//  StudyScheduleFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/22/22.
//

import UIKit

final class CreatingStudySchedulePriodFormViewController: UIViewController {
    
    // MARK: - Properties
    
    var studySchedulePostingViewModel = StudySchedulePostingViewModel()
    
    private var selectedRepeatOptionCheckBox: CheckBoxButton? {
        didSet {
            selectedRepeatOptionCheckBox?.isSelected.toggle()
            oldValue?.isSelected.toggle()
        }
    }
    
    private let startDateSelectableView = DateSelectableRoundedView(title: "날짜", isNecessary: true)
    private let timeLabel = CustomLabel(title: "시간", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    private let startTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let startTimeSuffixLabel = CustomLabel(title: "부터", tintColor: .ppsBlack, size: 16)
    private let endTimeSelectButton = BrandButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    private let endTimeSuffixLabel = CustomLabel(title: "까지", tintColor: .ppsBlack, size: 16)
    private let repeatOptionTitleLabel = CustomLabel(title: "이 일정을 반복할래요!", tintColor: .ppsBlack, size: 16)
    private lazy var repeatOptionStackView: UIStackView = {
        
        let everyDay = CheckBoxButton(title: RepeatOption.everyDay.translatedKorean)
        let everyWeek = CheckBoxButton(title: RepeatOption.everyWeek.translatedKorean)
        let everyTwoWeeks = CheckBoxButton(title: RepeatOption.everyTwoWeeks.translatedKorean)
        let everyMonth = CheckBoxButton(title: RepeatOption.everyMonth.translatedKorean)
        
        [everyDay, everyWeek, everyTwoWeeks, everyMonth].forEach {
            $0.addTarget(self, action: #selector(checkboxDidTapped), for: .touchUpInside)
        }
        
        let sv = UIStackView(arrangedSubviews: [everyDay, everyWeek, everyTwoWeeks, everyMonth])
        
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 2
        
        return sv
    }()
    private let repeatEndDateSelectableView = DateSelectableRoundedView(title: "이날까지", isNecessary: false)
    private let nextButton = BrandButton(title: "다음", isBold: true, isFill: false)
    private lazy var closeButton = UIBarButtonItem(image: UIImage(named: "close")?.withTintColor(.white), style: .done, target: self, action: #selector(closeButtonDidTapped))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studySchedulePostingViewModel.bind { [self] studySchedule in
            configureUI(studySchedule)
            
            nextButton.isEnabled = studySchedule.periodFormIsFilled && studySchedule.repeatOptionFormIsFilled
            nextButton.isEnabled ? nextButton.fillIn(title: "다음") : nextButton.fillOut(title: "다음")
            
            repeatEndDateSelectableView.isUserInteractionEnabled = studySchedule.repeatOption != .norepeat
            repeatEndDateSelectableView.alpha = studySchedule.repeatOption != .norepeat ? 1 : 0.5
        }
        
        configureViews()
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonDidTapped() {
        
        let periodFormVC = CreatingStudyScheduleContentViewController()
        
        periodFormVC.studySchedulePostingViewModel = self.studySchedulePostingViewModel
        navigationController?.pushViewController(periodFormVC, animated: true)
    }
    
    @objc private func closeButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func startDateSelectableViewTapped() {
        
        let studySchedule = studySchedulePostingViewModel.studySchedule
        let repeatEndDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.repeatEndDate)
        let startDate = DateFormatter.dottedDateFormatter.date(from: studySchedule.startDate)!
        let popUpCalendarVC = StudySchedulePopUpCalendarViewController(type: .start, selectedDate: startDate, viewModel: studySchedulePostingViewModel)
        
        popUpCalendarVC.endDate = repeatEndDate

        present(popUpCalendarVC, animated: true)
    }
    
    @objc private func repeatEndDateSelectableViewTapped() {
        
        let studySchedule = studySchedulePostingViewModel.studySchedule
        let repeatEndDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.repeatEndDate)
        let startDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.startDate)!
        let popUpCalendarVC = StudySchedulePopUpCalendarViewController(type: .end, selectedDate: repeatEndDate ?? startDate, viewModel: studySchedulePostingViewModel)
        
        popUpCalendarVC.startDate = startDate
       
        present(popUpCalendarVC, animated: true)
    }
    
    @objc private func checkboxDidTapped(_ sender: CheckBoxButton) {

        if selectedRepeatOptionCheckBox == sender {
            
            studySchedulePostingViewModel.studySchedule.repeatOption = .norepeat
            studySchedulePostingViewModel.studySchedule.repeatEndDate = ""
            selectedRepeatOptionCheckBox = nil
        } else {
            
            guard let title = sender.currentTitle else { return }
            
            switch title {
            case RepeatOption.everyDay.translatedKorean:
                studySchedulePostingViewModel.studySchedule.repeatOption = RepeatOption.everyDay
            case RepeatOption.everyWeek.translatedKorean:
                studySchedulePostingViewModel.studySchedule.repeatOption = RepeatOption.everyWeek
            case RepeatOption.everyTwoWeeks.translatedKorean:
                studySchedulePostingViewModel.studySchedule.repeatOption = RepeatOption.everyTwoWeeks
            case RepeatOption.everyMonth.translatedKorean:
                studySchedulePostingViewModel.studySchedule.repeatOption = RepeatOption.everyMonth
            default:
                break
            }
            selectedRepeatOptionCheckBox = sender
        }
    }
    
    @objc private func startTimeSelectButtonDidTapped(_ sender: CustomButton) {
        
        let alert = UIAlertController(title: "시간선택", message: nil, preferredStyle: .actionSheet)
        let timePicker = CalendarTimePicker.shared
        
        if let endTime = studySchedulePostingViewModel.studySchedule.endTime {
            guard let hour = endTime.components(separatedBy: ":").first?.toInt(),
                  let minute = endTime.components(separatedBy: ":").last?.toInt() else { return }
            timePicker.maximumDate = Calendar.current.date(bySettingHour: hour, minute: minute - 1, second: 0, of: Date())
        }
        
        let okAction = UIAlertAction(title: Constant.OK, style: .default) { _ in
            let startTime = DateFormatter.timeFormatter.string(from: timePicker.date)
            self.studySchedulePostingViewModel.studySchedule.startTime = startTime
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        

        alert.view.addSubview(timePicker)
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        timePicker.snp.makeConstraints { make in
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
        let timePicker = CalendarTimePicker.shared
        
        if let startTime = studySchedulePostingViewModel.studySchedule.startTime {
            guard let hour = startTime.components(separatedBy: ":").first?.toInt(),
                  let minute = startTime.components(separatedBy: ":").last?.toInt() else { return }
            timePicker.minimumDate = Calendar.current.date(bySettingHour: hour, minute: minute + 1, second: 0, of: Date())
        }

        let okAction = UIAlertAction(title: Constant.OK, style: .default) { _ in
            let endTime = DateFormatter.timeFormatter.string(from: timePicker.date)
            self.studySchedulePostingViewModel.studySchedule.endTime = endTime
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        /// picker 수정하기
        alert.view.addSubview(timePicker)
        
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        timePicker.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(50)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func addActionsAtButtons() {
        
        startDateSelectableView.addTapGesture(target: self, action: #selector(startDateSelectableViewTapped))
        repeatEndDateSelectableView.addTapGesture(target: self, action: #selector(repeatEndDateSelectableViewTapped))
        
        startTimeSelectButton.addTarget(self, action: #selector(startTimeSelectButtonDidTapped), for: .touchUpInside)
        endTimeSelectButton.addTarget(self, action: #selector(endTimeSelectButtonDidTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
    }
    
    private func configureUI(_ studySchedule: StudySchedulePosting) {
    
        if let startDate = DateFormatter.dashedDateFormatter.date(from: studySchedule.startDate) {
            startDateSelectableView.setUpCalendarLinkedDateLabel(at: startDate)
        } else {
            startDateSelectableView.setUpCalendarLinkedDateLabel(at: Date())
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
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        setNavigation()
        addActionsAtButtons()
        addSubviewsWithConstraints()
    }
    
    private func setNavigation() {
        self.navigationItem.title = "일정 만들기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func addSubviewsWithConstraints() {
        
        view.addSubview(startDateSelectableView)
        view.addSubview(timeLabel)
        view.addSubview(startTimeSelectButton)
        view.addSubview(startTimeSuffixLabel)
        view.addSubview(endTimeSelectButton)
        view.addSubview(endTimeSuffixLabel)
        view.addSubview(repeatOptionTitleLabel)
        view.addSubview(repeatOptionStackView)
        view.addSubview(repeatEndDateSelectableView)
        view.addSubview(nextButton)
        
        startDateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateSelectableView.snp.bottom).offset(40)
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
        repeatOptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(startTimeSelectButton.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
        }
        repeatOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(repeatOptionTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        repeatEndDateSelectableView.snp.makeConstraints { make in
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
        let dateComponents = date.convertToDateComponents([.year, .month, .day, .weekday])
        
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day,
              let weekday = dateComponents.weekday else { return }
        
        calendarLinkedDateLabel.text = "\(year)년 \(month)월 \(day)일 \(Calendar.current.weekday(weekday))요일"
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
