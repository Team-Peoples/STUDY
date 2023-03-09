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
    
    internal var viewModel: AttendancesModificationViewModel? {
        didSet {
            setBinding()
        }
    }
    
    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "AttendanceModificationHeaderView", bundle: nil)
    }
    
    private func setBinding() {
        viewModel?.alignment.bind({ leftButtonAlignment in
            self.sortingTypeLabel.text = leftButtonAlignment.rawValue
        })
        viewModel?.selectedTime.bind { time in
            self.studyTimeLabel.text = time
        }
    }
    
    internal func configureRightButtonTitle(_ date: DashedDate) {
        rightButton.setTitle(date, for: .normal)
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        let bottomVC = AttendanceBottomViewController()
        
//        bottomVC.viewModel = viewModel
        bottomVC.viewType = .daySearchSetting
        
        navigatableBottomSheetableDelegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        
        let vc = AttendancePopUpDayCalendarViewController(presentingVC: navigatableBottomSheetableDelegate, viewModel: viewModel)
        navigatableBottomSheetableDelegate.present(vc)
    }
}
