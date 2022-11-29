//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: UIViewController, BottomSheetAddable {

    var dailyStudyAttendance: [String: Int] = ["출석": 60, "지각": 15, "결석": 3, "사유": 5] {
        didSet {

        }
    }
    
    let managerView: AttendanceManagerModeView = {
       
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        let v = nib.instantiate(withOwner: AttendanceViewController.self).first as! AttendanceManagerModeView
        
        return v
    }()
    let userView = AttendanceUserView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerView.BottomSheetAddableDelegate = self
        userView.bottomSheetAddableDelegate = self
    
        view = managerView
//        view = userView
    }
}
