//
//  AttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/21/22.
//

import UIKit

class AttendanceForAMemberViewModel {
    var studyID: ID
    var userID: UserID
    
    var attendanceOverall: UserAttendanceOverall?
    var yearAndMonthOfAttendances: [DashedDate] = []
    var monthlyGroupedAttendanceInformation: [DashedDate: [OneTimeAttendanceInformation]] = [:]
    var error: Observable<PeoplesError>?
    var reloadTable: Observable<Bool> = Observable(false)
    
    init(studyID: Int, userID: UserID) {
        self.studyID = studyID
        self.userID = userID
    }
    
    func getUserAttendanceOverall(between startDate: DashedDate, and endDate: DashedDate) {
        Network.shared.getUserAttendanceBetween(start: startDate, end: endDate, studyID: studyID, userID: userID) { result in
            switch result {
            case .success(let attendanceOverall):
                self.attendanceOverall = attendanceOverall
                self.seperateAllUserAttendancesByMonth(attendances: attendanceOverall)
                
                self.reloadTable.value = true
                
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
    
    func seperateAllUserAttendancesByMonth(attendances: UserAttendanceOverall) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"

        let oneTimeAttendanceInformations: [OneTimeAttendanceInformation] = attendances.oneTimeAttendanceInformations
        var yearAndMonthOfAttendances: [DashedDate] = []
        
        oneTimeAttendanceInformations.forEach { oneTimeAttendance in
            let studyScheduleDate = oneTimeAttendance.studyScheduleDateAndTime
            let monthAndYearOfStudySchedule = dateFormatter.string(from: studyScheduleDate)
            
            if monthlyGroupedAttendanceInformation[monthAndYearOfStudySchedule] == nil {
                monthlyGroupedAttendanceInformation[monthAndYearOfStudySchedule] = []
            }
            
            monthlyGroupedAttendanceInformation[monthAndYearOfStudySchedule]?.append(oneTimeAttendance)
            yearAndMonthOfAttendances.append(monthAndYearOfStudySchedule)
        }
        self.yearAndMonthOfAttendances = removeDuplication(in: yearAndMonthOfAttendances)
    }
    
    func removeDuplication(in array: [String]) -> [String]{
        let set = Set(array)
        let duplicationRemovedArray = Array(set)
        
        return duplicationRemovedArray.sorted()
    }
}

class AttendanceForAMemberView: UIView {
    
    enum Viewer {
        case manager
        case user
    }
    
    var viewer: Viewer
    var viewModel: AttendanceForAMemberViewModel? {
        didSet {
            setBinding()
            
            if viewer == .user {
                let today = Date()
                let dashedToday = DateFormatter.dashedDateFormatter.string(from: today)
                let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
                let dashedThirtyDaysAgo = DateFormatter.dashedDateFormatter.string(from: thirtyDaysAgo ?? today)
                
                viewModel?.getUserAttendanceOverall(between: dashedThirtyDaysAgo, and: dashedToday)
            }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: (BottomSheetAddable & Navigatable)?
    
    lazy var oneMemberAttendanceHeaderView: UIView = {
        switch self.viewer {
        case .user:
            let headerView = MyAttendanceStatusView()
//            headerView.attendanceOverall = viewModel?.attendanceOverall   🛑api 변경후 다시보자
            
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
        guard let viewModel = viewModel else { return }
        viewModel.reloadTable.bind({ _ in
            self.attendanceDetailsTableView.reloadData()
        })
        viewModel.error?.bind({ error in
            guard let delegate = self.delegate else { return }
            UIAlertController.handleCommonErros(presenter: delegate, error: error)
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
        guard let yearAndMonthsOfAttendances = viewModel?.yearAndMonthOfAttendances else { return 0 }
        
        let headerCount = 1
        return yearAndMonthsOfAttendances.count + headerCount
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
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AttendanceReusableView.reusableMonthlyHeaderView.identifier) as? MonthlyHeaderView,
                  let yearAndMonthOfAttendances = viewModel?.yearAndMonthOfAttendances else { return MonthlyHeaderView() }
            
            let month = String(yearAndMonthOfAttendances[section - 1].prefix(2))
            let monthForHeaderView = removeFirstZeroIfMonthNumberIsBelow10(month: month)
            
            headerView.month = Observable(monthForHeaderView)
            
            return headerView
        }
    }
    
    func removeFirstZeroIfMonthNumberIsBelow10(month: String) -> String {
        guard let intMonth = month.toInt() else { return "?" }
        
        if intMonth < 10 {
            return String(month.prefix(1))
        } else {
            return month
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
            
            let monthAndYear = viewModel.yearAndMonthOfAttendances[section - 1]
            guard let attendancesForAMonth = viewModel.monthlyGroupedAttendanceInformation[monthAndYear] else { return 0 }
            
            return attendancesForAMonth.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let attendanceTableViewDetailsCell = tableView.dequeueReusableCell(withIdentifier: AttendanceReusableView.reusableDetailsCell.identifier, for: indexPath)
                    as? AttendanceDetailsCell else { return  AttendanceDetailsCell() }
            
            attendanceTableViewDetailsCell.attendanceOverall = viewModel?.attendanceOverall
            
            if attendanceTableViewDetailsCell.bottomSheetAddableDelegate == nil {
                attendanceTableViewDetailsCell.bottomSheetAddableDelegate = delegate
            }
            
            return attendanceTableViewDetailsCell
        default:
            guard let dayCell = tableView.dequeueReusableCell(withIdentifier: AttendanceReusableView.reusableDayCell.identifier, for: indexPath)
                    as? AttendanceTableViewDayCell,
                  let yearAndMonth = viewModel?.yearAndMonthOfAttendances[indexPath.section - 1],
                  let attendanceInformationsInAMonth = viewModel?.monthlyGroupedAttendanceInformation[yearAndMonth] else { return AttendanceTableViewDayCell() }
            
            let attendanceForADay = attendanceInformationsInAMonth[indexPath.row]
            
            dayCell.attendance = attendanceForADay
            
            return dayCell
        }
    }
}
extension AttendanceForAMemberView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let delegate = delegate, viewer == .manager else { return }
//        guard let yearAndMonth = viewModel?.yearAndMonthOfAttendances[indexPath.section - 1],
//              let attendanceInformationsInAMonth = viewModel?.monthlyGroupedAttendanceInformation[yearAndMonth] else { return }
//
//        let attendanceForADay = attendanceInformationsInAMonth[indexPath.row]
//        delegate.presentBottomSheet(vc: <#T##UIViewController#>, detent: <#T##CGFloat#>, prefersGrabberVisible: <#T##Bool#>)
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
