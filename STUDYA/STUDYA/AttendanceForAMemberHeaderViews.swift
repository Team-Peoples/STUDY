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
    internal var attendanceOverall: Observable<MyAttendanceOverall>?
    
//    필요정보: 총벌금, 출석지각결석사유 횟수
    private let titleLabel = CustomLabel(title: "출결 현황", tintColor: .ppsBlack, size: 16, isBold: true)
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: 0, valueFontSize: 24, withCurrency: true)
        return lbl
    }()
    private let attendanceProgressView = AttendanceReusableProgressView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setConstraints()
        attendanceProgressView.attendanceOverall = attendanceOverall
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    
    private func setBinding() {
        attendanceOverall?.bind({ myAttendanceOverall in
            self.fineLabel.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: myAttendanceOverall.totalFine, valueFontSize: 24, withCurrency: true)
            self.attendanceProgressView.attendanceOverall = self.attendanceOverall
        })
    }
    
    private func configureViews() {
        addSubview(titleLabel)
        addSubview(fineLabel)
        addSubview(attendanceProgressView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
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
    private let profileImageView = ProfileImageView(size: 40)
    private let nickNameLabel = CustomLabel(title: "니이이이이이이이익넴", tintColor: .ppsGray1, size: 16, isBold: true)
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: 999999, valueFontSize: 24, withCurrency: true)
        return lbl
    }()
    
    private let attendanceProgressView = AttendanceReusableProgressView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    
    func configureViews() {
        addSubview(titleLabel)
        addSubview(profileImageView)
        addSubview(nickNameLabel)
        addSubview(fineLabel)
        addSubview(attendanceProgressView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
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
    internal var attendanceOverall: Observable<MyAttendanceOverall>?
    
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
    
    private let attendanceCountLabel = CustomLabel(title: "?", tintColor: .attendedMain, size: 16, isBold: true)
    private let latenessCountLabel = CustomLabel(title: "?", tintColor: .lateMain, size: 16, isBold: true)
    private let absenceCountLabel = CustomLabel(title: "?", tintColor: .absentMain, size: 16, isBold: true)
    private let allowedCountLabel = CustomLabel(title: "?", tintColor: .allowedMain, size: 16, isBold: true)
    
    private let separater = UIView()
    
    // MARK: - Initialization
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        setupProgressBar()
        setupProgress()
        setupAttendanceProportionLabel()
        setupLabelStackViewUnderProgressBar()
        setupSeparater()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func setBinding() {
        attendanceOverall?.bind({ [self] myAttendanceOverall in
            
            let totalCount = myAttendanceOverall.attendedCount + myAttendanceOverall.lateCount + myAttendanceOverall.absentCount + myAttendanceOverall.allowedCount
            attendanceProportionLabel.text = "출석률 \((myAttendanceOverall.attendedCount + myAttendanceOverall.lateCount + myAttendanceOverall.allowedCount) / totalCount)%"
            
            attendanceCountLabel.text = String(myAttendanceOverall.attendedCount)
            latenessLabel.text = String(myAttendanceOverall.lateCount)
            absenceCountLabel.text = String(myAttendanceOverall.absentCount)
            allowedCountLabel.text = String(myAttendanceOverall.allowedCount)
            
            setupProgress()
        })
    }
    
    // MARK: - Configure

    private func setupProgressBar() {
        
        addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(10)
            make.width.equalTo(Const.screenWidth - 60)
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
    
    private func setupProgress() {
        guard let attendanceOverall = attendanceOverall else { return }
        let total = attendanceOverall.value.absentCount + attendanceOverall.value.lateCount + attendanceOverall.value.absentCount + attendanceOverall.value.allowedCount
        let attendanceRatio = Float(attendanceOverall.value.attendedCount * 100 / total) / 100
        let latendssRatio = Float(attendanceOverall.value.lateCount * 100 / total) / 100
        let absenceRatio = Float(attendanceOverall.value.absentCount * 100 / total) / 100
        let allowedRatio = Float(attendanceOverall.value.allowedCount * 100 / total) / 100
        
        self.progressView.setProgress(section: 0, to: attendanceRatio)
        self.progressView.setProgress(section: 1, to: latendssRatio)
        self.progressView.setProgress(section: 2, to: absenceRatio)
        self.progressView.setProgress(section: 3, to: allowedRatio)
        
        attendanceProportionLabel.text = "출석률 \(Double(attendanceRatio * 100).formatted(.number))%"
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
