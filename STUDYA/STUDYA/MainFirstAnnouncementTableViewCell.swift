//
//  MainFirstAnnouncementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit
import MarqueeLabel

class MainFirstAnnouncementTableViewCell: UITableViewCell {
    
    internal var title = "🔥나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다 나는 천재다⚡️"
    
    private lazy var announceLabel = MarqueeLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.appColor(.ppsGray2)
        
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
}
