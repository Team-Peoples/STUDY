//
//  AttendanceBottomViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/21.
//

import UIKit
import SnapKit

final class AttendanceBottomViewController: UIViewController {

    internal let times = ["99:99", "15:00", "19:15", "11:11", "15:00", "19:15"]
    
    internal lazy var precedingDate = Date() {
        didSet { (bottomView as? AttendanceBottomMembersPeriodSearchSettingView)?.setPrecedingDateLabel(with: precedingDate) } }
    internal lazy var followingDate = Date() {
        didSet { (bottomView as? AttendanceBottomMembersPeriodSearchSettingView)?.setFollowingDateLabel(with: followingDate) }
    }
    
    internal  var viewType: AttendanceBottomViewType! {
        didSet {
            switch viewType {
            case .daySearchSetting:
                (bottomView as! AttendanceBottomDaySearchSettingView).delegate = self
            case .membersPeriodSearchSetting:
                (bottomView as! AttendanceBottomMembersPeriodSearchSettingView).delegate = self
            default: break
            }
            
            view = bottomView
        }
    }
    private lazy var bottomView = viewType!.view
    
//    private lazy var attendanceBottomDaySearchSettingView = AttendanceBottomDaySearchSettingView(doneButtonTitle: "조회")
//    private lazy var attendanceBottomIndividualUpdateViwe = AttendanceBottomIndividualUpdateView(doneButtonTitle: "완료")
//    private lazy var attendanceBottomMembersPeriodSearchSettingView = AttendanceBottomMembersPeriodSearchSettingView(doneButtonTitle: "조회")
//    private lazy var attendanceBottomIndividualPeriodSearchSettingView = AttendanceBottomIndividualPeriodSearchSettingView(doneButtonTitle: "조회")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    internal func setDateLabels(preceding: Date, following: Date) {
        precedingDate = preceding
        followingDate = following   
    }
}

extension AttendanceBottomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceTimeCollectionViewCell.identifier, for: indexPath) as! AttendanceTimeCollectionViewCell
        
        cell.time = times[indexPath.item]
        
        return cell
    }
}

extension AttendanceBottomViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AttendanceTimeCollectionViewCell
        cell.enableButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AttendanceTimeCollectionViewCell
        cell.disableButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        let leftRightInsets:CGFloat = 48
        
        label.text = times[indexPath.item]
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + leftRightInsets, height: 32)
    }
}
