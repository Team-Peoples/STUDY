//
//  AttendanceBottomMembersPeriodSearchSettingView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/25.
//

import UIKit

final class AttendanceBottomMembersPeriodSearchSettingView: FullDoneButtonButtomView {
    
    internal var navigatableDelegate: UIViewController! {
        didSet {
            print(navigatableDelegate)
        }
    }
    
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {
        
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .appColor(.ppsGray3)
        
        return v
    }()
    private let sortTitleLabel = CustomLabel(title: "정렬기준", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var nameInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "이름순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private lazy var attendanceInOrderButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "출석순", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changeOrderType))
    private let periodTitleLabel = CustomLabel(title: "기간 설정", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var allPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "전체", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changePeriodType))
    private lazy var customPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "직접설정", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(changePeriodType))
    private let backgroundContainerView = RoundableView(cornerRadius: 12)
    private let precedingDayLabel = CustomLabel(title: "22.06.10", tintColor: .ppsGray1, size: 16, isBold: false)
    private let middleLabel = CustomLabel(title: "~", tintColor: .ppsGray1, size: 16, isBold: false)
    private let follwingDayLabel = CustomLabel(title: "23.01.14", tintColor: .ppsGray1, size: 16, isBold: false)
    private lazy var stackView: UIStackView = {
       
        let s = UIStackView(arrangedSubviews: [precedingDayLabel, middleLabel, follwingDayLabel])
        
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.spacing = 32
        
        return s
    }()
    private lazy var selectPeriodButton = UIButton(frame: .zero)
    
    override init(doneButtonTitle: String) {
        super.init(doneButtonTitle: doneButtonTitle)
        
        backgroundContainerView.backgroundColor = .appColor(.ppsGray3)
        selectPeriodButton.addTarget(self, action: #selector(selectPeriodButtonTapped), for: .touchUpInside)
        
        backgroundColor = .systemBackground
        
        nameInOrderButton.isSelected = true
        allPeriodButton.isSelected = true
        
        addSubviews()
        setConstraints()
        configureDoneButton(on: self, under: backgroundContainerView, constant: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeOrderType() {
        nameInOrderButton.toggle()
        attendanceInOrderButton.toggle()
    }
    
    @objc private func changePeriodType() {
        allPeriodButton.toggle()
        customPeriodButton.toggle()
    }
    
    @objc private func selectPeriodButtonTapped() {
        print(#function, 1)
        let vc = AttendancePopUpPeriodCalendarViewController()
        vc.presentingVC = navigatableDelegate
        navigatableDelegate.present(vc, animated: true)
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(sortTitleLabel)
        addSubview(nameInOrderButton)
        addSubview(attendanceInOrderButton)
        addSubview(periodTitleLabel)
        addSubview(allPeriodButton)
        addSubview(customPeriodButton)
        addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(stackView)
        backgroundContainerView.addSubview(selectPeriodButton)
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
        sortTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        nameInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(sortTitleLabel.snp.bottom).offset(12)
        }
        attendanceInOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(nameInOrderButton.snp.trailing).offset(14)
            make.trailing.equalTo(self).inset(18)
            make.top.width.equalTo(nameInOrderButton)
        }
        periodTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sortTitleLabel.snp.leading)
            make.top.equalTo(nameInOrderButton.snp.bottom).offset(26)
        }
        allPeriodButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameInOrderButton)
            make.top.equalTo(periodTitleLabel.snp.bottom).offset(12)
        }
        customPeriodButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(attendanceInOrderButton)
            make.top.equalTo(allPeriodButton.snp.top)
        }
        backgroundContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(36)
            make.top.equalTo(customPeriodButton.snp.bottom).offset(14)
            make.height.equalTo(30)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(backgroundContainerView)
        }
        selectPeriodButton.snp.makeConstraints { make in
            make.edges.equalTo(backgroundContainerView)
        }
    }
}
