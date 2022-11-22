//
//  ScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/21.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    private let roundedBackgroundView = RoundableView(cornerRadius: 24)
    private let bookmarkColorView = UIView()
    private let startTimeLabel = CustomLabel(title: "00:00", tintColor: .ppsGray1, size: 12)
    private let endTimeLabel = CustomLabel(title: "00:00", tintColor: .ppsGray1, size: 12)
    private let topicLabel = CustomLabel(title: "일정주제", tintColor: .ppsBlack, size: 14)
    private let locationIcon = UIImageView(image: UIImage(named: "location"))
    private let placeLabel = CustomLabel(title: "일정장소", tintColor: .ppsGray1, size: 12)
    private lazy var timeLabelStackView: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [startTimeLabel, endTimeLabel])
        
        verticalStackView.alignment = .center
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        
        return verticalStackView
    }()
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.addSubview(roundedBackgroundView)
        
        roundedBackgroundView.clipsToBounds = true
        roundedBackgroundView.backgroundColor = .white
        
        bookmarkColorView.layer.cornerRadius = 1
        
        roundedBackgroundView.addSubview(timeLabelStackView)
        roundedBackgroundView.addSubview(bookmarkColorView)
        roundedBackgroundView.addSubview(topicLabel)
      
        roundedBackgroundView.addSubview(locationIcon)
        roundedBackgroundView.addSubview(placeLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func configure(schedule: Studyschedule) {
        
        let time = schedule.time.components(separatedBy: "-")
        
        bookmarkColorView.backgroundColor = schedule.color
        startTimeLabel.text = time.first
        endTimeLabel.text = time.last
        topicLabel.text = schedule.topic
        placeLabel.text = schedule.place
        
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        roundedBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        timeLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(roundedBackgroundView).offset(10)
            make.height.equalTo(30)
        }
        
        bookmarkColorView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabelStackView.snp.trailing).offset(7)
            make.centerY.equalTo(roundedBackgroundView)
            make.height.equalTo(38)
            make.width.equalTo(2)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkColorView.snp.trailing).offset(7)
            make.bottom.equalTo(roundedBackgroundView.snp.centerY).offset(-1)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkColorView.snp.trailing).offset(6)
            make.top.equalTo(roundedBackgroundView.snp.centerY).offset(1)
            
            make.height.equalTo(17)
            make.width.equalTo(10)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(6)
            make.centerY.equalTo(locationIcon)
        }
    }
}
