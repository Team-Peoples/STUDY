//
//  AttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/21/22.
//

import UIKit

class AttendanceUserView: UIView {
    
    // MARK: - Properties
    
    let attendanceStatusView = AttendanceStatusReusableView()
    let attendanceDetailsTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(attendanceStatusView)
        self.addSubview(attendanceDetailsTableView)
        
        attendanceDetailsTableView.separatorStyle = .none
        attendanceDetailsTableView.backgroundColor = .white
        
        register()
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    
    // MARK: - Configure
    
    private func register() {
        attendanceDetailsTableView.register(AttendanceDetailsCell.self, forCellReuseIdentifier: ReusableView.reusableDetailsCell.identifier)
        attendanceDetailsTableView.register(AttendanceTableViewDayCell.self, forCellReuseIdentifier: ReusableView.reusableDayCell.identifier)
        attendanceDetailsTableView.register(MonthlyHeaderView.self, forHeaderFooterViewReuseIdentifier: ReusableView.reusableMonthlyHeaderView.identifier)
        attendanceDetailsTableView.register(MonthlyFooterView.self, forHeaderFooterViewReuseIdentifier: ReusableView.reusableMonthlyFooterView.identifier)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        attendanceStatusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        attendanceDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(attendanceStatusView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

enum ReusableView {
    case reusableDetailsCell
    case reusableDayCell
    case reusableMonthlyHeaderView
    case reusableMonthlyFooterView
    
    var identifier: String {
        get {
            switch self {
                case .reusableDetailsCell:
                    return "DetailsCell"
                case .reusableDayCell:
                    return "DayCell"
                case .reusableMonthlyHeaderView:
                    return "MonthlyHeaderView"
                case .reusableMonthlyFooterView:
                    return "MonthlyFooterView"
            }
        }
    }
}


