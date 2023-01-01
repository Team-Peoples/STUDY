//
//  MainThirdButtonTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/15.
//

import UIKit
import SnapKit

class MainThirdButtonTableViewCell: UITableViewCell {

    static let identifier = "MainThirdButtonTableViewCell"
    
    internal var schedule: StudySchedule? {
        didSet {
            print("📣")
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
//            위의 스케줄에서 받은 didAttend
            if didAttend {
//                출석상태 별 뷰 띄우기
                print("📕")
//                addSubview(afterStudyView)
//                afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
            } else {
                mainButton.isHidden = false
                if timeBetweenTimes > oneHourInSeconds * 24 {
                    
                    guard let startDateMidnight = calendar.date(from: startDateComponents),
                          let todayMidnight = calendar.date(from: todayComponents),
                          let dayDifference = calendar.dateComponents([.day], from: todayMidnight, to: startDateMidnight).day else { return }

                    mainButton.setTitle("일정이 \(dayDifference)일 남았어요", for: .normal)
                } else if timeBetweenTimes > oneHourInSeconds * 3 {
                    guard let hourDifference = calendar.dateComponents([.hour], from: now, to: startTime).hour else { return }
                    
                    mainButton.setTitle("일정이 \(hourDifference)시간 남았어요", for: .normal)
                } else if timeBetweenTimes > oneMinuteInSeconds * 10 {
                    mainButton.setTitle("곧 출석체크가 시작돼요", for: .normal)
                } else {
                    mainButton.isEnabled = true
                    
                    if isManagerMode {
                        
                        mainButton.addTarget(self, action: #selector(mainButtonTappedWhenManager), for: .touchUpInside)
//                        mainButton = BrandButton(title: "", isBold: true, isFill: true, fontSize: 20)
                        mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                        mainButton.fillIn(title: "  인증번호 확인")
                    } else {
                        mainButton.addTarget(self, action: #selector(mainButtonTappedWhenNotManager), for: .touchUpInside)
                        mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                        mainButton.fillIn(title: "  출석하기")
                    }
                }
            }
        }
    }
    
    internal var navigatable: Navigatable!
    
    internal var attendable = true
    internal var didAttend = false
    internal var isManagerMode = true
    internal var attendanceStatus: AttendanceStatus? {
        didSet {
            afterStudyView.isHidden = false
            contentView.addSubview(afterStudyView)
            afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
        }
    }
    
    private lazy var mainButton = BrandButton(title: "", isBold: true, isFill: true, fontSize: 20)
    private lazy var afterStudyView: RoundableView = {

        let v = RoundableView(cornerRadius: 25)

        let symbolView = UIImageView()
        var titleLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 20, isBold: true)
        let innerView = RoundableView(cornerRadius: 22)

        v.addSubview(symbolView)
        v.addSubview(titleLabel)
        v.addSubview(innerView)

        symbolView.snp.makeConstraints { make in
            make.centerY.equalTo(v)
            make.leading.equalTo(v).offset(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(v)
            make.leading.equalTo(symbolView.snp.trailing).offset(15)
        }
        innerView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(v).inset(3)
            make.leading.equalTo(titleLabel.snp.trailing).offset(50)
        }

        if attendanceStatus == .attended {

            v.backgroundColor = UIColor.appColor(.attendedMain)
            symbolView.image = UIImage(named: "attendedSymbol")
            titleLabel.text = "출석"

            let subTitleLabel = CustomLabel(title: "오늘도 출석하셨군요!", tintColor: .whiteLabel, size: 14, isBold: true)

            v.addSubview(subTitleLabel)
            subTitleLabel.centerXY(inView: innerView)
            
            blink(innerView, subTitleLabel)
        } else {

            let penaltyLabel = CustomLabel(title: "벌금", tintColor: .whiteLabel, size: 14, isBold: true)
            let fineLabel = CustomLabel(title: "00,000", tintColor: .whiteLabel, size: 20, isBold: true)
            let wonLabel = CustomLabel(title: "원", tintColor: .whiteLabel, size: 14, isBold: true)

            v.addSubview(penaltyLabel)
            v.addSubview(fineLabel)
            v.addSubview(wonLabel)

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
            
            blink(innerView, penaltyLabel, fineLabel, wonLabel)
            
            switch attendanceStatus {
            case .late:
                v.backgroundColor = UIColor.appColor(.lateMain)
                symbolView.image = UIImage(named: "attendedSymbol")
                titleLabel.text = "출석"
            case .absent:
                v.backgroundColor = UIColor.appColor(.absentMain)
                symbolView.image = UIImage(named: "absentSymbol")
                titleLabel.text = "지각"
            case .allowed:
                v.backgroundColor = UIColor.appColor(.allowedMain)
                symbolView.image = UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                titleLabel.text = "사유"
            default: break
            }
        }

        return v
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print(#function)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        configureMainButton()
        configureAfterCheckView()
        
        mainButton.isHidden = true
        afterStudyView.isHidden = true
        
//        if isManagerMode {
//
//            if attendable {
//                mainButton.addTarget(self, action: #selector(mainButtonTappedWhenManager), for: .touchUpInside)
//                mainButton = BrandButton(title: "", isBold: true, isFill: true, fontSize: 20)
//                mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
//                mainButton.fillIn(title: "  인증번호 확인")
//                mainButton.addTarget(self, action: #selector(mainButtonTappedWhenManager), for: .touchUpInside)
//            } else {
//                mainButton = BrandButton(title: "", isBold: true, isFill: false, fontSize: 20)
//                mainButton.setImage(UIImage(named: "allowedSymbol"), for: .normal)
//                mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
//                mainButton.fillOut(title: "  인증번호 확인")
//                mainButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
//                mainButton.isEnabled = false
//            }
//        } else {
//
//            if didAttend {
//                addSubview(afterStudyView)
//                afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
//            } else {
//
//                if attendable {
//                    mainButton.addTarget(self, action: #selector(mainButtonTappedWhenNotManager), for: .touchUpInside)
//                    mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
//                    mainButton.fillIn(title: "  출석하기")
//                } else {
//                    mainButton.setImage(UIImage(named: "allowedSymbol"), for: .normal)
//                    mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
//                    mainButton.fillOut(title: "  출석하기")
//                    mainButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
//                    mainButton.isEnabled = false
//                }
//
//                addSubview(mainButton)
//                mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
//            }
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func mainButtonTappedWhenManager() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ValidationNumberCheckingPopViewController") as! ValidationNumberCheckingPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatable.present(vc)
    }
    
    @objc private func mainButtonTappedWhenNotManager() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ValidationNumberFillingInPopViewController") as! ValidationNumberFillingInPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatable.present(vc)
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
    
    private func configureMainButton() {
        contentView.addSubview(mainButton)
        mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, bottomConstant: 20, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
    
    private func configureAfterCheckView() {
        addSubview(afterStudyView)
        afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
    }
}
