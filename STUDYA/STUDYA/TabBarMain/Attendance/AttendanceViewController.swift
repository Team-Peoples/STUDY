//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: SwitchableViewController, BottomSheetAddable {

    private lazy var managerView: AttendanceManagerModeView = {
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        guard let v = nib.instantiate(withOwner: AttendanceViewController.self).first as? AttendanceManagerModeView else {
            return AttendanceManagerModeView()
        }
        
        return v
    }()
    
    let userView = AttendanceForAMemberView(viewer: .user)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func extraWorkWhenSwitchToggled(isOn: Bool) {
        view = isOn ? managerView : userView
    }
    
    internal func configureViewController(with studyID: ID) {
        guard let userID = KeychainService.shared.read(key: Constant.userId) else { return }
        
        userView.delegate = self
        userView.configureViewWith(studyID: studyID, userID: userID)
        
        guard isManager else { return }
        
        managerView.delegate = self
        managerView.configureViewWith(studyID: studyID)
    }
}
