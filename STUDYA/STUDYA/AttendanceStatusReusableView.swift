//
//  AttendanceStatusReusableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/17/22.
//

import UIKit
import SnapKit
import MultiProgressView

class AttendanceStatusReusableView: UIView {
    
    // MARK: - Properties
  
    var studyAttendance: [String: Int] = ["출석": 60,
                                          "지각": 15,
                                          "결석": 3,
                                          "사유": 5]
    var barColors: [UIColor] = [.appColor(.attendedMain), .appColor(.lateMain), .appColor(.absentMain), .appColor(.ppsGray2)]
    
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(frontLabel: "총 벌금 ", labelFontSize: 12, value: 999999, valueFontSize: 24, withCurrency: true)
        return lbl
    }()
    private let attendanceProportionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "출석률 0%"
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
    
    private let progressViewHeight: CGFloat = 10
    
    // MARK: - Initialization
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        setupLabels()
        setupProgressBar()
        setupProgress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Configure
    
    private func setupLabels() {
        self.addSubview(fineLabel)
        
        fineLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(30)
            make.leading.equalTo(self.snp.leading).inset(36)
        }
        
        self.addSubview(attendanceProportionLabel)
        
        attendanceProportionLabel.snp.makeConstraints { make in
            make.top.equalTo(fineLabel.snp.bottom).offset(30)
            make.trailing.equalTo(self.snp.trailing).inset(36)
        }
    }
    
    private func setupProgressBar() {
        self.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(attendanceProportionLabel.snp.bottom).offset(6)
            make.centerX.equalTo(self)
            make.height.equalTo(progressViewHeight)
            make.width.equalTo(300)
        }
        
        progressView.dataSource = self
        progressView.delegate = self
    }
    
    private func setupProgress() {
        let total = studyAttendance.map { (_, value) in
            return value
        }.reduce(0, +)
        let attendanceRatio = Float(studyAttendance["출석"]! * 100 / total) / 100
        let latendssRatio = Float(studyAttendance["지각"]! * 100 / total) / 100
        let absenceRatio = Float(studyAttendance["결석"]! * 100 / total) / 100
        let allowedRatio = Float(studyAttendance["사유"]! * 100 / total) / 100
        
        self.progressView.setProgress(section: 0, to: attendanceRatio)
        self.progressView.setProgress(section: 1, to: latendssRatio)
        self.progressView.setProgress(section: 2, to: absenceRatio)
        self.progressView.setProgress(section: 3, to: allowedRatio)
        
        attendanceProportionLabel.text = "출석률 \(Double(attendanceRatio * 100).formatted(.number))%"
    }
}

extension AttendanceStatusReusableView: MultiProgressViewDataSource {
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

extension AttendanceStatusReusableView: MultiProgressViewDelegate {
    
    func progressView(_ progressView: MultiProgressView, didTapSectionAt index: Int) {
        print("Tapped section \(index)")
    }
}
