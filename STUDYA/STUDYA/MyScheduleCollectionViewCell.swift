//
//  MyScheduleCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit

class MyScheduleCollectionViewCell: UICollectionViewCell {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .appColor(.background)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
