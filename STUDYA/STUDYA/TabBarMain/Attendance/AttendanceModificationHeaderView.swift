//
//  AttendanceModificationHeaderView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceModificationHeaderView: UIView {
    
    static let identifier = "AttendanceModificationHeaderView"
    
    internal weak var navigatableBottomSheetableDelegate: (BottomSheetAddable & Navigatable)?
    
    internal var leftButtonTapped: (() -> ()) = {}
    internal var rightButtonTapped: (() -> ()) = {}
    
    private weak var viewModel: AttendancesModificationViewModel?
    
    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "AttendanceModificationHeaderView", bundle: nil)
    }
    
    internal func configureViewWith(viewModel: AttendancesModificationViewModel) {
        self.viewModel = viewModel
        setBinding()
        
        rightButton.tintColor = .appColor(.ppsBlack)
        rightButton.semanticContentAttribute = .forceRightToLeft
        rightButton.configureBorder(color: .ppsGray2, width: 1, radius: 15)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        
    }
    
    private func setBinding() {
        viewModel?.selectedDate.bind({ [weak self] shortDottedDate in
            print(#function)
            self?.configureRightButtonTitle(shortDottedDate)
        })
        viewModel?.alignment.bind({ [weak self] leftButtonAlignment in
            self?.sortingTypeLabel.text = leftButtonAlignment.rawValue
        })
        viewModel?.selectedTime.bind { [weak self] time in
            if !time.isEmpty {
                self?.studyTimeLabel.text = "·" + time
            } else {
                self?.studyTimeLabel.text = ""
            }
        }
    }
    
    internal func configureRightButtonTitle(_ date: ShortenDottedDate) {
        rightButton.setTitle(date, for: .normal)
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        let bottomVC = AttendanceBottomDaySearchSettingViewController(doneButtonTitle: "조회")
        
        bottomVC.configureViewWith(viewModel: viewModel)
        
        navigatableBottomSheetableDelegate?.presentBottomSheet(vc: bottomVC, detent: 316, prefersGrabberVisible: false)
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel, let delegate = navigatableBottomSheetableDelegate else { return }
        
        let vc = AttendancePopUpDayCalendarViewController(presentingVC: delegate, viewModel: viewModel)
        delegate.present(vc)
    }
}
