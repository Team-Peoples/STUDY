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
            guard let studyID = studyID, let userID = KeyChain.read(key: Constant.userId) else { return }
            
            userView.viewModel = AttendanceForAMemberViewModel(studyID: studyID, userID: userID)
            
//            managerView.studyID = studyID
//            viewModel = AttendancesModificationViewModel(studyID: studyID)
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
    let userView = AttendanceForAMemberView(viewer: .user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isManager {
            managerView.delegate = self
        }
        userView.delegate = self
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

//class AttendanceViewModel {
//    
//    let studyID: ID
//    
//    var myAttendanceOverall: Observable<UserAttendanceOverall>
//    var allUsersAttendanceForADay: Observable<AllUsersAttendanceForADay>?
//    var error: Observable<PeoplesError>?
//    
//    var monthlyGroupedDates: [String: [Date]] = [:]
//    
//    init(studyID: ID, myAttendanceOverall: MyAttendanceOverall, allUsersAttendanceForADay: AllUsersAttendanceForADay?) {
//        self.studyID = studyID
//        self.myAttendanceOverall = Observable(myAttendanceOverall)
//        
//        if let allUsersAttendanceForADay = allUsersAttendanceForADay {
//            self.allUsersAttendanceForADay = Observable(allUsersAttendanceForADay)
//        }
//    }
//    
//    func getMyAttendanceOverall() {
//        
//        let today = Date()
//        let dashedToday = DateFormatter.dashedDateFormatter.string(from: today)
//        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
//        let dashedThirtyDaysAgo = DateFormatter.dashedDateFormatter.string(from: thirtyDaysAgo ?? today)
//
//        Network.shared.getMyAttendanceBetween(start: dashedThirtyDaysAgo, end: dashedToday, studyID: studyID) { result in
//            switch result {
//            case .success(let attendanceOverall):
//                self.myAttendanceOverall = Observable(attendanceOverall)
//            case .failure(let error):
//                self.error = Observable(error)
//            }
//        }
//    }
//
//    func getAllMembersAttendances() {
//        let formatter = DateFormatter.dashedDateFormatter
//        let today = Date()
//        let dashedToday = formatter.string(from: today)
//
//        Network.shared.getAllMembersAttendanceOn(dashedToday, studyID: studyID) { result in
//            switch result {
//            case .success(let allUsersAttendancesForADay):
//                self.allUsersAttendanceForADay = Observable(allUsersAttendancesForADay)
//                self.seperateAllDaysByMonth()
//            case .failure(let error):
//                self.error = Observable(error)
//            }
//        }
//    }

//    func seperateAllDaysByMonth() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-yyyy"
//
//        let datas: [OneTimeAttendanceInformation] = myAttendanceOverall.value.oneTimeAttendanceInformations
//        var dates: [Date] = []
//
//        datas.forEach { oneTimeAttendanceInfo in
//            let studyScheduleDate = oneTimeAttendanceInfo.studyScheduleDateAndTime
//            dates.append(studyScheduleDate)
//        }
//
//        dates.forEach { date in
//            let monthAndYear = dateFormatter.string(from: date)
//            if monthlyGroupedDates[monthAndYear] == nil {
//                monthlyGroupedDates[monthAndYear] = []
//            }
//            monthlyGroupedDates[monthAndYear]?.append(date)
//        }
//    }
//}
