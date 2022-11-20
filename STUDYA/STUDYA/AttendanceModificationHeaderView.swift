//
//  AttendanceModificationHeaderView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceModificationHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "AttendanceModificationHeaderView"
    
    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "AttendanceModificationHeaderView", bundle: nil)
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        print(#function)
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        print(#function)
    }
}
