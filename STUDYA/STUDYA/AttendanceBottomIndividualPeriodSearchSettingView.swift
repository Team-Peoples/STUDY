//
//  AttendanceBottomIndividualPeriodSearchSettingView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/26.
//

import UIKit

final class AttendanceBottomIndividualPeriodSearchSettingView: FullDoneButtonButtomView {
    
    internal weak var dateLabelUpdatableDelegate: DateLabelUpdatable?
    internal weak var navigatableDelegate: Navigatable?
    
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {
        
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .appColor(.ppsGray3)
        
        return v
    }()
    private let periodSettingLabel = CustomLabel(title: "기간설정", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var allPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "전체", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private lazy var customPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "직접설정", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private let backgroundContainerView = RoundableView(cornerRadius: 12)
    private let precedingDayLabel = CustomLabel(title: "22.06.10", tintColor: .ppsGray1, size: 16, isBold: false)
    private let middleLabel = CustomLabel(title: "~", tintColor: .ppsGray1, size: 16, isBold: false)
    private let followingDayLabel = CustomLabel(title: "23.01.14", tintColor: .ppsGray1, size: 16, isBold: false)
    private lazy var stackView: UIStackView = {
       
        let s = UIStackView(arrangedSubviews: [precedingDayLabel, middleLabel, followingDayLabel])
        
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.spacing = 32
        
        return s
    }()
    private lazy var selectDayButton = UIButton(frame: .zero)
    
    override init(doneButtonTitle: String) {
        super.init(doneButtonTitle: doneButtonTitle)
        
        backgroundColor = .systemBackground
        backgroundContainerView.backgroundColor = .appColor(.ppsGray3)
        
        allPeriodButton.isSelected = true
        
        selectDayButton.addTarget(self, action: #selector(selectPeriodButtonTapped), for: .touchUpInside)
        
        addSubviews()
        setConstraints()
        configureDoneButton(on: self, under: backgroundContainerView, constant: 37)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeOrderType() {
        allPeriodButton.toggle()
        customPeriodButton.toggle()
    }
    
    @objc private func selectPeriodButtonTapped() {
        print(#function)
        let vc = AttendancePopUpPeriodCalendarViewController()
        vc.dateLabelUpdatableDelegate = dateLabelUpdatableDelegate
        navigatableDelegate?.present(vc)
    }
    
    internal func setPrecedingDateLabel(with date: Date) {
        precedingDayLabel.text = date.formatToString(language: .eng)
    }
    
    internal func setFollowingDateLabel(with date: Date) {
        followingDayLabel.text = date.formatToString(language: .eng)
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(periodSettingLabel)
        addSubview(allPeriodButton)
        addSubview(customPeriodButton)
        addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(stackView)
        backgroundContainerView.addSubview(selectDayButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).inset(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        periodSettingLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        allPeriodButton.snp.makeConstraints { make in
            make.leading.equalTo(periodSettingLabel.snp.leading)
            make.top.equalTo(periodSettingLabel.snp.bottom).offset(12)
        }
        customPeriodButton.snp.makeConstraints { make in
            make.leading.equalTo(allPeriodButton.snp.trailing).offset(14)
            make.trailing.equalTo(self).inset(18)
            make.top.width.equalTo(allPeriodButton)
        }
        backgroundContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(36)
            make.top.equalTo(customPeriodButton.snp.bottom).offset(14)
            make.height.equalTo(30)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(backgroundContainerView)
        }
        selectDayButton.snp.makeConstraints { make in
            make.edges.equalTo(backgroundContainerView)
        }
    }
}
