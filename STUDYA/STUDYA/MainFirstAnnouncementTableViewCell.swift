//
//  MainFirstAnnouncementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit
import MarqueeLabel

class MainFirstAnnouncementTableViewCell: UITableViewCell {
    
    static let identifier = "MainFirstAnnouncementTableViewCell"
    internal var title = "🔥나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다⚡️"
    
    private lazy var announceLabel = MarqueeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.appColor(.ppsGray2)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        
        announceLabel.text = title
        announceLabel.type = .continuous
        announceLabel.speed = .duration(10)
        announceLabel.textAlignment = .left
        announceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        announceLabel.fadeLength = 30
        announceLabel.leadingBuffer = 10
        announceLabel.trailingBuffer = 10
        
        addSubview(announceLabel)
        announceLabel.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
