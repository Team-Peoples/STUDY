//
//  AttendanceTableViewCells.swift
//  STUDYA
//
//  Created by 서동운 on 11/18/22.
//

import UIKit

final class AttendanceDetailsCell: UITableViewCell {

    // MARK: - Properties
    internal var viewModel: AttendanceForAMemberViewModel?
    internal var bottomSheetAddableDelegate: BottomSheetAddable?
    
    private let titleLabel = UILabel(frame: .zero)
    private let periodSettingButton = BrandButton(title: "", textColor: .ppsGray1, borderColor: .ppsGray2, backgroundColor: .systemBackground, fontSize: 14, height: 30)
    private let roundedBackgroundView = RoundableView(cornerRadius: 16)
    
    private let attendanceCountLabel = CustomLabel(title: "", tintColor: .attendedMain, size: 14)
    private let latenessCountLabel = CustomLabel(title: "", tintColor: .lateMain, size: 14)
    private let absenceCountLabel = CustomLabel(title: "", tintColor: .absentMain, size: 14)
    private let allowedCountLabel = CustomLabel(title: "", tintColor: .allowedMain, size: 14)
    private let fineLabel = UILabel(frame: .zero)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func periodSettingButtonDidTapped() {
        guard let viewModel = viewModel else { return }
        let bottomVC = AttendanceBottomIndividualPeriodSearchSettingBottomViewController(doneButtonTitle: "조회")
        
        bottomVC.viewModel = viewModel
        bottomVC.configureDayLabelsWith(precedingDate: viewModel.precedingDate.value, followingDate: viewModel.followingDate.value)
        
        bottomSheetAddableDelegate?.presentBottomSheet(vc: bottomVC, detent: 291, prefersGrabberVisible: false)
    }
    
    internal func configureCell(with viewModel: AttendanceForAMemberViewModel) {
        self.viewModel = viewModel
        setBinding()
        
        guard let attendance = viewModel.attendanceOverall else { return }
        
        attendanceCountLabel.text = attendance.attendedCount.toString()
        latenessCountLabel.text = attendance.lateCount.toString()
        absenceCountLabel.text = attendance.absentCount.toString()
        allowedCountLabel.text = attendance.allowedCount.toString()
        
        fineLabel.attributedText = AttributedString.custom(frontLabel: "", labelFontSize: 12, value: attendance.totalFine, valueFontSize: 18, valueTextColor: .ppsGray1, withCurrency: true)
    }
    
    // MARK: - Configure
    
    private func setBinding() {
        guard let viewModel = viewModel else { return }
        viewModel.followingDate.bind({ date in
            self.periodSettingButton.setTitle("\(viewModel.precedingDate.value)~\(date)", for: .normal)
        })
    }
    
    private func configureViews() {
        titleLabel.attributedText = AttributedString.custom(image: UIImage(named: "details") ?? UIImage(), text: " 상세 내역")
        
        configurePeriodButton()
        
        roundedBackgroundView.backgroundColor = .appColor(.ppsGray3)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(periodSettingButton)
        contentView.addSubview(roundedBackgroundView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.leading.equalTo(contentView).inset(20)
        }
        periodSettingButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.trailing.equalTo(contentView).inset(20)
        }
        roundedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalTo(contentView).inset(20)
            make.height.equalTo(56)
        }
        
        setupLabels()
    }
    
    private func configurePeriodButton() {
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)
        
        let shortenDottedToday = DateFormatter.shortenDottedDateFormatter.string(from: today)
        let shortenDottedThirtyDaysAgo = DateFormatter.shortenDottedDateFormatter.string(from: thirtyDaysAgo ?? today)
        
        periodSettingButton.setTitle("\(shortenDottedThirtyDaysAgo)~\(shortenDottedToday)", for: .normal)
        
        periodSettingButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        periodSettingButton.addTarget(self, action: #selector(periodSettingButtonDidTapped), for: .touchUpInside)
    }
    
    private func setupLabels() {
        
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
