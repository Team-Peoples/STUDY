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

//    internal var viewModel: AttendancesModificationViewModel?
    internal var indexPath: IndexPath?
    private lazy var bottomView = viewType?.view
    
    internal var viewType: AttendanceBottomViewType! {
        didSet {
            
            bottomView?.navigatable = self
            
            switch viewType {
            case .daySearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomDaySearchSettingView else { return }
                
//                bottomView.viewModel = viewModel
                
            case .membersPeriodSearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomMembersPeriodSearchSettingView else { return }
                
                bottomView.dateLabelUpdatableDelegate = self
                
            case .individualPeriodSearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomIndividualPeriodSearchSettingView else { return }
                
                bottomView.dateLabelUpdatableDelegate = self
                
            case .individualUpdate:
                guard let bottomView = bottomView as? AttendanceBottomIndividualUpdateView, let indexPath = indexPath else { return }
                
//                bottomView.viewModel = viewModel
                bottomView.indexPath = indexPath
                
            default: break
            }
            
            view = bottomView
        }
    }
    
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
}

extension AttendanceBottomViewController: DateLabelUpdatable {
    internal func updateDateLabels(preceding: Date, following: Date) {
        precedingDate = preceding
        followingDate = following
    }
}

