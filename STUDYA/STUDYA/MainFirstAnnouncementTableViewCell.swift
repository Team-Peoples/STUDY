//
//  MainFirstAnnouncementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit

class MainFirstAnnouncementTableViewCell: UITableViewCell {
    
    static let identifier = "MainFirstAnnouncementTableViewCell"
    internal var title = "🔥나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다⚡️"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.appColor(.ppsGray2)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
