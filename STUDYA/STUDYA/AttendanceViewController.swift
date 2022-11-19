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
        
        //        // 헤더에 월
        //        tableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
        //        // 푸터에 구분선
        //        tableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
        
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
                    return 0
            }
        } else {
            return 0
        }
    }
    
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == attendanceTableView {
            switch section {
                case 0:
                    return nil
                case 1:
                    return nil
                default:
                    return "6월"
            }
        }
       else {
           return nil
       }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
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
                    return 170
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

class MonthlyHeaderView: UIView {
    
}

class MonthlyFooterView: UIView {
    
}

