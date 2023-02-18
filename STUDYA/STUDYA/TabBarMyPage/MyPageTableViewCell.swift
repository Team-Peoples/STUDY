//
//  MyPageTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/22.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    
    private let titles = ["참여한 스터디", "푸시알림 설정", "앱 정보"]
    internal var row: Int? {
        didSet {
            switch row {
            case 0:
                titleLabel.text = titles[row ?? 0]
                iconImageView.image = UIImage(named: "myStudyList")
            case 1:
                titleLabel.text = titles[row ?? 1]
                iconImageView.image = UIImage(named: "alertSetting")
            case 2:
                titleLabel.text = titles[row ?? 2]
                iconImageView.image = UIImage(named: "appInformation")
            default: break
            }
        }
    }
    
    private let iconImageView = UIImageView(frame: .zero)
    private let titleLabel = CustomLabel(title: "제목", tintColor: .ppsGray1, size: 16, isBold: true, isNecessaryTitle: false)
    private let disclosureIndicator = UIImageView(image: UIImage(named: "disclosureIndicator")?.withRenderingMode(.alwaysTemplate))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(disclosureIndicator)
    }
    
    private func configure() {
        iconImageView.layer.cornerRadius = 12.5
        iconImageView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        disclosureIndicator.tintColor = UIColor.appColor(.ppsGray1)
    }
    
    private func setConstraints() {
        iconImageView.anchor(leading: self.leadingAnchor, leadingConstant: 28, width: 25, height: 25)
        iconImageView.centerY(inView: self)
        titleLabel.anchor(leading: iconImageView.trailingAnchor, leadingConstant: 22)
        titleLabel.centerY(inView: self)
        disclosureIndicator.anchor(trailing: self.trailingAnchor, trailingConstant: 28, width: 25, height: 25)
        disclosureIndicator.centerY(inView: self)
    }
}
