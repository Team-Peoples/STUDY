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

class AttendanceTableViewController: UITableViewController {
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 타이틀 + 총벌금 부터 progressView까지 재사용뷰 + 레이블들과 함께 셀
        tableView.register(AttendanceTableViewHeaderCell.self, forCellReuseIdentifier: reusableHeaderCellIdentifier)
        // 100/20/8/2 기간 선택 셀
        tableView.register(AttendanceTableViewPeriodSelectableCell.self, forCellReuseIdentifier: reusablePeriodSelectableCellIdentifier)
        // 개별날짜 셀
        tableView.register(AttendanceTableViewDayCell.self, forCellReuseIdentifier: reusableDayCellIdentifier)
        
//        // 헤더에 월
//        tableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
//
//        // 푸터에 구분선
//        tableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
}

// MARK: UITableViewDataSource

extension AttendanceTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            case 0:
                return 0
            case 1:
                return 0
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        switch section {
            case 0:
                return nil
            case 1:
                return nil
            default:
                return "6월"
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 170
            case 1:
                return 150
            default:
                return 40
        }
    }
}

class MonthlyHeaderView: UIView {
    
}

class MonthlyFooterView: UIView {
    
}

