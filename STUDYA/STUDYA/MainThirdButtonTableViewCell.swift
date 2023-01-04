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
    
    internal var schedule: StudySchedule? {
        didSet {
            willHideViews.forEach { view in
                view.isHidden = true
            }
            
            guard let schedule = schedule else {
                
                mainButton.setImage(UIImage(named: "allowedSymbol"), for: .normal)
                mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
                mainButton.fillOut(title: "  출석체크")
                mainButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
                mainButton.isEnabled = false
                
                return
            }
            
            guard let startTime = schedule.startTime, let endTime = schedule.endTime else { return }
            
            let now = Date()
            let calendar = Calendar.current
            
            let timeBetweenTimes = startTime.timeIntervalSince(now)
            let oneHourInSeconds: TimeInterval = 3600
            let oneMinuteInSeconds: TimeInterval = 60
            
            let startDateComponents = calendar.dateComponents([.year, .month, .day], from: startTime)
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
            
            mainButton.isEnabled = false
//            🛑위의 스케줄에서 받은 didAttend
            if didAttend {
//                출석상태 별 뷰 띄우기 (지금은 attendanceStatus didSet에서 하고 있음.
                afterStudyView.isHidden = false
            } else {
                mainButton.isHidden = false
                if timeBetweenTimes > oneHourInSeconds * 24 {
                    
                    guard let startDateMidnight = calendar.date(from: startDateComponents),
                          let todayMidnight = calendar.date(from: todayComponents),
                          let dayDifference = calendar.dateComponents([.day], from: todayMidnight, to: startDateMidnight).day else { return }

                    mainButton.setImage(nil, for: .normal)
                    mainButton.setTitle("일정이 \(dayDifference)일 남았어요", for: .normal)
                    
                } else if timeBetweenTimes > oneHourInSeconds * 3 {
                    guard let hourDifference = calendar.dateComponents([.hour], from: now, to: startTime).hour else { return }
                    
                    mainButton.setImage(nil, for: .normal)
                    mainButton.setTitle("일정이 \(hourDifference)시간 남았어요", for: .normal)
                } else if timeBetweenTimes > oneMinuteInSeconds * 10 {
                    
                    mainButton.setImage(nil, for: .normal)
                    mainButton.setTitle("곧 출석체크가 시작돼요", for: .normal)
                    
                } else {
                    mainButton.isEnabled = true
                    mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                    
                    guard let delegate = navigatableSwitchObservableDelegate else { return }
                    delegate.getSwtichStatus() ? mainButton.fillIn(title: "  인증번호 확인") : mainButton.fillIn(title: "  출석하기")
                }
            }
        }
    }
//    navigatable & switch상태 알수있able로 바꿔서 아래에 있는 isSwitchOn 컨트롤하기
    internal weak var navigatableSwitchObservableDelegate: (Navigatable & SwitchStatusGivable)?
    
    internal var attendable = true
    internal var didAttend = false
    internal var attendanceStatus: AttendanceStatus? {
        didSet {
//        guard 출석 이미 했을 때 else { return }
            afterStudyView.isHidden = false
            decorateAfterCheckView()
        }
    }
    
    private let mainButton = BrandButton(title: "", isBold: true, isFill: true, fontSize: 20)
    private let afterStudyView = RoundableView(cornerRadius: 25)

    private let symbolView = UIImageView()
    private let titleLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 20, isBold: true)
    private let innerView = RoundableView(cornerRadius: 22)
    private let subTitleLabel = CustomLabel(title: "오늘도 출석하셨군요!", tintColor: .whiteLabel, size: 14, isBold: true)
    private let penaltyLabel = CustomLabel(title: "벌금", tintColor: .whiteLabel, size: 14, isBold: true)
    private let fineLabel = CustomLabel(title: "00,000", tintColor: .whiteLabel, size: 20, isBold: true)
    private let wonLabel = CustomLabel(title: "원", tintColor: .whiteLabel, size: 14, isBold: true)
    
    private lazy var willHideViews = [subTitleLabel, penaltyLabel, fineLabel, wonLabel]

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
        if delegate.getSwtichStatus() { getCertificationCodeAndShowNextVC() } else { showValidationNumberFillingInVC() }
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
    
    private func decorateAfterCheckView() {
        
        if attendanceStatus == .attended {
            subTitleLabel.isHidden = false
            
            afterStudyView.backgroundColor = UIColor.appColor(.attendedMain)
            symbolView.image = UIImage(named: "attendedSymbol")
            titleLabel.text = "출석"

            blink(innerView, subTitleLabel)
            
        } else {
            penaltyLabel.isHidden = false
            fineLabel.isHidden = false
            wonLabel.isHidden = false
            
            switch attendanceStatus {
            case .late:
                afterStudyView.backgroundColor = UIColor.appColor(.lateMain)
                symbolView.image = UIImage(named: "attendedSymbol")
                titleLabel.text = "출석"
            case .absent:
                afterStudyView.backgroundColor = UIColor.appColor(.absentMain)
                symbolView.image = UIImage(named: "absentSymbol")
                titleLabel.text = "지각"
            case .allowed:
                afterStudyView.backgroundColor = UIColor.appColor(.allowedMain)
                symbolView.image = UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                titleLabel.text = "사유"
            default: break
            }
            
            blink(innerView, penaltyLabel, fineLabel, wonLabel)
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
        let vc  = storyboard.instantiateViewController(withIdentifier: ValidationNumberCheckingPopViewController.identifier) as! ValidationNumberCheckingPopViewController
        
        vc.certificationCode = code
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        self.navigatableSwitchObservableDelegate?.present(vc)
    }
    
    private func showValidationNumberFillingInVC() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: ValidationNumberFillingInPopViewController.identifier) as! ValidationNumberFillingInPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatableSwitchObservableDelegate?.present(vc)
    }
    
    private func configureMainButton() {
        mainButton.isHidden = true
        contentView.addSubview(mainButton)
        mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, bottomConstant: 20, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
    
    private func configureAfterCheckView() {
        afterStudyView.isHidden = true
        addSubview(afterStudyView)
        afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, bottomConstant: 20, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        
        afterStudyView.addSubview(symbolView)
        afterStudyView.addSubview(titleLabel)
        afterStudyView.addSubview(innerView)
        
        willHideViews.forEach { view in
            afterStudyView.addSubview(view)
        }

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
        subTitleLabel.centerXY(inView: innerView)
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
