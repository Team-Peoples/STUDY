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
    
    private var currentStudyOverall: StudyOverall?
    
    internal var delegate: (Navigatable & SwitchSyncable & SwitchStatusGivable)?

    private let backView = RoundableView(cornerRadius: 24)
    private let titleLabel = CustomLabel(title: "지금까지의 출결", tintColor: .ppsBlack, size: 16, isBold: true)
    private let disclosureIndicatorView = UIImageView(image: UIImage(named: "circleDisclosureIndicator"))
    
    private lazy var noAttendanceDataLabel = CustomLabel(title: "출결 데이터가 없어요 😴", tintColor: .ppsGray1, size: 14)
    
    private lazy var progressView: MultiProgressView = {
        let MPV = MultiProgressView()
        MPV.trackBackgroundColor = .appColor(.ppsGray2)
        MPV.lineCap = .round
        MPV.cornerRadius = 5
        return MPV
    }()
    private lazy var attendanceRatioTitleLabel = CustomLabel(title: "출석률", tintColor: .ppsGray1, size: 12)
    private lazy var attendanceRatioLabel = CustomLabel(title: "정보를 불러오지 못했습니다.", tintColor: .keyColor1, size: 12, isBold: true)
    private lazy var penaltyTitleLabel = CustomLabel(title: "| 벌금", tintColor: .ppsGray1, size: 12)
    private lazy var penaltyLabel = CustomLabel(title: "정보를 불러오지 못했습니다.", tintColor: .keyColor1, size: 12, isBold: true)
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
        
        
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(disclosureIndicatorView)
        
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
        
        progressView.dataSource = self
        hoveringButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        configureViewsWhenYesData()
        configureViewWhenNoData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        guard let delegate = delegate,
              let currentStudyOverall = currentStudyOverall,
              let studyID = currentStudyOverall.study.id else {
            return
        }
        
        let nextVC = AttendanceViewController()
        
        delegate.syncSwitchWith(nextVC: nextVC)
        
        nextVC.configureViewController(with: studyID)
        nextVC.title = currentStudyOverall.study.studyName
        
        delegate.push(vc: nextVC)
    }
    
    internal func configureCellWithStudy(_ currentStudyOverall: StudyOverall?) {
        self.currentStudyOverall = currentStudyOverall
        
        guard let currentStudyOverall = currentStudyOverall, let totalStudyHeldCount = currentStudyOverall.totalStudyHeldCount else {
            configureErrorSituation()
            return
        }
        
        if totalStudyHeldCount != 0 {
            configureProgressBarWhenYesAttendanceData(with: currentStudyOverall)
        } else {
            configureWhenNoAttendanceData()
        }
    }
    
    private func configureErrorSituation() {
        configureViewWhenNoData()
        noAttendanceDataLabel.text = "출결 데이터를 가져오지 못했습니다.\n이용에 불편을 드려 죄송합니다"
    }
    
    private func configureProgressBarWhenYesAttendanceData(with currentStudyOverall: StudyOverall) {
        progressView.resetProgress()
        setupMultiProgressView()
        
        let totalStudyHeldCount = currentStudyOverall.attendedCount + currentStudyOverall.lateCount + currentStudyOverall.allowedCount + currentStudyOverall.absentCount
        let notAbsentCount = currentStudyOverall.attendedCount + currentStudyOverall.lateCount + currentStudyOverall.allowedCount
        attendanceRatioLabel.text = "\(100 * notAbsentCount / totalStudyHeldCount)%"
        
        penaltyLabel.text = String(currentStudyOverall.totalFine.formatted(.number))
        
        noAttendanceDataLabel.isHidden = true
        progressView.isHidden = false
        stackView.isHidden = false
        hoveringButton.isHidden = false
    }
    
    private func configureWhenNoAttendanceData() {
        noAttendanceDataLabel.isHidden = false
        progressView.isHidden = true
        stackView.isHidden = true
        hoveringButton.isHidden = false
    }
    
    private func setupMultiProgressView() {
        guard let currentStudyOverall = currentStudyOverall, let totalStudyHeldCount = currentStudyOverall.totalStudyHeldCount else { return }
        
        let studyAttendance: [Attendance : Int] = [
            .attended: currentStudyOverall.attendedCount,
            .late: currentStudyOverall.lateCount,
            .absent: currentStudyOverall.absentCount,
            .allowed: currentStudyOverall.allowedCount
        ]
        
        var attendanceRatio = Float(studyAttendance[.attended]! * 100 / totalStudyHeldCount) / 100
        var latenessRatio = Float(studyAttendance[.late]! * 100 / totalStudyHeldCount) / 100
        var absenceRatio = Float(studyAttendance[.absent]! * 100 / totalStudyHeldCount) / 100
        var allowedRatio = Float(studyAttendance[.allowed]! * 100 / totalStudyHeldCount) / 100
        
        print("attendanceRatio", attendanceRatio)
        print("latenessRatio", latenessRatio)
        print("absenceRatio", absenceRatio)
        print("allowedRatio", allowedRatio)
        
        if attendanceRatio + latenessRatio + absenceRatio + allowedRatio != 1 {
            let lackRatio = 1 - (attendanceRatio + latenessRatio + absenceRatio + allowedRatio)
            
            if attendanceRatio != 0 {
                attendanceRatio += lackRatio
            } else if latenessRatio != 0 {
                latenessRatio += lackRatio
            } else if absenceRatio != 0 {
                absenceRatio += lackRatio
            } else if allowedRatio != 0 {
                allowedRatio += lackRatio
            }
        }

        self.progressView.setProgress(section: 0, to: attendanceRatio)
        self.progressView.setProgress(section: 1, to: latenessRatio)
        self.progressView.setProgress(section: 2, to: absenceRatio)
        self.progressView.setProgress(section: 3, to: allowedRatio)
    }
    
    private func configureViewWhenNoData() {
        noAttendanceDataLabel.isHidden = true
        
        backView.addSubview(noAttendanceDataLabel)
        noAttendanceDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.centerY.equalTo(backView).offset(15)
        }
    }
    
    private func configureViewsWhenYesData() {
        progressView.isHidden = true
        stackView.isHidden = true
        hoveringButton.isHidden = true
        
        backView.addSubview(progressView)
        backView.addSubview(stackView)
        backView.addSubview(hoveringButton)
        
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
