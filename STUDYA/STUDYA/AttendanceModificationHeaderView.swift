//
//  AttendanceModificationHeaderView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceModificationHeaderView: UIView {
    
    static let identifier = "AttendanceModificationHeaderView"
    
    internal var navigatableBottomSheetableDelegate: (BottomSheetAddable & Navigatable)!
    
    internal var leftButtonTapped: (() -> ()) = {}
    internal var rightButtonTapped: (() -> ()) = {}
    
    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "AttendanceModificationHeaderView", bundle: nil)
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        let bottomVC = AttendanceBottomViewController()
        
        bottomVC.viewType = .daySearchSetting
        navigatableBottomSheetableDelegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        print(#function)
        let vc = AttendancePopUpDayCalendarViewController()
        
        vc.presentingVC =  navigatableBottomSheetableDelegate
//        guard let delegate = navigatableBottomSheetableDelegate else { return }
//        print(delegate)
        navigatableBottomSheetableDelegate.present(vc: vc)
    }
}
