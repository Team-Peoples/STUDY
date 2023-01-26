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
            managerView.studyID = studyID
        }
    }
    
    private lazy var managerView: AttendanceManagerModeView = {
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        guard let v = nib.instantiate(withOwner: AttendanceViewController.self).first as? AttendanceManagerModeView else {
            return AttendanceManagerModeView()
        }
        
        return v
    }()
    let userView = OneMemberAttendanceView(viewer: .user)
    let noResultLabel = CustomLabel(title: "출결이 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isManager {
            managerView.delegate = self
        }
        userView.bottomSheetAddableDelegate = self
        
        NotificationCenter.default.addObserver(forName: .attendanceManagerTableViewsReloaded, object: self, queue: nil) { [weak self] noti in
            if let userinfo = noti.userInfo, let numOfMembers = userinfo["numberOfMembers"] as? Int {
                self?.noResultLabel.isHidden = numOfMembers == 0 ? false : true
            }
        }
        
        view.addSubview(noResultLabel)
        noResultLabel.centerXY(inView: view)
        noResultLabel.isHidden = true
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
    
        let formatter = DateFormatter.dashedDateFormatter
        let today = Date()
        let dashedToday = formatter.string(from: today)
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let dashedThirtyDaysAgo = formatter.string(from: thirtyDaysAgo ?? today)

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
            dates.append(oneTimeAttendanceInfo.studyScheduleDate)
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
