//
//  ExcommunicationRuleCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/02.
//

import UIKit

class ExcommunicationRuleCollectionViewCell: UICollectionViewCell {

    static let identifier = "ExcommunicationRuleCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("강퇴")
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
