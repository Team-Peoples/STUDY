//
//  AttendanceBottomIndividualPeriodSearchSettingBottomViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/26.
//

import UIKit

final class AttendanceBottomIndividualPeriodSearchSettingBottomViewController: FullDoneButtonButtonViewController {
       
    internal var viewModel: AttendanceForAMemberViewModel?
    
    private var tempPrecedingDate: ShortenDottedDate?
    private var tempFollowingDate: ShortenDottedDate?
    
    private let titleLabel = CustomLabel(title: "조회조건설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let separator: UIView = {
        
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .appColor(.ppsGray3)
        
        return v
    }()
    private let periodSettingLabel = CustomLabel(title: "기간설정", tintColor: .ppsBlack, size: 14, isBold: true)
    private lazy var allPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "전체", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(turnOnAllPeriodButton))
    private lazy var customPeriodButton = CustomButton(fontSize: 14, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 36, normalBorderColor: .ppsGray2, normalTitle: "직접설정", selectedTitleColor: .keyColor1, selectedBorderColor: .keyColor1, target: self, action: #selector(turnOnCustomPeriodButton))
    private let backgroundContainerView = RoundableView(cornerRadius: 12)
    private let precedingDayLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 16, isBold: false)
    private let middleLabel = CustomLabel(title: "~", tintColor: .ppsGray1, size: 16, isBold: false)
    private let followingDayLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 16, isBold: false)
    private lazy var stackView: UIStackView = {
       
        let s = UIStackView(arrangedSubviews: [precedingDayLabel, middleLabel, followingDayLabel])
        
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.spacing = 32
        
        return s
    }()
    private let selectDayButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        backgroundContainerView.backgroundColor = .appColor(.ppsGray3)

        setViewsInitially()
        configureViews()
        configureDoneButton(under: backgroundContainerView, constant: 37)
    }
    
    override func doneButtonTapped() {
        if allPeriodButton.isSelected {
            viewModel?.getUserAttendanceOverallFromEndToEnd()
        } else {
            guard let precedingDashedDate = tempPrecedingDate?.convertShortenDottedDateToDashedDate(),
                  let followingDashedDate = tempFollowingDate?.convertShortenDottedDateToDashedDate() else { return }
            viewModel?.getUserAttendanceOverall(between: precedingDashedDate, and: followingDashedDate)
        }
        
        dismiss(animated: true)
    }
    
    @objc private func turnOnAllPeriodButton() {
        allPeriodButton.isSelected = true
        customPeriodButton.isSelected = false
        
        precedingDayLabel.text = DateFormatter.shortenDottedDateFormatter.string(from: viewModel?.studyStartDate ?? Date())
        followingDayLabel.text = DateFormatter.shortenDottedDateFormatter.string(from: Date())
        
        precedingDayLabel.textColor = .appColor(.ppsGray2)
        followingDayLabel.textColor = .appColor(.ppsGray2)
        
        selectDayButton.isEnabled = false
    }
    
    @objc private func turnOnCustomPeriodButton() {
        allPeriodButton.isSelected = false
        customPeriodButton.isSelected = true
        
        precedingDayLabel.text = tempPrecedingDate ?? "??"
        followingDayLabel.text = tempFollowingDate ?? "??"
        
        precedingDayLabel.textColor = .appColor(.ppsGray1)
        followingDayLabel.textColor = .appColor(.ppsGray1)
        
        selectDayButton.isEnabled = true
    }
    
    @objc private func selectPeriodButtonTapped() {
        let vc = AttendancePopUpPeriodCalendarViewController()
        vc.dateLabelUpdatableDelegate = self
        vc.setDateButtonsTitleWith(precedingDate: tempPrecedingDate ?? "", followingDate: tempFollowingDate ?? "")
        present(vc, animated: true)
    }
    
    internal func configureDayLabelsWith(precedingDate: ShortenDottedDate, followingDate: ShortenDottedDate) {
        self.tempPrecedingDate = precedingDate
        self.tempFollowingDate = followingDate
        
        precedingDayLabel.text = precedingDate
        followingDayLabel.text = followingDate
    }
    
    private func setViewsInitially() {
        enableDoneButton()
        
        customPeriodButton.isSelected = true
        selectDayButton.addTarget(self, action: #selector(selectPeriodButtonTapped), for: .touchUpInside)
        
        precedingDayLabel.textColor = .appColor(.ppsGray1)
        followingDayLabel.textColor = .appColor(.ppsGray1)
        
        selectDayButton.isEnabled = true
    }
    
    private func configureViews() {
        view.addSubview(titleLabel)
        view.addSubview(separator)
        view.addSubview(periodSettingLabel)
        view.addSubview(allPeriodButton)
        view.addSubview(customPeriodButton)
        view.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(stackView)
        backgroundContainerView.addSubview(selectDayButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).inset(24)
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        periodSettingLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(separator.snp.bottom).offset(24)
        }
        allPeriodButton.snp.makeConstraints { make in
            make.leading.equalTo(periodSettingLabel.snp.leading)
            make.top.equalTo(periodSettingLabel.snp.bottom).offset(12)
        }
        customPeriodButton.snp.makeConstraints { make in
            make.leading.equalTo(allPeriodButton.snp.trailing).offset(14)
            make.trailing.equalTo(view).inset(18)
            make.top.width.equalTo(allPeriodButton)
        }
        backgroundContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(36)
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

extension AttendanceBottomIndividualPeriodSearchSettingBottomViewController: DateLabelUpdatable {
    func updateDateLabels(preceding: ShortenDottedDate, following: ShortenDottedDate) {
        tempPrecedingDate = preceding
        tempFollowingDate = following
        
        precedingDayLabel.text = preceding
        followingDayLabel.text = following
    }
}
