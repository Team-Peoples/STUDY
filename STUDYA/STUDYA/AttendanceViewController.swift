//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: SwitchableViewController, BottomSheetAddable {
    
    internal var studyID: ID? {
        didSet {
            guard let studyID = studyID else { return }
            managerView.studyID = studyID
            viewModel = AttendancesModificationViewModel(studyID: studyID)
        }
    }
    internal var viewModel: AttendancesModificationViewModel?
    
    private lazy var managerView: AttendanceManagerModeView = {
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        guard let v = nib.instantiate(withOwner: AttendanceViewController.self).first as? AttendanceManagerModeView else {
            return AttendanceManagerModeView()
        }
        
        return v
    }()
    let userView = OneMemberAttendanceView(viewer: .user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isManager {
            managerView.delegate = self
        }
        userView.bottomSheetAddableDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    override func extraWorkWhenSwitchToggled() {
        view = isSwitchOn ? managerView : userView
    }
}

class AttendanceViewModel {
    
    let studyID: ID
    
    var myAttendanceOverall: Observable<MyAttendanceOverall>
    var allUsersAttendacneForADay: Observable<AllUsersAttendacneForADay>?
    var error: Observable<PeoplesError>?
    
    var monthlyGroupedDates: [String: [Date]] = [:]
    
    init(studyID: ID, myAttendanceOverall: MyAttendanceOverall, allUsersAttendacneForADay: AllUsersAttendacneForADay?) {
        self.studyID = studyID
        self.myAttendanceOverall = Observable(myAttendanceOverall)
        
        if let allUsersAttendacneForADay = allUsersAttendacneForADay {
            self.allUsersAttendacneForADay = Observable(allUsersAttendacneForADay)
        }
    }
    
    func getMyAttendanceOverall() {
        
        let today = Date()
        let dashedToday = today.formatToString(format: .dashedFormat)
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let dashedThirtyDaysAgo = thirtyDaysAgo?.formatToString(format: .dashedFormat) ?? dashedToday

        Network.shared.getMyAttendanceBetween(start: dashedThirtyDaysAgo, end: dashedToday, studyID: studyID) { result in
            switch result {
            case .success(let attendanceOverall):
                self.myAttendanceOverall = Observable(attendanceOverall)
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
    
//    func getAllMembersAttendances() {
//        let formatter = DateFormatter.dashedDateFormatter
//        let today = Date()
//        let dashedToday = formatter.string(from: today)
//
//        Network.shared.getAllMembersAttendanceOn(dashedToday, studyID: studyID) { result in
//            switch result {
//            case .success(let allUsersAttendancesForADay):
//                self.allUsersAttendancesForADay = Observable(allUsersAttendancesForADay)
//                self.seperateAllDaysByMonth()
//            case .failure(let error):
//                self.error = Observable(error)
//            }
//        }
//    }
    
    func seperateAllDaysByMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        
        let datas: [OneTimeAttendanceInformation] = myAttendanceOverall.value.oneTimeAttendanceInformation
        var dates: [Date] = []
        
        datas.forEach { oneTimeAttendanceInfo in
            let studyScheduleDate = oneTimeAttendanceInfo.studyScheduleDateAndTime
            dates.append(studyScheduleDate)
        }
        
        dates.forEach { date in
            let monthAndYear = dateFormatter.string(from: date)
            if monthlyGroupedDates[monthAndYear] == nil {
                monthlyGroupedDates[monthAndYear] = []
            }
            monthlyGroupedDates[monthAndYear]?.append(date)
        }
    }
}
