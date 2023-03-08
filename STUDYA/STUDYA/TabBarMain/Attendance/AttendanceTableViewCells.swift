//
//  AttendanceTableViewCells.swift
//  STUDYA
//
//  Created by 서동운 on 11/18/22.
//

import UIKit

final class AttendanceDetailsCell: UITableViewCell {
    
    // MARK: - Properties
    var bottomSheetAddableDelegate: BottomSheetAddable?
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(image: UIImage(named: "details")!, text: " 상세 내역")
        return lbl
    }()
    private let periodSettingButton = BrandButton(title: "", textColor: .ppsGray1, borderColor: .ppsGray2, backgroundColor: .systemBackground, fontSize: 14, height: 30)
    private let roundedBackgroundView = RoundableView(cornerRadius: 16)
    
    private let attendanceCountLabel = CustomLabel(title: "?", tintColor: .attendedMain, size: 14)
    private let latenessCountLabel = CustomLabel(title: "?", tintColor: .lateMain, size: 14)
    private let absenceCountLabel = CustomLabel(title: "?", tintColor: .absentMain, size: 14)
    private let allowedCountLabel = CustomLabel(title: "?", tintColor: .allowedMain, size: 14)
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setupTitleLabel()
        setupPeriodSettingButton()
        setupRoundedBackgroundView()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func periodSettingButtonDidTapped() {
        let bottomVC = AttendanceBottomViewController()
        
        bottomVC.viewType = .individualPeriodSearchSetting
        bottomSheetAddableDelegate?.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
    
    func configureCell(with attendanceOverall: UserAttendanceOverall) {       
        attendanceCountLabel.text = attendanceOverall.attendedCount.toString()
        latenessCountLabel.text = attendanceOverall.lateCount.toString()
        absenceCountLabel.text = attendanceOverall.absentCount.toString()
        allowedCountLabel.text = attendanceOverall.allowedCount.toString()
        
        fineLabel.attributedText = AttributedString.custom(frontLabel: "", labelFontSize: 12, value: attendanceOverall.totalFine, valueFontSize: 18, valueTextColor: .ppsGray1, withCurrency: true)
    }
    
    // MARK: - Configure
    
    func setupTitleLabel() {
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.leading.equalTo(contentView).inset(20)
        }
    }
    
    func setupPeriodSettingButton() {
        
        let today = Date()
        let dashedToday = DateFormatter.shortenDottedDateFormatter.string(from: today)
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let dashedThirtyDaysAgo = DateFormatter.shortenDottedDateFormatter.string(from: thirtyDaysAgo ?? today)
        
        periodSettingButton.setTitle("\(dashedThirtyDaysAgo)~\(dashedToday)", for: .normal)
        
        contentView.addSubview(periodSettingButton)
        
        periodSettingButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        periodSettingButton.addTarget(self, action: #selector(periodSettingButtonDidTapped), for: .touchUpInside)
    
        periodSettingButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
    
    func setupRoundedBackgroundView() {
        
        contentView.addSubview(roundedBackgroundView)
        
        roundedBackgroundView.backgroundColor = .appColor(.ppsGray3)
        
        roundedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalTo(contentView).inset(20)
            make.height.equalTo(56)
        }
    }
    
    func setupLabels() {
        
        let separater1 = UIView()
        let separater2 = UIView()
        let separater3 = UIView()
        
        separater1.backgroundColor = .appColor(.ppsGray2)
        separater2.backgroundColor = .appColor(.ppsGray2)
        separater3.backgroundColor = .appColor(.ppsGray2)
        
        roundedBackgroundView.addSubview(attendanceCountLabel)
        roundedBackgroundView.addSubview(separater1)
        roundedBackgroundView.addSubview(latenessCountLabel)
        roundedBackgroundView.addSubview(separater2)
        roundedBackgroundView.addSubview(absenceCountLabel)
        roundedBackgroundView.addSubview(separater3)
        roundedBackgroundView.addSubview(allowedCountLabel)
        roundedBackgroundView.addSubview(fineLabel)
        
        attendanceCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(roundedBackgroundView).offset(14)
        }
        separater1.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(attendanceCountLabel.snp.trailing).offset(6)
        }
        latenessCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater1.snp.trailing).offset(6)
        }
        separater2.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(latenessCountLabel.snp.trailing).offset(6)
        }
        absenceCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater2.snp.trailing).offset(6)
        }
        separater3.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(absenceCountLabel.snp.trailing).offset(6)
        }
        allowedCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater3.snp.trailing).offset(6)
        }
        
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.trailing.equalTo(roundedBackgroundView.snp.trailing).inset(14)
        }
    }
}

final class AttendanceTableViewDayCell: UITableViewCell {
    
    // MARK: - Properties    
    private let dayLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 16, isBold: true)
    private let timeLabel = CustomLabel(title: "", tintColor: .ppsGray2, size: 12)
    private let attendanceCapsuleView = AttendanceStatusCapsuleView(color: .attendedMain)
    private let fineLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 18, isBold: true)
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure
    
    internal func configureCell(with attendance: OneTimeAttendanceInformation) {
        let dayAndTime = DateFormatter.dayAndTimeFormatter.string(from: attendance.studyScheduleDateAndTime)
        let day = String(dayAndTime.prefix(2))
        
        let timeFirstIndex = dayAndTime.index(dayAndTime.endIndex, offsetBy: -5)
        let time = String(dayAndTime[timeFirstIndex...])
        
        let fine = attendance.fine?.toString() ?? "?"
        
        dayLabel.text = day + "일"
        timeLabel.text = time
        fineLabel.text = fine
        
        configureAttendanceLabel(with: attendance)
    }
    
    private func configureAttendanceLabel(with attendance: OneTimeAttendanceInformation) {
        switch attendance.attendanceStatus {
        case Constant.attendance:
            attendanceCapsuleView.configure(title: "출석", color: .attendedMain)
        case Constant.late:
            attendanceCapsuleView.configure(title: "지각", color: .attendedMain)
        case Constant.absent:
            attendanceCapsuleView.configure(title: "결석", color: .absentMain)
        case Constant.allowed:
            attendanceCapsuleView.configure(title: "사유", color: .allowedMain)
        default: break
        }
    }
    
    private func configureViews() {
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(attendanceCapsuleView)
        contentView.addSubview(fineLabel)
        contentView.addSubview(timeLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).inset(35)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel).offset(2)
            make.leading.equalTo(dayLabel.snp.trailing).offset(10)
        }
        attendanceCapsuleView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(contentView).offset(46)
            make.width.equalTo(32)
            make.height.equalTo(16)
        }
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(35)
        }
    }
}

final class MonthlyHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    private let monthLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 12, isBold: true)
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(monthLabel)
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(35)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureCell(with month: String) {
        monthLabel.text = month + "월"
    }
}

final class MonthlyFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private let separatebar = UIView()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(separatebar)
        
        separatebar.backgroundColor = .appColor(.ppsGray2)
        
        separatebar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(10)
            make.height.equalTo(1)
            make.centerY.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
