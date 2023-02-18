//
//  MainSpreadUpTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/23.
//

import UIKit

class MainSpreadUpTableViewCell: UITableViewCell {

    internal var row = 0 {
        didSet {
            switch row {
            case 0:
                titleLabel.text = "공지 만들기"
                iconImageView.image = UIImage(named: "createAnnouncement")
            case 1:
                titleLabel.text = "일정 만들기"
                iconImageView.image = UIImage(named: "createSchedule")
            default:
                break
            }
        }
    }

    private let containerView: RoundableView = {
       
        let v = RoundableView(cornerRadius: 25)
        v.backgroundColor = .appColor(.background)
        v.layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 10, spread: 0)
        
        return v
    }()
    private lazy var titleLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 18, isBold: true)
    private lazy var iconImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        iconImageView.backgroundColor = .black
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(containerView).inset(15)
        }
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(15)
            make.top.trailing.bottom.equalTo(containerView).inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
