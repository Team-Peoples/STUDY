//
//  MainFourthManagementTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit
import SnapKit

class MainFourthManagementTableViewCell: UITableViewCell {
    
    var announcementButtonAction: () -> () = { }
    var informationButtonAction: () -> () = { }

    static let identifier = "MainFourthManagementTableViewCell"
    internal var delegate: Navigatable!
//    internal var hideTabBar: (() -> ())?
    
    private let attendanceBackView: UIView = {
        
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .systemBackground
        
        return v
    }()
    private let voteBackView: UIView = {
        
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .systemBackground
        
        return v
    }()
    private let beneathContainerView: UIView = {
        
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .systemBackground
        
        return v
    }()
    private let announcementBackView = UIView()
    private let memberBackView = UIView()
    private let informationBackView = UIView()
    
    private let attendanceImageView = UIImageView(image: UIImage(named: "attendance"))
    private let voteImageView = UIImageView(image: UIImage(named: "vote"))
    private let announcementImageView = UIImageView(image: UIImage(named: "announcement"))
    private let memberImageView = UIImageView(image: UIImage(named: "member"))
    private let informationImageView = UIImageView(image: UIImage(named: "information"))
    
    private let leftSeparatorView: UIView = {
       
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.background)
        
        return v
    }()
    private let rightSeparatorView: UIView = {
        
         let v = UIView()
         v.backgroundColor = UIColor.appColor(.background)
         
         return v
    }()
    
    private let attendanceLabel = CustomLabel(title: "출결", tintColor: .ppsGray1, size: 16, isBold: true)
    private let voteLabel = CustomLabel(title: "일정 투표", tintColor: .ppsGray1, size: 16, isBold: true)
    private let announcementLabel = CustomLabel(title: "공지", tintColor: .ppsGray1, size: 17, isBold: false)
    private let memberLabel = CustomLabel(title: "멤버", tintColor: .ppsGray1, size: 17, isBold: false)
    private let informationLabel = CustomLabel(title: "스터디 정보", tintColor: .ppsGray1, size: 17, isBold: false)
    
    private let attendanceButton = UIButton()
    private let voteButton = UIButton()
    private let announcementButton = UIButton()
    private let memberButton = UIButton()
    private let informationButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.appColor(.background)
        
        addSubviews()
        setConstraint()
        
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped(sender: UIButton) {
        switch sender.tag {
        case 1: break
        case 2: break
        case 3:
            announcementButtonAction()
        case 4:
            delegate.push(vc: MemberViewController())
//            hideTabBar!()
        case 5:
            informationButtonAction()
        default: break
        }
    }
    
    private func configureButtons() {
        attendanceButton.tag = 1
        voteButton.tag = 2
        announcementButton.tag = 3
        memberButton.tag = 4
        informationButton.tag = 5
        
        attendanceButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        voteButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        announcementButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        memberButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        informationButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        contentView.addSubview(attendanceBackView)
        contentView.addSubview(voteBackView)
        contentView.addSubview(beneathContainerView)
        
        attendanceBackView.addSubview(attendanceImageView)
        attendanceBackView.addSubview(attendanceLabel)
        attendanceBackView.addSubview(attendanceButton)
        
        voteBackView.addSubview(voteImageView)
        voteBackView.addSubview(voteLabel)
        voteBackView.addSubview(voteButton)
        
        beneathContainerView.addSubview(announcementBackView)
        beneathContainerView.addSubview(memberBackView)
        beneathContainerView.addSubview(informationBackView)
        beneathContainerView.addSubview(leftSeparatorView)
        beneathContainerView.addSubview(rightSeparatorView)
        
        announcementBackView.addSubview(announcementImageView)
        announcementBackView.addSubview(announcementLabel)
        announcementBackView.addSubview(announcementButton)
        
        memberBackView.addSubview(memberImageView)
        memberBackView.addSubview(memberLabel)
        memberBackView.addSubview(memberButton)
        
        informationBackView.addSubview(informationImageView)
        informationBackView.addSubview(informationLabel)
        informationBackView.addSubview(informationButton)
    }
    
    private func setConstraint() {
        attendanceBackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.leading.equalTo(contentView).inset(20)
            make.trailing.equalTo(voteBackView.snp.leading).offset(-20)
            make.height.equalTo(120)
            make.width.equalTo(voteBackView)
        }
        voteBackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(attendanceBackView)
            make.trailing.equalTo(self).inset(20)
        }
        beneathContainerView.anchor(top: attendanceBackView.bottomAnchor, topConstant: 10, bottom: bottomAnchor, leading: attendanceBackView.leadingAnchor, trailing: voteBackView.trailingAnchor)
        
        leftSeparatorView.anchor(top: beneathContainerView.topAnchor, bottom: beneathContainerView.bottomAnchor, width: 5)
        rightSeparatorView.anchor(top: beneathContainerView.topAnchor, bottom: beneathContainerView.bottomAnchor, width: 5)

        announcementBackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(beneathContainerView)
            make.trailing.equalTo(leftSeparatorView)
            make.width.equalTo(memberBackView)
        }
        memberBackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(beneathContainerView)
            make.leading.equalTo(leftSeparatorView)
            make.trailing.equalTo(rightSeparatorView)
            make.width.equalTo(informationBackView)
        }
        informationBackView.snp.makeConstraints { make in
            make.leading.equalTo(rightSeparatorView)
            make.top.bottom.trailing.equalTo(beneathContainerView)
            make.width.equalTo(memberBackView)
        }
        
        attendanceImageView.snp.makeConstraints { make in
            make.centerX.equalTo(attendanceBackView)
            make.centerY.equalTo(attendanceBackView).offset(-15)
        }
        attendanceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(attendanceBackView)
            make.top.equalTo(attendanceImageView.snp.bottom).offset(15)
        }
        attendanceButton.snp.makeConstraints { make in
            make.edges.equalTo(attendanceBackView)
        }
        
        voteImageView.snp.makeConstraints { make in
            make.centerX.equalTo(voteBackView)
            make.centerY.equalTo(voteBackView).offset(-15)
        }
        voteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(voteBackView)
            make.top.equalTo(voteImageView.snp.bottom).offset(15)
        }
        voteButton.snp.makeConstraints { make in
            make.edges.equalTo(voteBackView)
        }

        announcementImageView.snp.makeConstraints { make in
            make.centerX.equalTo(announcementBackView)
            make.centerY.equalTo(announcementBackView).offset(-15)
        }
        announcementLabel.snp.makeConstraints { make in
            make.centerX.equalTo(announcementBackView)
            make.top.equalTo(announcementImageView.snp.bottom).offset(15)
        }
        announcementButton.snp.makeConstraints { make in
            make.edges.equalTo(announcementBackView)
        }

        memberImageView.snp.makeConstraints { make in
            make.centerX.equalTo(memberBackView)
            make.centerY.equalTo(memberBackView).offset(-15)
        }
        memberLabel.snp.makeConstraints { make in
            make.centerX.equalTo(memberBackView)
            make.top.equalTo(memberImageView.snp.bottom).offset(15)
        }
        memberButton.snp.makeConstraints { make in
            make.edges.equalTo(memberBackView)
        }
        
        informationImageView.snp.makeConstraints { make in
            make.centerX.equalTo(informationBackView)
            make.centerY.equalTo(informationBackView).offset(-15)
        }
        informationLabel.snp.makeConstraints { make in
            make.centerX.equalTo(informationBackView)
            make.top.equalTo(informationImageView.snp.bottom).offset(15)
        }
        informationButton.snp.makeConstraints { make in
            make.edges.equalTo(informationBackView)
        }
    }
}
