//
//  InviteMemberCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class InviteMemberCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "InviteMemberCollectionViewCell"
    
    var inviteButtonAction: () -> Void = {}
    
    let buttonBackgroundView = UIImageView(image: UIImage(named: "inviteButton"))
    let button = UIButton(frame: .zero)
    let buttonTitleLabel = CustomLabel(title: "멤버 초대", tintColor: .ppsGray1, size: 12, isBold: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.addTarget(self, action: #selector(invite), for: .touchUpInside)
        
        contentView.addSubview(buttonBackgroundView)
        buttonBackgroundView.addSubview(buttonTitleLabel)
        contentView.addSubview(button)
        
        buttonBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        buttonTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonBackgroundView).inset(16)
            make.centerX.equalTo(buttonBackgroundView)
        }
        button.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func invite() {
        inviteButtonAction()
    }
}
