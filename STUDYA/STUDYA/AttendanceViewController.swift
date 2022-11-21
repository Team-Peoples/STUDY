//
//  AttendanceTableViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/17/22.
//

import UIKit
import MultiProgressView

private let reusableHeaderCellIdentifier = "HeaderCell"
private let reusablePeriodSelectableCellIdentifier = "HistoryCell"
private let reusableDayCellIdentifier = "DayCell"
private let reusableMonthlyHeaderViewIdentifier = "MonthlyHeaderView"
private let reusableMonthlyFooterViewIdentifier = "MonthlyFooterView"

class AttendanceViewController: UIViewController {
    
    // MARK: - Properties
    
    let attendanceTableView = UITableView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(attendanceTableView)
        attendanceTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        setupAttendanceTableView()
    }
    
    
    // MARK: - Configure
    
    private func setupAttendanceTableView() {
        attendanceTableView.register(AttendanceTableViewHeaderCell.self, forCellReuseIdentifier: reusableHeaderCellIdentifier)
        attendanceTableView.register(AttendanceTableViewPeriodSelectableCell.self, forCellReuseIdentifier: reusablePeriodSelectableCellIdentifier)
        attendanceTableView.register(AttendanceTableViewDayCell.self, forCellReuseIdentifier: reusableDayCellIdentifier)
    
        attendanceTableView.register(MonthlyHeaderView.self, forHeaderFooterViewReuseIdentifier: reusableMonthlyHeaderViewIdentifier)
        attendanceTableView.register(MonthlyFooterView.self, forHeaderFooterViewReuseIdentifier: reusableMonthlyFooterViewIdentifier)
        
        attendanceTableView.dataSource = self
        attendanceTableView.delegate = self
        attendanceTableView.separatorStyle = .none
    }
    
    // MARK: - Actions
    
}

// MARK: UITableViewDataSource

extension AttendanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == attendanceTableView {
            return 3
        } else {
            return 0
        }
    }
    
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == attendanceTableView {
            switch section {
                case 0:
                    return 0
                case 1:
                    return 0
                default:
                    return 30
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == attendanceTableView {
            switch section {
                case 0:
                    return 30
                case 1:
                    return 0
                default:
                    return 30
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 2:
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reusableMonthlyHeaderViewIdentifier) as! MonthlyHeaderView
                return headerView
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
            case 0:
                let footerView = UIView()
                footerView.backgroundColor = .appColor(.background)
                return footerView
            case 1,2:
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reusableMonthlyFooterViewIdentifier) as! MonthlyFooterView
                return footerView
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attendanceTableView {
            switch section {
                case 0:
                    return 1
                case 1:
                    return 1
                default:
                    return 3
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == attendanceTableView {
            switch indexPath.section {
                case 0:
                    let headerCell = tableView.dequeueReusableCell(withIdentifier: reusableHeaderCellIdentifier, for: indexPath) as! AttendanceTableViewHeaderCell
                    
                    return headerCell
                case 1:
                    let periodSelectableCell = tableView.dequeueReusableCell(withIdentifier: reusablePeriodSelectableCellIdentifier, for: indexPath)
                    as! AttendanceTableViewPeriodSelectableCell
                    
                    return periodSelectableCell
                default:
                    let dayCell = tableView.dequeueReusableCell(withIdentifier: reusableDayCellIdentifier, for: indexPath)
                    as! AttendanceTableViewDayCell
                    dayCell.attendance = "출석"
                    return dayCell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == attendanceTableView {
         
            switch indexPath.section {
                case 0:
                    return 200
                case 1:
                    return 150
                default:
                    return 40
            }
        } else {
           
            return 0
        }
    }
}

class MonthlyHeaderView: UITableViewHeaderFooterView {
    private let dayLabel = CustomLabel(title: "6월", tintColor: .ppsBlack, size: 12, isBold: true)
    
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
    
    private let separatebar = UIView()
    
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

