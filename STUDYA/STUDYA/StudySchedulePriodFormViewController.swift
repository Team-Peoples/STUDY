//
//  StudyScheduleFormViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/22/22.
//

import UIKit

class StudySchedulePriodFormViewController: UIViewController {
    
    let dateSelectableView = DateSelectableRoundedView(title: "날짜", isNecessary: true)
    let timeTitle = CustomLabel(title: "시간", tintColor: .ppsBlack, size: 16, isNecessaryTitle: true)
    let startTimeSelectButton = CustomButton(title: "--:--", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    let startTimeSuffixLabel = CustomLabel(title: "부터", tintColor: .ppsBlack, size: 16)
    let endTimeSelectButton = CustomButton(title: "--:-1", fontSize: 20, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray2), radius: 21)
    let endTimeSuffixLabel = CustomLabel(title: "까지", tintColor: .ppsBlack, size: 16)
    
    let repeatOptionTitle = CustomLabel(title: "이 일정을 반복할래요!", tintColor: .ppsBlack, size: 16)
    lazy var repeatOptionStackView: UIStackView = {
        
        let everyDay = CheckBoxButton(title: "매일")
        let everyWeek = CheckBoxButton(title: "매주")
        let everyTwoWeeks = CheckBoxButton(title: "격주")
        let everyMonth = CheckBoxButton(title: "매달")
        
        [everyDay, everyWeek, everyTwoWeeks, everyMonth].forEach { $0.addTarget(self, action: #selector(checkboxDidTapped), for: .touchUpInside)
        }
        
        let sv = UIStackView(arrangedSubviews: [everyDay, everyWeek, everyTwoWeeks, everyMonth])
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 2
        return sv
    }()
    let deadlineDateSelectableView = DateSelectableRoundedView(title: "이날까지", isNecessary: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(dateSelectableView)
        view.addSubview(timeTitle)
        view.addSubview(startTimeSelectButton)
        view.addSubview(startTimeSuffixLabel)
        view.addSubview(endTimeSelectButton)
        view.addSubview(endTimeSuffixLabel)
        view.addSubview(repeatOptionTitle)
        view.addSubview(repeatOptionStackView)
        view.addSubview(deadlineDateSelectableView)
        
        dateSelectableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(42)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        timeTitle.snp.makeConstraints { make in
            make.top.equalTo(dateSelectableView.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        startTimeSelectButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(timeTitle.snp.bottom).offset(10)
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
        
        dateSelectableView.addTapGesture(target: self, action: #selector(dateSelect))
        
        [startTimeSelectButton, endTimeSelectButton].forEach { $0.addTarget(self, action: #selector(dateSelectButtonDidTapped), for: .touchUpInside) }
    }
    
    // MARK: - Actions
    
    @objc func dateSelect() {
        print(#function)
    }
    
    @objc func checkboxDidTapped(_ sender: CheckBoxButton) {
        print(#function)
    }
    
    @objc func dateSelectButtonDidTapped() {
        
        let alert = UIAlertController(title: "시간선택", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_gb")
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        /// picker 수정하기
        alert.view.addSubview(datePicker)
        
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
    
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        
                
        present(alert, animated: true)
    }
}

final class DateSelectableRoundedView: UIView {
    
    var title: String
    var isNecessary: Bool
    
    lazy var titleLabel = CustomLabel(title: self.title, tintColor: .ppsBlack, size: 16, isNecessaryTitle: self.isNecessary)
    let calendarLinkedDateLabel = CustomLabel(title: "\(Date().formatToString(language: .kor))", tintColor: .ppsBlack, size: 16, isBold: true)
    let calendarIcon = UIImageView(image: UIImage(named: "calendar"))
    
    init(title: String, isNecessary: Bool) {
        self.title = title
        self.isNecessary = isNecessary
        
        super.init(frame: .zero)
        
        self.backgroundColor = .appColor(.background)
        self.configureBorder(color: .background, width: 0, radius: 21)
        
        addSubview(titleLabel)
        addSubview(calendarLinkedDateLabel)
        addSubview(calendarIcon)
        
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
}
