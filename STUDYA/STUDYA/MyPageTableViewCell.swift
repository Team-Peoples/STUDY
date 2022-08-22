//
//  MyPageTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/22.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let circleView = UIView(frame: .zero)
    private lazy var titleLabel = CustomLabel(title: title ?? "제목", tintColor: .subTitleGeneral, size: 16, isBold: true, isNecessaryTitle: false)
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
        addSubview(circleView)
        addSubview(titleLabel)
        addSubview(disclosureIndicator)
    }
    
    private func configure() {
        circleView.layer.cornerRadius = 12.5
        circleView.backgroundColor = .systemGray
        disclosureIndicator.tintColor = UIColor.appColor(.subTitleGeneral)
    }
    
    private func setConstraints() {
        circleView.anchor(leading: self.leadingAnchor, leadingConstant: 28, width: 25, height: 25)
        circleView.centerY(inView: self)
        titleLabel.anchor(leading: circleView.trailingAnchor, leadingConstant: 22)
        titleLabel.centerY(inView: self)
        disclosureIndicator.anchor(trailing: self.trailingAnchor, trailingConstant: 28, width: 25, height: 25)
        disclosureIndicator.centerY(inView: self)
    }
}
