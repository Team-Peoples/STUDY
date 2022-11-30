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
    
    internal  var viewType: AttendanceBottomViewType! {
        didSet {
            let bottomView = viewType!.view
            
            if viewType == .daySearchSetting {
                (bottomView as! AttendanceBottomDaySearchSettingView).delegate = self
            }
            view = bottomView
        }
    }
    
    private lazy var attendanceBottomDaySearchSettingView = AttendanceBottomDaySearchSettingView(doneButtonTitle: "조회")
    private lazy var attendanceBottomIndividualUpdateViwe = AttendanceBottomIndividualUpdateView(doneButtonTitle: "완료")
    private lazy var attendanceBottomMembersPeriodSearchSettingView = AttendanceBottomMembersPeriodSearchSettingView(doneButtonTitle: "조회")
    private lazy var attendanceBottomIndividualPeriodSearchSettingView = AttendanceBottomIndividualPeriodSearchSettingView(doneButtonTitle: "조회")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
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
