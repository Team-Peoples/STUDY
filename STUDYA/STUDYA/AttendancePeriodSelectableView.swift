//
//  AttendancePeriodSelectableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/17/22.
//

import UIKit
import SnapKit

class AttendancePeriodSelectableView: UIView {
    
    // MARK: - Properties
    
    var studyAttendance: [String: Int] = ["출석": 60,
                                          "지각": 15,
                                          "결석": 3,
                                          "사유": 5] {
        didSet {
            
        }
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(image: UIImage(named: "vote")!, text: " 상세내역")
        return lbl
    }()
    
    private let periodSettingButton = CustomButton(title: "22.06.01~22.08.20", textColor: .ppsGray1, borderColor: .ppsGray2, backgroundColor: .systemBackground, fontSize: 14, height: 30)
    
    private let roundedBackgroundView: RoundedView = {
        let v = RoundedView(cornerRadius: 16)
        v.backgroundColor = .appColor(.ppsGray3)
        return v
    }()
    
    /// header에 들어갈것
//    private let attendanceLabel = CustomLabel(title: "출석", tintColor: .ppsGray1, size: 14)
//    private let latenessLabel = CustomLabel(title: "지각", tintColor: .ppsGray1, size: 14)
//    private let absenceLabel = CustomLabel(title: "결석", tintColor: .ppsGray1, size: 14)
//    private let allowedLabel = CustomLabel(title: "사유", tintColor: .ppsGray1, size: 14)
//
    private let attendanceCountLabel = CustomLabel(title: "0", tintColor: .attendedMain, size: 14)
    private let latenessCountLabel = CustomLabel(title: "0", tintColor: .lateMain, size: 14)
    private let absenceCountLabel = CustomLabel(title: "0", tintColor: .absentMain, size: 14)
    private let allowedCountLabel = CustomLabel(title: "0", tintColor: .allowedMain, size: 14)
    private let fineLabel: UILabel = {
        let lbl = UILabel()
        lbl.attributedText = AttributedString.custom(frontLabel: "벌금 ", labelFontSize: 12, value: 99999, valueFontSize: 18, valueTextColor: .ppsGray1, withCurrency: true)
        return lbl
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        setupPeriodSettingButton()
        setupRoundedBackgroundView()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Configure
    
    func setupTitleLabel() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(30)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func setupPeriodSettingButton() {
        self.addSubview(periodSettingButton)
        periodSettingButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        
        periodSettingButton.snp.makeConstraints { make in
            make.top.equalTo(self).inset(30)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func setupRoundedBackgroundView() {
        self.addSubview(roundedBackgroundView)
        
        roundedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
    }
    
    func setupLabels() {
        let separater1 = UIView()
        let separater2 = UIView()
        let separater3 = UIView()
        
        separater1.backgroundColor = .appColor(.ppsGray2)
        separater2.backgroundColor = .appColor(.ppsGray2)
        separater3.backgroundColor = .appColor(.ppsGray2)
        
        roundedBackgroundView.addSubview(attendanceCountLabel)
        roundedBackgroundView.addSubview(separater1)
        roundedBackgroundView.addSubview(latenessCountLabel)
        roundedBackgroundView.addSubview(separater2)
        roundedBackgroundView.addSubview(absenceCountLabel)
        roundedBackgroundView.addSubview(separater3)
        roundedBackgroundView.addSubview(allowedCountLabel)
        roundedBackgroundView.addSubview(fineLabel)
        
        attendanceCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(roundedBackgroundView).offset(14)
        }
        separater1.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(attendanceCountLabel.snp.trailing).offset(6)
        }
        latenessCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater1.snp.trailing).offset(6)
        }
        separater2.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(latenessCountLabel.snp.trailing).offset(6)
        }
        absenceCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater2.snp.trailing).offset(6)
        }
        separater3.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(1)
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(absenceCountLabel.snp.trailing).offset(6)
        }
        allowedCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.leading.equalTo(separater3.snp.trailing).offset(6)
        }
        
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundedBackgroundView)
            make.trailing.equalTo(roundedBackgroundView.snp.trailing).inset(14)
        }
    }
}
