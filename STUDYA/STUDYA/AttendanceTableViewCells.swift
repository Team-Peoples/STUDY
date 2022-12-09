//
//  AttendanceTableViewCells.swift
//  STUDYA
//
//  Created by 서동운 on 11/18/22.
//

import UIKit

class AttendanceDetailsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var bottomSheetAddableDelegate: BottomSheetAddable?
    var studyAttendance: [String: Int] = ["출석": 60,
                                          "지각": 15,
                                          "결석": 3,
                                          "사유": 5] {
        didSet {
        }
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(image: UIImage(named: "details")!, text: " 상세내역")
        return lbl
    }()
    private let periodSettingButton = BrandButton(title: "22.06.01~22.08.20", textColor: .ppsGray1, borderColor: .ppsGray2, backgroundColor: .systemBackground, fontSize: 14, height: 30)
    private let roundedBackgroundView = RoundableView(cornerRadius: 16)
    
    private let attendanceCountLabel = CustomLabel(title: "0", tintColor: .attendedMain, size: 14)
    private let latenessCountLabel = CustomLabel(title: "0", tintColor: .lateMain, size: 14)
    private let absenceCountLabel = CustomLabel(title: "0", tintColor: .absentMain, size: 14)
    private let allowedCountLabel = CustomLabel(title: "0", tintColor: .allowedMain, size: 14)
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(frontLabel: "벌금 ", labelFontSize: 12, value: 99999, valueFontSize: 18, valueTextColor: .ppsGray1, withCurrency: true)
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
        
        configure(studyAttendance)
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
    
    func configure(_ studyAttendance: [String: Int]) {
        
        attendanceCountLabel.text = "\(studyAttendance["출석"]!)"
        latenessCountLabel.text = "\(studyAttendance["지각"]!)"
        absenceCountLabel.text = "\(studyAttendance["결석"]!)"
        allowedCountLabel.text = "\(studyAttendance["사유"]!)"
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

class AttendanceTableViewDayCell: UITableViewCell {
    
    // MARK: - Properties
    
    var attendance: String? {
        didSet {
            guard let attendance = attendance else { return }
            
            attendanceLabel.text = attendance
            attendanceLabelBackgroundView.backgroundColor = AttendanceColor(rawValue: attendance)?.color
        }
    }
    
    private let dayLabel = CustomLabel(title: "01일", tintColor: .ppsBlack, size: 16, isBold: true)
    private let timeLabel = CustomLabel(title: "18:00", tintColor: .ppsGray2, size: 12)
    private let attendanceLabelBackgroundView = RoundableView(cornerRadius: 16 / 2)
    private lazy var attendanceLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 10)
    private let fineLabel = CustomLabel(title: "0", tintColor: .ppsGray1, size: 18)
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Actions
    
    // MARK: - Configure
    
    func configureViews() {
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(attendanceLabelBackgroundView)
        contentView.addSubview(fineLabel)
        contentView.addSubview(timeLabel)
        
        attendanceLabelBackgroundView.addSubview(attendanceLabel)
    }
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading).inset(35)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel).offset(2)
            make.leading.equalTo(dayLabel.snp.trailing).offset(10)
        }
        /// 캡슐 레이블로 나중에 수정하기
        attendanceLabelBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(dayLabel.snp.trailing).offset(130)
            make.height.equalTo(16)
            make.width.equalTo(32)
        }
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(35)
        }
        attendanceLabel.snp.makeConstraints { make in
            make.center.equalTo(attendanceLabelBackgroundView)
        }
    }
}

class MonthlyHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private let dayLabel = CustomLabel(title: "6월", tintColor: .ppsBlack, size: 12, isBold: true)
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(35)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MonthlyFooterView: UITableViewHeaderFooterView {
    
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
