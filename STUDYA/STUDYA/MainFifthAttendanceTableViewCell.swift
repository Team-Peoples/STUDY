//
//  MainFifthAttendanceTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/29.
//

import UIKit
import MultiProgressView

class MainFifthAttendanceTableViewCell: UITableViewCell {
    
    static let identifier = "MainFifthAttendanceTableViewCell"
    
    internal var studyAttendance: [String: Int]! {
        didSet {
            setupProgress()
        }
    }
    internal var penalty: Int? {
        didSet {
            penaltyLabel.text = String(penalty!.formatted(.number))
        }
    }
    
    internal var navigatableSwitchSyncableDelegate: (Navigatable & SwitchSyncable)!

    private let backView = RoundableView(cornerRadius: 24)
    private let titleLabel = CustomLabel(title: "지금까지의 출결", tintColor: .ppsBlack, size: 16, isBold: true)
    private let disclosureIndicatorView = UIImageView(image: UIImage(named: "circleDisclosureIndicator"))
    private lazy var progressView: MultiProgressView = {
        let MPV = MultiProgressView()
        MPV.trackBackgroundColor = .appColor(.ppsGray2)
        MPV.lineCap = .round
        MPV.cornerRadius = 5
        return MPV
    }()
    private let attendanceRatioTitleLabel = CustomLabel(title: "출석률", tintColor: .ppsGray1, size: 12)
    private let attendanceRatioLabel = CustomLabel(title: "", tintColor: .keyColor1, size: 12, isBold: true)
    private let penaltyTitleLabel = CustomLabel(title: "| 벌금", tintColor: .ppsGray1, size: 12)
    private let penaltyLabel = CustomLabel(title: "", tintColor: .keyColor1, size: 12, isBold: true)
    private lazy var stackView: UIStackView = {
       
        let s = UIStackView(arrangedSubviews: [attendanceRatioTitleLabel, attendanceRatioLabel, penaltyTitleLabel, penaltyLabel])
        
        s.axis = .horizontal
        s.spacing = 4
        s.distribution = .equalSpacing
        
        return s
    }()
    private let hoveringButton = UIButton()
    
    var barColors: [UIColor] = [.appColor(.attendedMain), .appColor(.lateMain), .appColor(.absentMain), .appColor(.allowedMain)]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .systemBackground
        backView.backgroundColor = .appColor(.background2)
        
        progressView.dataSource = self
        
        hoveringButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        let nextVC = AttendanceViewController()
        
        navigatableSwitchSyncableDelegate.syncSwitchWith(nextVC: nextVC)
        
        nextVC.syncSwitchReverse = { sender in
            self.navigatableSwitchSyncableDelegate.syncSwitchReverseWith(nextVC: nextVC)
        }
        
        navigatableSwitchSyncableDelegate.push(vc: nextVC)
    }
    
    private func setupProgress() {

        let total = studyAttendance.map { (_, value) in return value }.reduce(0, +)
        let attendanceRatio = Float(studyAttendance["출석"]! * 100 / total) / 100
        let latendssRatio = Float(studyAttendance["지각"]! * 100 / total) / 100
        let absenceRatio = Float(studyAttendance["결석"]! * 100 / total) / 100
        let allowedRatio = Float(studyAttendance["사유"]! * 100 / total) / 100

        self.progressView.setProgress(section: 0, to: attendanceRatio)
        self.progressView.setProgress(section: 1, to: latendssRatio)
        self.progressView.setProgress(section: 2, to: absenceRatio)
        self.progressView.setProgress(section: 3, to: allowedRatio)

        attendanceRatioLabel.text = "\(Double(attendanceRatio * 100).formatted(.number))%"
    }
    
    private func addSubviews() {
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(disclosureIndicatorView)
        backView.addSubview(progressView)
        backView.addSubview(stackView)
        backView.addSubview(hoveringButton)
    }
    
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).inset(28)
            make.top.equalTo(backView.snp.top).inset(24)
        }
        disclosureIndicatorView.snp.makeConstraints { make in
            make.trailing.equalTo(backView).inset(29)
            make.centerY.equalTo(titleLabel)
        }
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(backView).inset(16)
            make.height.equalTo(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(43)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(progressView.snp.bottom).offset(16)
        }
        hoveringButton.snp.makeConstraints { make in
            make.edges.equalTo(backView)
        }
    }
}

extension MainFifthAttendanceTableViewCell: MultiProgressViewDataSource {
    public func numberOfSections(in progressBar: MultiProgressView) -> Int {
        return 4
    }

    public func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let bar = ProgressViewSection()
        bar.backgroundColor = barColors[section]
        return bar
    }
}
