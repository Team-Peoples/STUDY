//
//  MainFourthManagementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit
import SnapKit

class MainFourthManagementTableViewCell: UITableViewCell {
    
    static let identifier = "MainFourthManagementTableViewCell"
    internal var navigatable: Navigatable!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .appColor(.background2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
