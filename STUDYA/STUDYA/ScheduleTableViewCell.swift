//
//  ScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/21.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    private let roundedBackgroundView = UIView()
    private let bookmarkColorView = UIView()
//    private let scheduleTitleBackgroundView = RoundableView()
//    private let scheduleTimeBackgorundView = RoundableView()
    private  lazy var scheduleTimeLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 14)
    private lazy var scheduleNameLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 14)
    
    private lazy var schedulePlaceView = ScheduleContentView(title: "장소", content: "")
    private lazy var scheduleSubjectView = ScheduleContentView(title: "주제", content: "")
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.addSubview(roundedBackgroundView)
        
        roundedBackgroundView.clipsToBounds = true
        roundedBackgroundView.layer.cornerRadius = 13
        roundedBackgroundView.backgroundColor = .white
        
//        scheduleTitleBackgroundView.clipsToBounds = true
//        scheduleTitleBackgroundView.layer.cornerRadius = 24
//        scheduleTitleBackgroundView.layer.borderWidth = 2
        
        scheduleTimeLabel.font = UIFont.systemFont(ofSize: 14)
        scheduleNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        
//        roundedBackgroundView.addSubview(bookmarkColorView)
//        roundedBackgroundView.addSubview(scheduleTitleBackgroundView)
//        roundedBackgroundView.addSubview(schedulePlaceView)
//        roundedBackgroundView.addSubview(scheduleSubjectView)
//
//        scheduleTitleBackgroundView.addSubview(scheduleTimeBackgorundView)
//        scheduleTitleBackgroundView.addSubview(scheduleNameLabel)
//
//        scheduleTimeBackgorundView.addSubview(scheduleTimeLabel)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func configure(color: UIColor, name: String, place: String, subtitle: String, time: String) {
        
        bookmarkColorView.backgroundColor = color
//        scheduleTimeBackgorundView.backgroundColor = color
//        scheduleTitleBackgroundView.layer.borderColor = color.cgColor
        scheduleTimeLabel.text = time
        scheduleNameLabel.text = name
        schedulePlaceView.contenttLabel.text = place
        scheduleSubjectView.contenttLabel.text = subtitle
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        roundedBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        bookmarkColorView.snp.makeConstraints { make in
            make.top.equalTo(roundedBackgroundView.snp.top)
            make.leading.equalTo(roundedBackgroundView.snp.leading)
            make.bottom.equalTo(roundedBackgroundView.snp.bottom)
            make.width.equalTo(10)
        }
        
//        scheduleTitleBackgroundView.snp.makeConstraints { make in
//            make.top.equalTo(roundedBackgroundView.snp.top).inset(10)
//            make.trailing.equalTo(roundedBackgroundView.snp.trailing).inset(10)
//            make.leading.equalTo(bookmarkColorView.snp.trailing).offset(10)
//            make.height.equalTo(30)
//        }
//
//        scheduleTimeBackgorundView.snp.makeConstraints { make in
//            make.top.equalTo(scheduleTitleBackgroundView.snp.top)
//            make.leading.equalTo(scheduleTitleBackgroundView.snp.leading)
//            make.bottom.equalTo(scheduleTitleBackgroundView.snp.bottom)
//        }
//
//        scheduleTimeLabel.snp.makeConstraints { make in
//            make.top.equalTo(scheduleTimeBackgorundView.snp.top).inset(6)
//            make.bottom.equalTo(scheduleTimeBackgorundView.snp.bottom).inset(6)
//            make.leading.equalTo(scheduleTimeBackgorundView.snp.leading).inset(10)
//            make.trailing.equalTo(scheduleTimeBackgorundView.snp.trailing).inset(10)
//        }
//
//        scheduleNameLabel.snp.makeConstraints { make in
//            make.top.equalTo(scheduleTitleBackgroundView.snp.top).inset(8)
//            make.leading.equalTo(scheduleTimeBackgorundView.snp.trailing).offset(10)
//            make.bottom.equalTo(scheduleTitleBackgroundView.snp.bottom).inset(8)
//            make.trailing.equalTo(scheduleTitleBackgroundView.snp.trailing).inset(10)
//        }
//
//        schedulePlaceView.snp.makeConstraints { make in
//            make.top.equalTo(scheduleTitleBackgroundView.snp.bottom).offset(5)
//            make.leading.equalTo(bookmarkColorView.snp.trailing)
//            make.trailing.equalTo(roundedBackgroundView.snp.trailing)
//        }
//
        scheduleSubjectView.snp.makeConstraints { make in
            make.top.equalTo(schedulePlaceView.snp.bottom).offset(5)
            make.leading.equalTo(bookmarkColorView.snp.trailing)
            make.bottom.equalTo(roundedBackgroundView.snp.bottom).inset(5)
            make.trailing.greaterThanOrEqualTo(roundedBackgroundView.snp.trailing).inset(5)
        }
    }
}

// MARK: - ScheduleContentView

class ScheduleContentView: UIView {
    
    let dot = UIView()
    let titleLabel = UILabel()
    let separatebar = UIView()
    let contenttLabel = UILabel()
    
    init(title: String, content: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        contenttLabel.text = content
        
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func setSubviews() {
        
        addSubview(dot)
        
        dot.clipsToBounds = true
        dot.layer.cornerRadius = 4 / 2
        dot.backgroundColor = .appColor(.keyColor1)
        
        addSubview(titleLabel)
        
        titleLabel.textColor = .appColor(.ppsBlack)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        addSubview(separatebar)
        
        separatebar.backgroundColor = .appColor(.ppsBlack)
        
        addSubview(contenttLabel)
        
        contenttLabel.textColor = .appColor(.ppsBlack)
        contenttLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        dot.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.width.height.equalTo(4)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(1)
            make.leading.equalTo(dot.snp.trailing).offset(6)
        }
        separatebar.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.height.equalTo(9)
            make.width.equalTo(1)
        }
        contenttLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(separatebar.snp.trailing).offset(5)
        }
    }
}
