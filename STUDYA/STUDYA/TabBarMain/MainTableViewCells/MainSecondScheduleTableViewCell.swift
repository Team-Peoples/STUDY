//
//  MainSecondScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit

class MainSecondScheduleTableViewCell: UITableViewCell {
    
    static let identifier = "MainSecondScheduleTableViewCell"
    
    internal var navigatableManagableDelegate: (Navigatable & Managable)!
    
    private let title = CustomLabel(title: "", tintColor: .ppsBlack, size: 20, isBold: true)
    private let disclosureIndicatorView = UIImageView(image: UIImage(named: "circleDisclosureIndicator"))
    
    private lazy var noScheudleLabel = CustomLabel(title: "예정된 일정이 없어요 😴", tintColor: .ppsGray1, size: 14)
    
    private lazy var date = CustomLabel(title: "날짜 정보를 가져오지 못했습니다.", tintColor: .keyColor1, size: 16, isBold: true)
    private lazy var place = CustomLabel(title: "장소 정보를 가져오지 못했습니다.", tintColor: .ppsGray1, size: 12)
    private lazy var todayContent = CustomLabel(title: "컨텐츠 정보를 가져오지 못했습니다.", tintColor: .ppsGray1, size: 14)
    
    private let scheduleBackView: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = .white
        
        addSubviews()
        constrainLine()
        setConstraints()
    }
    
    private func configureDateInformation(_ startTime: Date?) {
        guard let startTime = startTime else { return }
        let dateComponents = startTime.convertToDateComponents([.year, .month, .day, .hour, .minute, .weekday])
        guard let month = dateComponents.month,
              let day = dateComponents.day,
              let unformattedHour = dateComponents.hour,
              let unformattedminute = dateComponents.minute else { return }
        
        let amPm = unformattedHour > 11 ? "pm" : "am"
        let unformattedHour12 = unformattedHour > 12 ? unformattedHour % 12 : unformattedHour
        let hour = String(format: "%02d", unformattedHour12)
        let minute = String(format: "%02d", unformattedminute)
        
        let weekday = Calendar.current.weekday(dateComponents.weekday)
        
        date.text = "\(month)월 \(day)일 (\(weekday))  |  \(amPm) \(hour):\(minute)"
    }
    
    private func constrainLine() {
            title.numberOfLines = 1
            date.numberOfLines = 1
            place.numberOfLines = 1
            todayContent.numberOfLines = 1
    }
    
    internal func configureCellWith(nickName: String?, schedule: StudySchedule?) {
        configureTitleNickNameLabel(nickName: nickName)
        
        if let schedule = schedule {
            configureLabelsWhenYesStudySchedule(schedule: schedule)
        } else {
            configureLabelsWhenNoStudySchedule()
        }
    }
    
    private func configureTitleNickNameLabel(nickName: String?) {
        title.text = "\(nickName ?? "회원")님의 일정"
    }
    
    private func configureLabelsWhenYesStudySchedule(schedule: StudySchedule) {
        place.text = "장소: \(schedule.place ?? "")"
        todayContent.text = schedule.topic
        configureDateInformation(schedule.startDateAndTime)
        
        noScheudleLabel.isHidden = true
        date.isHidden = false
        place.isHidden = false
        todayContent.isHidden = false
    }
    
    private func configureLabelsWhenNoStudySchedule() {
        noScheudleLabel.isHidden = false
        date.isHidden = true
        place.isHidden = true
        todayContent.isHidden = true
    }
    
    private func addSubviews() {
        addSubview(scheduleBackView)
        scheduleBackView.addSubview(title)
        scheduleBackView.addSubview(disclosureIndicatorView)
        
        scheduleBackView.addSubview(date)
        scheduleBackView.addSubview(place)
        scheduleBackView.addSubview(todayContent)
        
        scheduleBackView.addSubview(noScheudleLabel)
    }
    
    private func setConstraints() {
        scheduleBackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        title.snp.makeConstraints { make in
            make.top.leading.equalTo(scheduleBackView).inset(24)
            make.trailing.equalTo(disclosureIndicatorView.snp.leading)
        }
        disclosureIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalTo(scheduleBackView.snp.trailing).offset(-12)
            make.width.height.equalTo(28)
        }
        
        date.anchor(top: title.bottomAnchor, topConstant: 30, leading: title.leadingAnchor)
        place.anchor(top: date.bottomAnchor, topConstant: 2, leading: date.leadingAnchor)
        todayContent.anchor(top: place.bottomAnchor, topConstant: 13, leading: place.leadingAnchor, trailing: place.trailingAnchor)
        
        noScheudleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(scheduleBackView)
            make.top.equalTo(title.snp.bottom).offset(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
