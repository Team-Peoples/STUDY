//
//  ScheduleTableViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/21.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    let roundedBackgroundView = RoundableView(cornerRadius: 24)
    private let bookmarkColorView = UIView()
    private lazy var optionalLabel = RoundedCustomLabel(text: "옵션", fontSize: 10, radius: 6, backgroundColor: .appColor(.background), textColor: .appColor(.ppsGray1))
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
    private lazy var etcButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "etc-column"), for: .normal)
        btn.tintColor = .appColor(.ppsGray2)
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
    
        setupRoundedBackgroundView()
        configureViews()
        
        bookmarkColorView.layer.cornerRadius = 1
        
        etcButton.addTarget(self, action: #selector(etcButtonDidTapped), for: .touchUpInside)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func etcButtonDidTapped() {
        print(#function)
    }
    
    func configure(schedule: Studyschedule, kind: CalendarKind) {
        let time = schedule.time.components(separatedBy: "-")
        
        bookmarkColorView.backgroundColor = schedule.color
        startTimeLabel.text = time.first
        endTimeLabel.text = time.last
        topicLabel.text = schedule.topic
        placeLabel.text = schedule.place
        
        if kind == .study {
            optionalLabel.text = schedule.studyName
            optionalLabel.change(textColor: .appColor(.keyColor1))
        } else {
            optionalLabel.text = schedule.repeatOption
        }
    }
    
    private func configureViews() {
        contentView.addSubview(roundedBackgroundView)
    
        roundedBackgroundView.addSubview(timeLabelStackView)
        roundedBackgroundView.addSubview(bookmarkColorView)
        roundedBackgroundView.addSubview(topicLabel)
        roundedBackgroundView.addSubview(locationIcon)
        roundedBackgroundView.addSubview(placeLabel)
        roundedBackgroundView.addSubview(etcButton)
        roundedBackgroundView.addSubview(optionalLabel)
    }
    
    private func setupRoundedBackgroundView() {
        roundedBackgroundView.backgroundColor = .white
        roundedBackgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        roundedBackgroundView.layer.shadowOpacity = 1
        roundedBackgroundView.layer.shadowRadius = 5
        roundedBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        roundedBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        timeLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView).offset(5)
            make.leading.equalTo(roundedBackgroundView).offset(10)
            make.height.equalTo(30)
        }
        bookmarkColorView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabelStackView.snp.trailing).offset(7)
            make.centerY.equalTo(roundedBackgroundView).offset(5)
            make.height.equalTo(38)
            make.width.equalTo(2)
            make.bottom.equalTo(roundedBackgroundView).offset(-16)
        }
        topicLabel.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkColorView.snp.trailing).offset(7)
            make.bottom.equalTo(bookmarkColorView.snp.centerY).offset(-2)
        }
        locationIcon.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkColorView.snp.trailing).offset(6)
            make.top.equalTo(bookmarkColorView.snp.centerY).offset(2)
            
            make.height.equalTo(17)
            make.width.equalTo(10)
        }
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(6)
            make.centerY.equalTo(locationIcon)
        }
        etcButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.trailing.equalTo(roundedBackgroundView).inset(12)
        }
        optionalLabel.snp.makeConstraints { make in
            make.top.equalTo(roundedBackgroundView).offset(8)
            make.bottom.equalTo(topicLabel.snp.top).offset(-6)
            make.leading.equalTo(topicLabel).offset(2)
        }
    }
}
