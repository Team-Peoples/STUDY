//
//  MemberCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MemberCollectionViewCell"

    var member: Member? {
        didSet {
            
            profileView.configure(size: 72, image: member?.profileImage, isManager: member?.isManager ?? false, role: member?.role)
            nickNameLabel.text = member!.nickName
        }
    }
    
    private lazy var profileView = ProfileImageSelectorView(size: 72)
    private lazy var nickNameLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 12, isBold: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(profileView)
        contentView.addSubview(nickNameLabel)
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(40)
            make.centerX.equalTo(contentView)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.centerX.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileView.hideMarks()
    }
}
