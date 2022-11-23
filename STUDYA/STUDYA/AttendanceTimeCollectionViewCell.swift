//
//  AttendanceTimeCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/22.
//

import UIKit

final class AttendanceTimeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceTimeCollectionViewCell"
    
    internal var time: String? {
        didSet {
            timeButton.setTitle(time, for: .normal)
        }
    }
    
    private let timeButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsBlack, height: 36, normalBorderColor: .ppsGray2, normalTitle: "위위", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, contentEdgeInsets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        contentView.addSubview(timeButton)
        timeButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        print(#function)
    }
}
