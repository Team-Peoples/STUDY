//
//  AttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/21/22.
//

import UIKit

class AttendanceUserView: UIView {
    
    var type: AttendanceViewType?
    
    // MARK: - Properties
    
    weak var bottomSheetAddableDelegate: BottomSheetAddable?
    
    lazy var attendanceStatusView = type == .userMode ? AttendanceUserModeStatusView() : AttendanceUserDetailStatusView()
    let attendanceDetailsTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Initialization
    
    init(type: AttendanceViewType) {
        self.type = type
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(attendanceStatusView)
        self.addSubview(attendanceDetailsTableView)
        
        attendanceDetailsTableView.separatorStyle = .none
        attendanceDetailsTableView.backgroundColor = .white
        attendanceDetailsTableView.delegate = self
        attendanceDetailsTableView.dataSource = self
        
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
        }
        attendanceDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(attendanceStatusView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}


// MARK: UITableViewDataSource

extension AttendanceUserView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
            case 0:
                return 0
            default:
                return 30
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            case 0:
                let headerView = UIView()
                headerView.backgroundColor = .appColor(.background)
                return headerView
            default:
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.reusableMonthlyHeaderView.identifier) as! MonthlyHeaderView
                return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
            case 0:
                return nil
            default:
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.reusableMonthlyFooterView.identifier) as! MonthlyFooterView
                return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            default:
                return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let attendanceTableViewDetailsCell = tableView.dequeueReusableCell(withIdentifier: ReusableView.reusableDetailsCell.identifier, for: indexPath)
                as! AttendanceDetailsCell
                
                if attendanceTableViewDetailsCell.bottomSheetAddableDelegate == nil {
                    attendanceTableViewDetailsCell.bottomSheetAddableDelegate = bottomSheetAddableDelegate
                }
                
                return attendanceTableViewDetailsCell
            default:
                let dayCell = tableView.dequeueReusableCell(withIdentifier: ReusableView.reusableDayCell.identifier, for: indexPath)
                as! AttendanceTableViewDayCell
                
                dayCell.attendance = "출석"
                return dayCell
        }
    }
}
extension AttendanceUserView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
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


