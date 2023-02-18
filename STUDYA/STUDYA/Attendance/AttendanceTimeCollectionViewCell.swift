//
//  AttendanceTimeCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/22.
//

import UIKit

final class AttendanceTimeCollectionViewCell: UICollectionViewCell {
    
    internal var time: String? {
        didSet {
            button.setTitle(time, for: .normal)
        }
    }
    
    private let button = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "위위", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, contentEdgeInsets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.isUserInteractionEnabled = false
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func enableButton() {
        button.isSelected = true
    }
    
    internal func disableButton() {
        button.isSelected = false
    }
}
