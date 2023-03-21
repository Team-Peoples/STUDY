//
//  AttendanceBottomViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/21.
//

import UIKit
import SnapKit

protocol DateLabelUpdatable: AnyObject {
    func updateDateLabels(preceding: DottedDate, following: DottedDate)
}

final class AttendanceBottomViewController: UIViewController, Navigatable {

//    internal var viewModel: AttendancesModificationViewModel?
    internal var indexPath: IndexPath?
    private lazy var bottomView = viewType?.view
    
    internal var viewType: AttendanceBottomViewType! {
        didSet {
            
            bottomView?.navigatable = self
            
            switch viewType {
//            case .daySearchSetting:
//                guard let bottomView = bottomView as? AttendanceBottomDaySearchSettingView else { return }
                
//                bottomView.viewModel = viewModel
                
            case .membersPeriodSearchSetting:
                guard let bottomView = bottomView as? AttendanceBottomMembersPeriodSearchSettingView else { return }
                
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
    
    internal lazy var precedingDate = Date()
    internal lazy var followingDate = Date()
}

extension AttendanceBottomViewController: DateLabelUpdatable {
    func updateDateLabels(preceding: DottedDate, following: DottedDate) {
//        🛑구색 맞추기용 나중에 삭제해야
    }
}

