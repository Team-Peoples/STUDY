//
//  MainSecondScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit

class MainSecondScheduleTableViewCell: UITableViewCell {
    
    static let identifier = "MainSecondScheduleTableViewCell"
    
    private let isScheduleExist = true
    
    private let title = CustomLabel(title: "EHD님의 일정", tintColor: .ppsBlack, size: 20, isBold: true)
    private let disclosureIndicatorView = UIImageView(image: UIImage(named: "circleDisclosureIndicator"))
    
    private lazy var noScheudleLabel = CustomLabel(title: "예정된 일정이 없어요 😴", tintColor: .ppsGray1, size: 14)
    
    private lazy var date = CustomLabel(title: "00월00일 (월) | am 00:00", tintColor: .keyColor1, size: 16, isBold: true)
    private lazy var place = CustomLabel(title: "강남역 공간이즈", tintColor: .ppsGray1, size: 12)
    private lazy var todayContent = CustomLabel(title: "동사와 형용사", tintColor: .ppsGray1, size: 14)
    
    private let scheduleBackView: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .appColor(.background2)
        
        return v
    }()
    
    private lazy var scheduleButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        scheduleButton.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        
        constrainLine()
        addSubviews()
        setConstraints()
    }
    
    private func constrainLine() {
        title.numberOfLines = 1
        date.numberOfLines = 1
        place.numberOfLines = 1
        todayContent.numberOfLines = 1
    }
    
    private func addSubviews() {
        addSubview(scheduleBackView)
        scheduleBackView.addSubview(title)
        scheduleBackView.addSubview(disclosureIndicatorView)
        
        if isScheduleExist == true {
            scheduleBackView.addSubview(date)
            scheduleBackView.addSubview(place)
            scheduleBackView.addSubview(todayContent)
            
        } else {
            scheduleBackView.addSubview(noScheudleLabel)
            scheduleBackView.addSubview(scheduleButton)
        }
        scheduleBackView.addSubview(scheduleButton)
    }
    
    private func setConstraints() {
        scheduleBackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        title.snp.makeConstraints { make in
            make.top.leading.equalTo(scheduleBackView).inset(24)
            make.trailing.equalTo(disclosureIndicatorView.snp.leading)
        }
        disclosureIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalTo(scheduleBackView.snp.trailing).offset(-12)
            make.width.height.equalTo(28)
        }
        
        if isScheduleExist == true {
            date.anchor(top: title.bottomAnchor, topConstant: 30, leading: title.leadingAnchor)
            place.anchor(top: date.bottomAnchor, topConstant: 2, leading: date.leadingAnchor)
            todayContent.anchor(top: place.bottomAnchor, topConstant: 13, leading: place.leadingAnchor, trailing: place.trailingAnchor)
        } else {
            noScheudleLabel.snp.makeConstraints { make in
                make.centerX.equalTo(scheduleBackView)
                make.top.equalTo(title.snp.bottom).offset(50)
            }
        }
        
        scheduleButton.snp.makeConstraints { make in
            make.edges.equalTo(scheduleBackView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func scheduleTapped() {
        print(#function)
    }
}
