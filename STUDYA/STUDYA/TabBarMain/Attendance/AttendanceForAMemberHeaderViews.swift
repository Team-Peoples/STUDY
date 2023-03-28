//
//  AttendanceForAMemberHeaderViews.swift
//  STUDYA
//
//  Created by 서동운 on 11/17/22.
//

import UIKit
import SnapKit
import MultiProgressView

class MyAttendanceStatusView: UIView {
    
    // MARK: - Properties    
    internal var navigatable: Navigatable?
    
//    필요정보: 총벌금, 출석지각결석사유 횟수
    private let titleLabel = CustomLabel(title: "출결 현황", tintColor: .ppsBlack, size: 16, isBold: true)
    private let fineLabel = UILabel(frame: .zero)
    private let attendanceProgressView = AttendanceReusableProgressView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func getAttendanceStats(with studyID: ID?) {
        guard let studyID = studyID else { return }
        
        Network.shared.getAttendanceStats(studyID: studyID) { result in
            switch result {
            case .success(let stats):
                self.attendanceProgressView.configureView(with: stats)
                self.setFineLabel(fine: stats.totalFine)
                
            case .failure(let error):
                guard let navigatable = self.navigatable else { return }
                UIAlertController.handleCommonErros(presenter: navigatable, error: error)
            }
        }
    }
    
    // MARK: - configure
    private func setFineLabel(fine: Int) {
        fineLabel.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: fine, valueFontSize: 24, withCurrency: true)
    }
    
    private func configureViews() {
        addSubview(titleLabel)
        addSubview(fineLabel)
        addSubview(attendanceProgressView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(14)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        fineLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(30)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(36)
        }
        attendanceProgressView.snp.makeConstraints { make in
            make.top.equalTo(fineLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

class AttendanceStatusWithProfileView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(title: "출결 상세", tintColor: .ppsBlack, size: 16, isBold: true)
    private let profileImageView = ProfileImageContainerView(size: 40)
    private let nickNameLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 16, isBold: true)
    private let fineLabel = UILabel(frame: .zero)
    private let attendanceProgressView = AttendanceReusableProgressView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureViewWith(stats: UserAttendanceStatistics) {
        profileImageView.setImageWith(stats.profileImageURL)
        nickNameLabel.text = stats.nickName
        fineLabel.text = stats.totalFine.toString()
        
        let attendanceStats = AttendanceStats(attendedCount: stats.attendedCount, lateCount: stats.lateCount, allowedCount: stats.allowedCount, absentCount: stats.absentCount, totalCount: stats.totalAttendanceCount, totalFine: stats.totalFine)
        
        attendanceProgressView.configureView(with: attendanceStats)
    }
    
    // MARK: - configure
    private func configureViews() {
        fineLabel.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: 0, valueFontSize: 24, withCurrency: true)
        
        addSubview(titleLabel)
        addSubview(profileImageView)
        addSubview(nickNameLabel)
        addSubview(fineLabel)
        addSubview(attendanceProgressView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(14)
            make.leading.equalTo(self.snp.leading).inset(30)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        fineLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(36)
        }
        attendanceProgressView.snp.makeConstraints { make in
            make.top.equalTo(fineLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

private class AttendanceReusableProgressView: UIView {
    
    // MARK: - Properties
    private var barColors: [UIColor] = [.appColor(.attendedMain), .appColor(.lateMain), .appColor(.absentMain), .appColor(.allowedMain)]
    
    private let attendanceProportionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .appColor(.ppsBlack)
        return lbl
    }()
    private lazy var progressView: MultiProgressView = {
        let MPV = MultiProgressView()
        MPV.trackBackgroundColor = .appColor(.ppsGray2)
        MPV.lineCap = .round
        MPV.cornerRadius = 5
        return MPV
    }()
    private let attendanceLabel = CustomLabel(title: "출석", tintColor: .ppsGray1, size: 14)
    private let latenessLabel = CustomLabel(title: "지각", tintColor: .ppsGray1, size: 14)
    private let absenceLabel = CustomLabel(title: "결석", tintColor: .ppsGray1, size: 14)
    private let allowedLabel = CustomLabel(title: "사유", tintColor: .ppsGray1, size: 14)
    
    private let attendanceCountLabel = CustomLabel(title: "", tintColor: .attendedMain, size: 16, isBold: true)
    private let latenessCountLabel = CustomLabel(title: "", tintColor: .lateMain, size: 16, isBold: true)
    private let absenceCountLabel = CustomLabel(title: "", tintColor: .absentMain, size: 16, isBold: true)
    private let allowedCountLabel = CustomLabel(title: "", tintColor: .allowedMain, size: 16, isBold: true)
    
    private let separater = UIView()
    
    // MARK: - Initialization
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupProgressBar()
        setupAttendanceProportionLabel()
        setupLabelStackViewUnderProgressBar()
        setupSeparater()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    internal func configureView(with attendanceStats: AttendanceStats) {
        let totalCount = attendanceStats.attendedCount
        + attendanceStats.lateCount
        + attendanceStats.absentCount
        + attendanceStats.allowedCount
        let notAbsentCount = attendanceStats.attendedCount + attendanceStats.lateCount + attendanceStats.allowedCount
        
        attendanceProportionLabel.text = "출석률 \(100 * notAbsentCount / totalCount)%"
        
        attendanceCountLabel.text = String(attendanceStats.attendedCount)
        latenessCountLabel.text = String(attendanceStats.lateCount)
        absenceCountLabel.text = String(attendanceStats.absentCount)
        allowedCountLabel.text = String(attendanceStats.allowedCount)
        
        setupProgress(attendanceStats: attendanceStats)
    }
    
    private func setupProgressBar() {
        
        addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(10)
            make.width.equalTo(Constant.screenWidth - 60)
        }
        
        progressView.dataSource = self
        progressView.delegate = self
    }
    
    private func setupAttendanceProportionLabel() {
        
        addSubview(attendanceProportionLabel)
        
        attendanceProportionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(progressView.snp.top).offset(-5)
            make.trailing.equalTo(progressView)
        }
    }
    
    private func setupProgress(attendanceStats: AttendanceStats) {
        let totalCount = attendanceStats.attendedCount
        + attendanceStats.lateCount
        + attendanceStats.absentCount
        + attendanceStats.allowedCount
        
        var attendanceRatio = Float(attendanceStats.attendedCount * 100 / totalCount) / 100
        var latenessRatio = Float(attendanceStats.lateCount * 100 / totalCount) / 100
        var absenceRatio = Float(attendanceStats.absentCount * 100 / totalCount) / 100
        var allowedRatio = Float(attendanceStats.allowedCount * 100 / totalCount) / 100
        print(attendanceRatio, "🍓")
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
    
    private func setupLabelStackViewUnderProgressBar() {
        
        let separater1 = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 42))
        let separater2 = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 42))
        let separater3 = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 42))
        
        [separater1,separater2, separater3].forEach {
            $0.backgroundColor = .appColor(.ppsGray2)
            $0.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(42)
            }
        }
        
       let verticalStackedlabels = [[attendanceLabel, attendanceCountLabel], [latenessLabel, latenessCountLabel], [absenceLabel, absenceCountLabel], [allowedLabel, allowedCountLabel]].map { labels in
            let verticalStackView = UIStackView(arrangedSubviews: labels)
            verticalStackView.alignment = .center
            verticalStackView.distribution = .equalSpacing
            verticalStackView.axis = .vertical
            verticalStackView.spacing = 5
            return verticalStackView
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [verticalStackedlabels[0], separater1, verticalStackedlabels[1], separater2, verticalStackedlabels[2], separater3, verticalStackedlabels[3]])
        
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.axis = .horizontal
    
        addSubview(horizontalStackView)
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self).inset(45)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
    }
    
    private func setupSeparater() {
        
        addSubview(separater)
        
        separater.backgroundColor = .appColor(.ppsGray2)
        
        separater.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
}

extension AttendanceReusableProgressView: MultiProgressViewDataSource {
    public func numberOfSections(in progressBar: MultiProgressView) -> Int {
        return 4
    }
    
    public func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let bar = ProgressViewSection()
        bar.backgroundColor = barColors[section]
        return bar
    }
}

// MARK: - MultiProgressViewDelegate

extension AttendanceReusableProgressView: MultiProgressViewDelegate {
    
    func progressView(_ progressView: MultiProgressView, didTapSectionAt index: Int) {
        print("Tapped section \(index)")
    }
}
