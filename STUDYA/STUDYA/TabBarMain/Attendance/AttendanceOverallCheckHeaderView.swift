//
//  AttendanceOverallCheckHeaderView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/20.
//

import UIKit

final class AttendanceOverallCheckHeaderView: UIView {
    
    static let identifier = "AttendanceOverallCheckHeaderView"
    
//    internal var navigatableBottomSheetableDelegate: (BottomSheetAddable & Navigatable)!
    internal var toggleAlignment: (() -> Void) = {}
    
    @IBOutlet private weak var sortyingTypeLabel: UILabel!
//    @IBOutlet private weak var periodLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "AttendanceOverallCheckHeaderView", bundle: nil)
    }
    
    @IBAction private func tapped() {
        print(#function)
        toggleAlignment()
//        buttonTappedAction()
        
//        let bottomVC = AttendanceBottomViewController()
//        bottomVC.viewType = .membersPeriodSearchSetting
        
//        navigatableBottomSheetableDelegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
//        let borderColor = UIColor(red: 124/255, green: 179/255, blue: 244/255, alpha: 1)
//        button.addDashedBorder(color: borderColor, cornerRadius: 14)
    }
    
    internal func toggleSortyingTypeLabel(alignmet: LeftButtonAlignment) {
        sortyingTypeLabel.text = alignmet == .name ? "이름순" : "출석순"
    }
}
