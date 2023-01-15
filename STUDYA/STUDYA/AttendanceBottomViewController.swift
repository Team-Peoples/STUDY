//
//  AttendanceBottomViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/21.
//

import UIKit
import SnapKit

protocol DateLabelUpdatable: AnyObject {
    func updateDateLabels(preceding: Date, following: Date)
}

final class AttendanceBottomViewController: UIViewController, Navigatable {

    internal var viewModel: AttendancesModificationViewModel?
    
    internal lazy var precedingDate = Date() {
        didSet {
            if viewType == .membersPeriodSearchSetting {
                (bottomView as? AttendanceBottomMembersPeriodSearchSettingView)?.setPrecedingDateLabel(with: precedingDate)
            } else {
                (bottomView as? AttendanceBottomIndividualPeriodSearchSettingView)?.setPrecedingDateLabel(with: precedingDate)
            }
        }
    }
    internal lazy var followingDate = Date() {
        didSet {
            if viewType == . membersPeriodSearchSetting {
                (bottomView as? AttendanceBottomMembersPeriodSearchSettingView)?.setFollowingDateLabel(with: followingDate)
            } else {
                (bottomView as? AttendanceBottomIndividualPeriodSearchSettingView)?.setFollowingDateLabel(with: followingDate)
            }
        }
    }
    
    internal  var viewType: AttendanceBottomViewType! {
        didSet {
            switch viewType {
            case .daySearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomDaySearchSettingView else { return }
                bottomView.viewModel = viewModel
                bottomView.navigatable = self
                
            case .membersPeriodSearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomMembersPeriodSearchSettingView else { return }
                bottomView.navigatableDelegate = self
                bottomView.dateLabelUpdatableDelegate = self
            case .individualPeriodSearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomIndividualPeriodSearchSettingView else { return }
                bottomView.navigatableDelegate = self
                bottomView.dateLabelUpdatableDelegate = self
                
            default: break
            }
            
            view = bottomView
        }
    }
    private lazy var bottomView = viewType!.view
}

extension AttendanceBottomViewController: DateLabelUpdatable {
    internal func updateDateLabels(preceding: Date, following: Date) {
        precedingDate = preceding
        followingDate = following
    }
}
