//
//  AttendancePersonalViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/10/22.
//

import UIKit

class AttendancePersonalViewController: SwitchableViewController, BottomSheetAddable {
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = AttendanceForAMemberView(viewer: .manager)
        navigationController?.setBrandNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    internal func configureViewControllerWith(studyID: ID, stats: UserAttendanceStatistics) {
        let memberView = view as? AttendanceForAMemberView
        memberView?.delegate = self
        memberView?.configureViewWith(studyID: studyID, userID: stats.userID, stats: stats)
    }
    
    // MARK: - Actions
    
    
    // MARK: - Configure
    
    private func configureViews() {
        
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
    }
}
