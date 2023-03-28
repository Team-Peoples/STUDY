//
//  AttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/21/22.
//

import UIKit

class AttendanceForAMemberViewModel {
    private var userID: UserID
    fileprivate var studyID: ID
    internal var studyStartDate: Date?
    
    var precedingDate: Observable<ShortenDottedDate> = Observable(DateFormatter.dashedDateFormatter.string(from: Date()))
    var followingDate: Observable<ShortenDottedDate> = Observable(DateFormatter.dashedDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()))
    
    var attendanceOverall: UserAttendanceOverall?
    var yearAndMonthOfAttendances: [DashedDate] = []
    var monthlyGroupedAttendanceInformation: [DashedDate: [OneTimeAttendanceInformation]] = [:]
    var error: Observable<PeoplesError> = Observable(.noError)
    var reloadTable: Observable<Bool> = Observable(false)
    
    init(studyID: Int, userID: UserID) {
        self.studyID = studyID
        self.userID = userID
    }
    
    func getUserAttendanceOverall(between precedingDate: DashedDate, and followingDate: DashedDate) {
        
        Network.shared.getUserAttendanceBetween(preceding: precedingDate, following: followingDate, studyID: studyID, userID: userID) { result in
            switch result {
            case .success(let attendanceOverall):
                self.precedingDate.value = precedingDate.convertDashedDateToShortenDottedDate()
                self.followingDate.value = followingDate.convertDashedDateToShortenDottedDate()
                
                self.attendanceOverall = attendanceOverall
                self.seperateAllUserAttendancesByMonth(attendances: attendanceOverall)
                self.reloadTable.value = true
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getUserAttendanceOverallFromEndToEnd() {
        guard let studyStartDate = studyStartDate else { return }
        let dashedStudyStartDate = DateFormatter.dashedDateFormatter.string(from: studyStartDate)
        let dashedToday = DateFormatter.dashedDateFormatter.string(from: Date())
        
        Network.shared.getUserAttendanceBetween(preceding: dashedStudyStartDate, following: dashedToday, studyID: studyID, userID: userID) { result in
            switch result {
            case .success(let attendanceOverall):
                self.precedingDate.value = dashedStudyStartDate.convertDashedDateToShortenDottedDate()
                self.followingDate.value = dashedToday.convertDashedDateToShortenDottedDate()
                
                self.attendanceOverall = attendanceOverall
                self.seperateAllUserAttendancesByMonth(attendances: attendanceOverall)
                self.reloadTable.value = true
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getStartDateOfStudy() {
        Network.shared.getAllParticipatedStudies { result in
            switch result {
            case .success(let studyEndToEndInformations):
                let studyEndToEndInformation = studyEndToEndInformations.filter{ $0.studyID == self.studyID}.first
                self.studyStartDate = studyEndToEndInformation?.start
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func seperateAllUserAttendancesByMonth(attendances: UserAttendanceOverall) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"

        let oneTimeAttendanceInformations: [OneTimeAttendanceInformation] = attendances.oneTimeAttendanceInformations
        var yearAndMonthOfAttendances: [DashedDate] = []
        
        monthlyGroupedAttendanceInformation = [:]
        
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
    var viewModel: AttendanceForAMemberViewModel?
    
    // MARK: - Properties
    
    weak var delegate: (BottomSheetAddable & Navigatable)?
    
    lazy var oneMemberAttendanceHeaderView: UIView = {
        switch self.viewer {
        case .user:
            return MyAttendanceStatusView()
        case .manager:
            return AttendanceStatusWithProfileView()
        }
    }()
    let attendanceDetailsTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Initialization
    
    init(viewer: Viewer) {
        self.viewer = viewer
        
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    internal func configureViewWith(studyID: ID, userID: UserID, stats: UserAttendanceStatistics? = nil) {
        initViewModelWith(studyID: studyID, userID: userID)
        setBinding()
        configureView(with: stats)
    }
    
    private func initViewModelWith(studyID: ID, userID: UserID) {
        viewModel = AttendanceForAMemberViewModel(studyID: studyID, userID: userID)
        viewModel?.getStartDateOfStudy()
    }
    
    private func setBinding() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadTable.bind({ _ in
            self.attendanceDetailsTableView.reloadData()
        })
        viewModel.error.bind({ error in
            guard let delegate = self.delegate else { return }
            UIAlertController.handleCommonErros(presenter: delegate, error: error)
        })
    }
    
    private func configureView(with stats: UserAttendanceStatistics?) {
        if viewer == .user {
            configureHeaderViewWithAttendanceStats()
            reloadTableViewWithAttendanceDataFrom30DaysAgoToNow()
        } else {
            guard let stats = stats else { return }
            configureMemberHeaderView(with: stats)
            reloadTableViewWithAttendanceDataFrom30DaysAgoToNow()
        }
    }
    
    private func reloadTableViewWithAttendanceDataFrom30DaysAgoToNow() {
        let today = Date()
        let dashedToday = DateFormatter.dashedDateFormatter.string(from: today)
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let dashedThirtyDaysAgo = DateFormatter.dashedDateFormatter.string(from: thirtyDaysAgo ?? today)
        
        viewModel?.getUserAttendanceOverall(between: dashedThirtyDaysAgo, and: dashedToday)
    }
    
    private func configureHeaderViewWithAttendanceStats() {
        guard let headerView = oneMemberAttendanceHeaderView as? MyAttendanceStatusView else { return }
        headerView.navigatable = delegate
        headerView.getAttendanceStats(with: viewModel?.studyID)
    }
    
    private func configureMemberHeaderView(with stats: UserAttendanceStatistics) {
        guard let headerView = oneMemberAttendanceHeaderView as? AttendanceStatusWithProfileView else { return }
        headerView.configureViewWith(stats: stats)
    }
    
    private func configureViews() {
        configureAttendanceDetailsTableView()
        
        self.addSubview(oneMemberAttendanceHeaderView)
        self.addSubview(attendanceDetailsTableView)
        
        oneMemberAttendanceHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        attendanceDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(oneMemberAttendanceHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureAttendanceDetailsTableView() {
        attendanceDetailsTableView.separatorStyle = .none
        attendanceDetailsTableView.backgroundColor = .white
        attendanceDetailsTableView.delegate = self
        attendanceDetailsTableView.dataSource = self
        
        attendanceDetailsTableView.register(AttendanceDetailsCell.self, forCellReuseIdentifier: AttendanceReusableView.reusableDetailsCell.identifier)
        attendanceDetailsTableView.register(AttendanceTableViewDayCell.self, forCellReuseIdentifier: AttendanceReusableView.reusableDayCell.identifier)
        attendanceDetailsTableView.register(MonthlyHeaderView.self, forHeaderFooterViewReuseIdentifier: AttendanceReusableView.reusableMonthlyHeaderView.identifier)
        attendanceDetailsTableView.register(MonthlyFooterView.self, forHeaderFooterViewReuseIdentifier: AttendanceReusableView.reusableMonthlyFooterView.identifier)
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
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AttendanceReusableView.reusableMonthlyHeaderView.identifier) as? MonthlyHeaderView else { return MonthlyHeaderView() }
            
            let month = getMonthNumberString(section: section)
            headerView.configureCell(with: month)
            
            return headerView
        }
    }
    
    private func getMonthNumberString(section: Int) -> String {
        guard let yearAndMonthOfAttendances = viewModel?.yearAndMonthOfAttendances else { return "?" }
        
        let month = String(yearAndMonthOfAttendances[section - 1].prefix(2))
        let monthForHeaderView = removeFirstZeroIfMonthNumberIsBelow10(month: month)
        
        return monthForHeaderView
    }
    
    func removeFirstZeroIfMonthNumberIsBelow10(month: String) -> String {
        guard let intMonth = month.toInt() else { return "?" }
        return intMonth.toString()
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
                    as? AttendanceDetailsCell,
                  let viewModel = viewModel else { return  AttendanceDetailsCell() }
            
            attendanceTableViewDetailsCell.bottomSheetAddableDelegate = delegate
            attendanceTableViewDetailsCell.configureCell(with: viewModel)
            
            return attendanceTableViewDetailsCell
        default:
            guard let dayCell = tableView.dequeueReusableCell(withIdentifier: AttendanceReusableView.reusableDayCell.identifier, for: indexPath)
                    as? AttendanceTableViewDayCell,
                  let yearAndMonth = viewModel?.yearAndMonthOfAttendances[indexPath.section - 1],
                  let attendanceInformationsInAMonth = viewModel?.monthlyGroupedAttendanceInformation[yearAndMonth] else { return AttendanceTableViewDayCell() }
            
            let attendanceForADay = attendanceInformationsInAMonth[indexPath.row]
            
            dayCell.configureCell(with: attendanceForADay)
            
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
//
//struct DateStorage {
//    internal var date: Observable<Date>
//    
//    internal var DottedDate: DottedDate {
//        DateFormatter.dottedDateFormatter.string(from: date.value)
//    }
//    internal var shortenDottedDate: ShortenDottedDate {
//        DateFormatter.shortenDottedDateFormatter.string(from: date.value)
//    }
//    internal var dashedDate: DashedDate {
//        DateFormatter.dashedDateFormatter.string(from: date.value)
//    }
//    
//    init(date: Date) {
//        self.date = Observable(date)
//    }
//    
//    mutating func changeDate(to date: Date) {
//        self.date.value = date
//    }
//    
//    mutating func changeDateTo(shortenDottedDate: ShortenDottedDate) {
//        guard let date = DateFormatter.shortenDottedDateFormatter.date(from: shortenDottedDate) else { return }
//        self.date.value = date
//    }
//    
//    mutating func changeDateTo(dottedDate: DottedDate) {
//        guard let date = DateFormatter.dottedDateFormatter.date(from: dottedDate) else { return }
//        self.date.value = date
//    }
//}
