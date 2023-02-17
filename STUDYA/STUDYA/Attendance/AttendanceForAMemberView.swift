//
//  AttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/21/22.
//

import UIKit

class AttendanceForAMemberView: UIView {
    
    enum Viewer {
        case manager
        case user
    }
    
    var viewer: Viewer
    var viewModel: AttendanceViewModel?
    
    // MARK: - Properties
    
    weak var bottomSheetAddableDelegate: BottomSheetAddable?
    
    lazy var oneMemberAttendanceHeaderView: UIView = {
        switch self.viewer {
        case .user:
            let headerView = MyAttendanceStatusView()
            headerView.attendanceOverall = viewModel?.myAttendanceOverall
            
            return headerView
        case .manager:
            return AttendanceStatusWithProfileView()
        }
    }()
    let attendanceDetailsTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Initialization
    
    init(viewer: Viewer) {
        self.viewer = viewer
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(oneMemberAttendanceHeaderView)
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

    private func setBinding() {
        viewModel?.myAttendanceOverall.bind({ myAttendanceOverall in
            self.viewModel?.seperateAllDaysByMonth()
            self.attendanceDetailsTableView.reloadData()
        })
    }
    
    // MARK: - Configure
    
    private func register() {
        attendanceDetailsTableView.register(AttendanceDetailsCell.self, forCellReuseIdentifier: AttendanceReusableView.reusableDetailsCell.identifier)
        attendanceDetailsTableView.register(AttendanceTableViewDayCell.self, forCellReuseIdentifier: AttendanceReusableView.reusableDayCell.identifier)
        attendanceDetailsTableView.register(MonthlyHeaderView.self, forHeaderFooterViewReuseIdentifier: AttendanceReusableView.reusableMonthlyHeaderView.identifier)
        attendanceDetailsTableView.register(MonthlyFooterView.self, forHeaderFooterViewReuseIdentifier: AttendanceReusableView.reusableMonthlyFooterView.identifier)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        oneMemberAttendanceHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        attendanceDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(oneMemberAttendanceHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}


// MARK: UITableViewDataSource

extension AttendanceForAMemberView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        let headerCount = 1
        
        return viewModel.monthlyGroupedDates.keys.count + headerCount
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
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AttendanceReusableView.reusableMonthlyHeaderView.identifier) as! MonthlyHeaderView
                return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
            case 0:
                return nil
            default:
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AttendanceReusableView.reusableMonthlyFooterView.identifier) as! MonthlyFooterView
                return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            default:
            guard let viewModel = viewModel else { return 0 }
            
            let numberOfStudyDatesInAMonth = viewModel.monthlyGroupedDates.values.map { $0.count }
            
            return numberOfStudyDatesInAMonth[section - 1]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let attendanceTableViewDetailsCell = tableView.dequeueReusableCell(withIdentifier: AttendanceReusableView.reusableDetailsCell.identifier, for: indexPath)
                    as? AttendanceDetailsCell else { return  AttendanceDetailsCell() }
            
            if attendanceTableViewDetailsCell.bottomSheetAddableDelegate == nil {
                attendanceTableViewDetailsCell.bottomSheetAddableDelegate = bottomSheetAddableDelegate
            }
            
            return attendanceTableViewDetailsCell
        default:
            guard let dayCell = tableView.dequeueReusableCell(withIdentifier: AttendanceReusableView.reusableDayCell.identifier, for: indexPath)
                    as? AttendanceTableViewDayCell else { return AttendanceTableViewDayCell() }
            
            return dayCell
        }
    }
}
extension AttendanceForAMemberView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
}

enum AttendanceReusableView {
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
