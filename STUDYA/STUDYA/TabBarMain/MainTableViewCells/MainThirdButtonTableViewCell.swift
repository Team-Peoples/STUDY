//
//  MainThirdButtonTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit
import SnapKit

final class MainThirdButtonTableViewCell: UITableViewCell {
    
    static let identifier = "MainThirdButtonTableViewCell"
    
    internal var attendanceInformation: AttendanceInformation?
    internal var schedule: StudySchedule? {
        didSet {
            guard let switchDelegate = navigatableSwitchObservableDelegate else { return }
            divider = ButtonStatusDivder(schedule: schedule, attendanceInformation: attendanceInformation, delegate: switchDelegate)
            configureButton()
        }
    }
//    navigatable & switch상태 알수있able로 바꿔서 아래에 있는 isSwitchOn 컨트롤하기
    internal weak var navigatableSwitchObservableDelegate: (Navigatable & SwitchStatusGivable)?
    private var divider: ButtonStatusDivder?
    
    let allowedSymbol = "allowedSymbol"
    
    private let mainButton = BrandButton(title: "", isBold: true, isFill: true, fontSize: 20)
    private let afterStudyView = RoundableView(cornerRadius: 25)

    private let symbolView = UIImageView()
    private let titleLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 20, isBold: true)
    private let innerView = RoundableView(cornerRadius: 22)
    private let attendedSubTitleLabel = CustomLabel(title: "오늘도 출석하셨군요!", tintColor: .whiteLabel, size: 14, isBold: true)
    private let penaltyLabel = CustomLabel(title: "벌금", tintColor: .whiteLabel, size: 14, isBold: true)
    private let fineLabel = CustomLabel(title: "00,000", tintColor: .whiteLabel, size: 20, isBold: true)
    private let wonLabel = CustomLabel(title: "원", tintColor: .whiteLabel, size: 14, isBold: true)
    
    private lazy var variousLabelsInView = [attendedSubTitleLabel, penaltyLabel, fineLabel, wonLabel]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        configureMainButton()
        configureAfterCheckView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func mainButtonTapped() {
        guard let delegate = navigatableSwitchObservableDelegate else { return }
        
//        switchStatus 도 가져오고 ismanager값이 true인지도 가져올까?
        if delegate.getSwtichStatus() { getCertificationCodeAndShowNextVC() } else { showValidationNumberFillingInVC() }
    }
    
    private func configureButton() {
        guard let divider = divider else { return }
        let buttonStatus = divider.getButtonStatus()
        
        hideEverythingForReload()
        
        switch buttonStatus {
            
        case .managerModeButtonEnabled:
            mainButton.isHidden = false
            mainButton.isEnabled = true
            mainButton.configureBorder(color: .keyColor1, width: 1, radius: 25)
            mainButton.setImage(UIImage(named: allowedSymbol)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            mainButton.fillIn(title: "  인증번호 확인")
            
        case .managerModeButtonDisabled:
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setImage(UIImage(named: allowedSymbol), for: .normal)
            mainButton.setTitle("  인증번호 확인", for: .normal)
            
        case .userModeNoSchedule:
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setImage(UIImage(named: allowedSymbol), for: .normal)
            mainButton.setTitle("  출석체크", for: .normal)
            
        case .userModeScheudleTooFarFromNow:
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setTitle("일정이 한참 남았어요", for: .normal)
            
        case .userModeScheduleMoreThanADayLeft(let days):
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setTitle("일정이 \(days)일 남았어요", for: .normal)
            
        case .userModeScheduleMoreThanThreeHoursLeft(let hours):
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setTitle("일정이 \(hours)일 남았어요", for: .normal)
            
        case .userModeScheudleQuiteFewLeft:
            mainButton.isHidden = false
            
            disableMainButton()
            
            mainButton.setTitle("곧 출석체크가 시작돼요", for: .normal)
            
        case .userModeAttendable:
            mainButton.isHidden = false
            mainButton.isEnabled = true
            mainButton.configureBorder(color: .keyColor1, width: 1, radius: 25)
            mainButton.setImage(UIImage(named: allowedSymbol)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            mainButton.fillIn(title: "  출석체크")
            
            
        case .userModeAttended:
            afterStudyView.isHidden = false
            attendedSubTitleLabel.isHidden = false
            
            afterStudyView.backgroundColor = .appColor(.attendedMain)
            symbolView.image = UIImage(named: "attendedSymbol")
            titleLabel.text = "출석"

            blink(innerView, attendedSubTitleLabel)
            
        case .userModelate(let fine):
            penaltyLabel.isHidden = false
            fineLabel.isHidden = false
            wonLabel.isHidden = false
            
            afterStudyView.backgroundColor = UIColor.appColor(.lateMain)
            symbolView.image = UIImage(named: "attendedSymbol")
            titleLabel.text = "지각"
            fineLabel.text = "\(fine)"
            
            blink(innerView, penaltyLabel, fineLabel, wonLabel)
            
        case .userModeAbsent(let fine):
            penaltyLabel.isHidden = false
            fineLabel.isHidden = false
            wonLabel.isHidden = false
            
            afterStudyView.backgroundColor = UIColor.appColor(.absentMain)
            symbolView.image = UIImage(named: "absentSymbol")
            titleLabel.text = "결석"
            fineLabel.text = "\(fine)"
            
            blink(innerView, penaltyLabel, fineLabel, wonLabel)
            
        case .userModeAllowed(let fine):
            penaltyLabel.isHidden = false
            fineLabel.isHidden = false
            wonLabel.isHidden = false
            
            afterStudyView.backgroundColor = UIColor.appColor(.allowedMain)
            symbolView.image = UIImage(named: allowedSymbol)
            titleLabel.text = "사유"
            fineLabel.text = "\(fine)"
            
            blink(innerView, penaltyLabel, fineLabel, wonLabel)
        }
    }
    
    private func disableMainButton() {
        mainButton.isEnabled = false
        mainButton.backgroundColor = .systemBackground
        mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
        mainButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
    }
    
    private func hideEverythingForReload() {
        mainButton.isHidden = true
        mainButton.setImage(nil, for: .normal)
        afterStudyView.isHidden = true
        variousLabelsInView.forEach{ $0.isHidden = true }
    }
    
    private func blink(_ innerView: UIView, _ label1: UILabel, _ label2: UILabel? = nil, _ label3: UILabel? = nil) {
        UIView.transition(with: self, duration: 0, options: .transitionCrossDissolve) {
            
            label1.textColor = .clear
            label1.textColor = .clear
            
            guard let l2 = label2, let l3 = label3 else { return }
            
            l2.textColor = .clear
            l3.textColor = .clear
            
        } completion: { f in
            UIView.transition(with: self, duration: 0.8, options: .transitionCrossDissolve) {
                
                innerView.backgroundColor = UIColor.appColor(.dimming)
                label1.textColor = .appColor(.whiteLabel)
                
                guard let l2 = label2, let l3 = label3 else { return }
                
                l2.textColor = .appColor(.whiteLabel)
                l3.textColor = .appColor(.whiteLabel)
            }
        }
    }
    
    private func getCertificationCodeAndShowNextVC() {
        guard let scheduleID = schedule?.studyScheduleID else { return }
        Network.shared.getAttendanceCertificationCode(scheduleID: scheduleID) { result in
            switch result {
            case .success(let code):
                DispatchQueue.main.async {
                    self.showValidationNumberCheckingVC(code: code)
                }
            case .failure(let error):
//                ehd: 이렇게 presenter에 프로토콜로 받아온 VC를 넣어도 되긴 하는데 이래도 되나?
                guard let vc = self.navigatableSwitchObservableDelegate else { return }
                UIAlertController.handleCommonErros(presenter: vc, error: error)
            }
        }
    }
    
    private func showValidationNumberCheckingVC(code: Int) {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: MainValidationNumberCheckingPopViewController.identifier) as! MainValidationNumberCheckingPopViewController
        
        vc.certificationCode = code
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        self.navigatableSwitchObservableDelegate?.present(vc)
    }
    
    private func showValidationNumberFillingInVC() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: MainValidationNumberFillingInPopViewController.identifier) as! MainValidationNumberFillingInPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatableSwitchObservableDelegate?.present(vc)
    }
    
    private func configureMainButton() {
        contentView.addSubview(mainButton)
        mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, bottomConstant: 20, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
    
    private func configureAfterCheckView() {
        addSubview(afterStudyView)
        afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, bottomConstant: 20, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        
        afterStudyView.addSubview(symbolView)
        afterStudyView.addSubview(titleLabel)
        afterStudyView.addSubview(innerView)
        
        variousLabelsInView.forEach{ afterStudyView.addSubview($0) }
        
        symbolView.snp.makeConstraints { make in
            make.centerY.equalTo(afterStudyView)
            make.leading.equalTo(afterStudyView).offset(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(afterStudyView)
            make.leading.equalTo(symbolView.snp.trailing).offset(15)
        }
        innerView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(afterStudyView).inset(3)
            make.leading.equalTo(titleLabel.snp.trailing).offset(50)
        }
        attendedSubTitleLabel.centerXY(inView: innerView)
        penaltyLabel.snp.makeConstraints { make in
            make.leading.equalTo(innerView).offset(20)
            make.centerY.equalTo(innerView).offset(3)
            make.trailing.greaterThanOrEqualTo(fineLabel).offset(10)
        }
        fineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(innerView)
            make.trailing.equalTo(innerView).inset(34)
        }
        wonLabel.snp.makeConstraints { make in
            make.leading.equalTo(fineLabel.snp.trailing).offset(3)
            make.centerY.equalTo(penaltyLabel)
        }
    }
}

struct ButtonStatusDivder {
    private let schedule: StudySchedule?
    private let attendanceInformation: AttendanceInformation?
    private let delegate: SwitchStatusGivable
    
    private let now = Date()
    private let calendar = Calendar.current
    
    private let oneHourInSeconds: TimeInterval = 3600
    private let oneMinuteInSeconds: TimeInterval = 60
    
    private var startDateAndTime: Date? {
        schedule?.startDateAndTime
    }
    private var timeBetweenTimes: TimeInterval? {
        startDateAndTime?.timeIntervalSince(now)
    }
    private var startDateComponents: DateComponents? {
        startDateAndTime?.convertToDateComponents([.year, .month, .day])
    }
    private var todayComponents: DateComponents {
        now.convertToDateComponents([.year, .month, .day])
    }
    
    init(schedule: StudySchedule?, attendanceInformation: AttendanceInformation?, delegate: SwitchStatusGivable) {
        self.schedule = schedule
        self.attendanceInformation = attendanceInformation
        self.delegate = delegate
    }
    
    internal func getButtonStatus() -> ButtonStatus {
        if schedule == nil {
            return getButtonStatusWhenNoSchedule()
        } else {
            return getButtonStatusWhenYesSchedule()
        }
    }
    
    private func getButtonStatusWhenNoSchedule() -> ButtonStatus {
        if delegate.getSwtichStatus() {
            return .managerModeButtonDisabled
        } else {
            return .userModeNoSchedule
        }
    }
    
    private func getButtonStatusWhenYesSchedule() -> ButtonStatus {
        if delegate.getSwtichStatus() {
            return getButtonStatusWhenYesScheudlePlusManagerMode()
        } else {
            return getButtonStatusWhenYesSchedulePlusUserMode()
        }
    }
    
    private func getButtonStatusWhenYesScheudlePlusManagerMode() -> ButtonStatus {
        guard let timeBetweenTimes = timeBetweenTimes else { return .managerModeButtonDisabled }

        if timeBetweenTimes > oneMinuteInSeconds * 10 {
            return .managerModeButtonDisabled
        } else {
            return .managerModeButtonEnabled
        }
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserMode() -> ButtonStatus {
        guard let _ = schedule,
              let timeBetweenTimes = timeBetweenTimes else { return .userModeNoSchedule }
        if timeBetweenTimes > oneHourInSeconds * 24 * 100 {
            return getButtonStatusWhenYesSchedulePlusUserModePlusScheduleTooFarFromNow()
        } else if timeBetweenTimes > oneHourInSeconds * 24 {
            return getButtonStatusWhenYesSchedulePlusUserModePlusMoreThanADayLeft()
        } else if timeBetweenTimes > oneHourInSeconds * 3 {
            return getButtonStatusWhenYesSchedulePlusUserModePlusMoreThanThreeHoursLeft()
        } else if timeBetweenTimes > oneMinuteInSeconds * 10 {
            return getButtonStatusWhenYesSchedulePlusUserModePlusQuiteFewLeft()
        } else {
            return getButtonStatusWhenYesSchedulePlusUserModePlusLessThanTenMinutesLeft()
        }
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserModePlusScheduleTooFarFromNow() -> ButtonStatus {
        return .userModeScheudleTooFarFromNow
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserModePlusMoreThanADayLeft() -> ButtonStatus {
        guard let startDateComponents = startDateComponents,
              let startDateMidnight = calendar.date(from: startDateComponents),
              let todayMidnight = calendar.date(from: todayComponents),
              let dayDifference = calendar.dateComponents([.day], from: todayMidnight, to: startDateMidnight).day else { return .userModeNoSchedule }
        
        return .userModeScheduleMoreThanADayLeft(dayDifference)
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserModePlusMoreThanThreeHoursLeft() -> ButtonStatus {
        guard let startDateAndTime = startDateAndTime,
              let hourDifference = calendar.dateComponents([.hour], from: now, to: startDateAndTime).hour else { return .userModeNoSchedule }
        
        return .userModeScheduleMoreThanThreeHoursLeft(hourDifference)
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserModePlusQuiteFewLeft() -> ButtonStatus {
        return .userModeScheudleQuiteFewLeft
    }
    
    private func getButtonStatusWhenYesSchedulePlusUserModePlusLessThanTenMinutesLeft() -> ButtonStatus {
        guard let attendanceInformation = attendanceInformation,
              let attendanceStatus = attendanceInformation.attendanceStatus else { return .userModeAttendable }
        
        switch attendanceStatus {
        case .attended:
            return .userModeAttended
        case .late:
            return .userModelate(attendanceInformation.fine)
        case .absent:
            return .userModeAbsent(attendanceInformation.fine)
        case .allowed:
            return .userModeAllowed(attendanceInformation.fine)
        }
    }
}

enum ButtonStatus {
    case managerModeButtonEnabled
    case managerModeButtonDisabled
    
    case userModeNoSchedule
    
    case userModeScheudleTooFarFromNow
    case userModeScheduleMoreThanADayLeft(Int)
    case userModeScheduleMoreThanThreeHoursLeft(Int)
    case userModeScheudleQuiteFewLeft
    
    case userModeAttendable
    case userModeAttended
    case userModelate(Int)
    case userModeAbsent(Int)
    case userModeAllowed(Int)
}
