//
//  MainSecondScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit

class MainSecondScheduleTableViewCell: UITableViewCell {
    
    static let identifier = "MainSecondScheduleTableViewCell"
    internal var navigatable: Navigatable!
    
    let title = CustomLabel(title: "일정", tintColor: .ppsBlack, size: 20, isBold: true)
    let disclosureButton = UIButton(frame: .zero)
    
    let subtitle = CustomLabel(title: "다가오는 일정", tintColor: .ppsBlack, size: 16, isBold: true)
    let date = CustomLabel(title: "00월00일 (월) | am 00:00", tintColor: .ppsGray1, size: 16, isBold: true)
    let place = CustomLabel(title: "강남역 공간이즈", tintColor: .ppsGray1, size: 12)
    let today = CustomLabel(title: "동사와 형용사", tintColor: .ppsGray1, size: 12)
    
    let scheduleBackView: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 24
        v.backgroundColor = .systemBackground
        
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = UIColor.appColor(.background)
        
        addSubview(scheduleBackView)
        
        scheduleBackView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        
        disclosureButton.setImage(UIImage(named: "circleDisclosureIndicator"), for: .normal)
        disclosureButton.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        
        scheduleBackView.addSubview(title)
        scheduleBackView.addSubview(disclosureButton)
        scheduleBackView.addSubview(subtitle)
        scheduleBackView.addSubview(date)
        scheduleBackView.addSubview(place)
        scheduleBackView.addSubview(today)
        
        title.anchor(top: scheduleBackView.topAnchor, topConstant: 20, leading: scheduleBackView.leadingAnchor, leadingConstant: 32)
        disclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalTo(scheduleBackView.snp.trailing).offset(-12)
        }
        subtitle.anchor(top: title.bottomAnchor, topConstant: 24, leading: scheduleBackView.leadingAnchor, leadingConstant: 32)
        date.anchor(top: subtitle.bottomAnchor, topConstant: 12, leading: subtitle.leadingAnchor)
        place.anchor(top: date.bottomAnchor, topConstant: 2, leading: date.leadingAnchor, trailing: scheduleBackView.trailingAnchor, trailingConstant: 20)
        today.anchor(top: place.bottomAnchor, topConstant: 13, leading: place.leadingAnchor, trailing: place.trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func scheduleTapped() {
        let ssvc = StudyScheduleViewController()
        ssvc.presentingVC = navigatable as? UIViewController
        
        navigatable.push(vc: ssvc)
    }
}
