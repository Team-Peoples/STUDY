//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: SwitchableViewController, BottomSheetAddable {
    
    internal var viewModel: attendanceViewModel?
    
    private lazy var managerView: AttendanceManagerModeView = {
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        let v = nib.instantiate(withOwner: AttendanceViewController.self).first as! AttendanceManagerModeView
        
        return v
    }()
    let userView = AttendanceBasicModeView(viewer: .user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isManager {
            managerView.delegate = self
        }
        userView.bottomSheetAddableDelegate = self
        setUpBinding()
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
    
    private func setUpBinding() {

    }
}

struct Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    mutating func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

class attendanceViewModel {
    
    let studyID: ID
    var myAttendanceOverall: Observable<MyAttendanceOverall>
    var allUsersAttendacneForADay: Observable<AllUsersAttendacneForADay>?
    var error: Observable<PeoplesError>?
    
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
    
        Network.shared.getAllMembersAttendanceOn(dashedToday, studyID: studyID) { result in
            switch result {
            case .success(let allUsersAttendacneForADay):
                self.allUsersAttendacneForADay = Observable(allUsersAttendacneForADay)
                
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
}
