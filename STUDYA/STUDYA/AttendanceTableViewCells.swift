//
//  AttendanceTableViewCells.swift
//  STUDYA
//
//  Created by 서동운 on 11/18/22.
//

import UIKit

class AttendanceTableViewHeaderCell: UITableViewCell {
    
    // MARK: - Properties
    
    let statusView = AttendanceStatusReusableView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    // MARK: - Configure
    // MARK: - Setting Constraints
}

class AttendanceTableViewPeriodSelectableCell: UITableViewCell {
    
    // MARK: - Properties
    
    let mainView = AttendancePeriodSelectableView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    // MARK: - Configure
    // MARK: - Setting Constraints
}

class AttendanceTableViewDayCell: UITableViewCell {
    
    // MARK: - Properties
    
    enum AttendanceColor: String {
        case attendance = "출석"
        case lateness = "지각"
        case absence = "결석"
        case allow = "사유"
        
        var color: UIColor {
            switch self {
                case .attendance:
                    return .appColor(.attendedMain)
                case .lateness:
                    return .appColor(.lateMain)
                case .absence:
                    return .appColor(.absentMain)
                case .allow:
                    return .appColor(.allowedMain)
            }
        }
    }
    
    var attendance: String? {
        didSet {
            guard let attendance = attendance else { return }
            
            attendanceLabel.text = attendance
            attendanceLabelBackgroundView.backgroundColor = AttendanceColor(rawValue: attendance)?.color
        }
    }
    
    private let dayLabel = CustomLabel(title: "01일", tintColor: .ppsBlack, size: 16, isBold: true)
    private let attendanceLabelBackgroundView = RoundedView(cornerRadius: 16 / 2)
    private lazy var attendanceLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 10)
    private let fineLabel = CustomLabel(title: "0", tintColor: .ppsGray1, size: 18)
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading).inset(35)
        }
        
        contentView.addSubview(attendanceLabelBackgroundView)
        
        attendanceLabelBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(dayLabel.snp.trailing).offset(130)
            make.height.equalTo(16)
            make.width.equalTo(32)
        }
        
        contentView.addSubview(fineLabel)
        
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(35)
        }
        
        attendanceLabelBackgroundView.addSubview(attendanceLabel)
        
        attendanceLabel.snp.makeConstraints { make in
            make.center.equalTo(attendanceLabelBackgroundView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Actions
    // MARK: - Configure
    // MARK: - Setting Constraints
}
