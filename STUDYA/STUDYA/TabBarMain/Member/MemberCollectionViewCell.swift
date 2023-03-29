//
//  MemberCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MemberCollectionViewCell"
    
    internal var member: Member?
    
    internal var profileViewTapped: ((Member) -> ()) = { _ in }
    
    private lazy var profileImageView = ProfileImageContainerView(internalImageSize: 72)
    private lazy var nickNameLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 12, isBold: true)
    private let button = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.hideMarks()
    }
    
    @objc private func profileImageTapped() {
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        guard isSwitchOn, let member = member else { return }
        profileViewTapped(member)
    }
    
    private func configureView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(recognizer)
        
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(button)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(2)
            make.centerX.equalTo(contentView)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.centerX.equalTo(contentView)
        }
        button.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).inset(30)
        }
    }
    
    internal func configureCell(with member: Member) {
        self.member = member

        profileImageView.configure(imageURL: member.profileImageURL, isManager: member.isManager, role: member.role)
        nickNameLabel.text = member.nickName
    }
}
