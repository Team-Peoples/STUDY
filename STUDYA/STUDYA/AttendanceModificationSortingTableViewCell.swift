//
//  AttendanceModificationSortingTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceModificationSortingTableViewCell: UITableViewCell {

    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        print(#function)
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        print(#function)
    }
}
