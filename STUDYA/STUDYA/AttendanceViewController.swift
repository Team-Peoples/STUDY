//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: SwitchableViewController, BottomSheetAddable {

    internal var dailyStudyAttendance: [String: Int] = ["출석": 60, "지각": 15, "결석": 3, "사유": 5] {
        didSet {

        }
    }
    
    private lazy var managerView: AttendanceManagerModeView = {
       
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        let v = nib.instantiate(withOwner: AttendanceViewController.self).first as! AttendanceManagerModeView
        
        return v
    }()
    let userView = AttendanceUserView(type: .userMode)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAdmin {
            managerView.BottomSheetAddableDelegate = self
        }
        userView.bottomSheetAddableDelegate = self
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        view = isSwitchOn ? managerView : userView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    override func extraWorkWhenSwitchToggled() {
        view = isSwitchOn ? managerView : userView
    }
}
