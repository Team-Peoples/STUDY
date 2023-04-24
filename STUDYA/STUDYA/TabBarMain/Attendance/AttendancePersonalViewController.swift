//
//  AttendancePersonalViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/10/22.
//

import UIKit

class AttendancePersonalViewController: SwitchableViewController, BottomSheetAddable {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = AttendanceForAMemberView(viewer: .manager)
        navigationController?.setupNavigationBarBackButtonDisplayMode()
    }
    
    internal func configureViewControllerWith(studyID: ID, stats: UserAttendanceStatistics) {
        let memberView = view as? AttendanceForAMemberView
        memberView?.delegate = self
        memberView?.configureViewWith(studyID: studyID, userID: stats.userID, stats: stats)
    }
}
