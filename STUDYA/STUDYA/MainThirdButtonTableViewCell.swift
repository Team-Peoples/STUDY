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
    internal var navigatable: Navigatable!
    
    internal var attendable = true
    internal var didAttend = false
    internal var isManagerMode = true
    internal var attendanceStatus: AttendanceStatus? = AttendanceStatus.allowed
    
    private lazy var mainButton = CustomButton(title: "", isBold: true, isFill: true, fontSize: 20)
    private lazy var afterStudyView: RoundableView = {

        let v = RoundableView()

        let symbolView = UIImageView()
        var titleLabel = CustomLabel(title: "", tintColor: .whiteLabel, size: 20, isBold: true)
        let innerView = RoundableView()

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

        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = UIColor.appColor(.background)

        if isManagerMode {
            
            if attendable {
                mainButton.addTarget(self, action: #selector(mainButtonTappedWhenManager), for: .touchUpInside)
                mainButton = CustomButton(title: "", isBold: true, isFill: true, fontSize: 20)
                mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                mainButton.fillIn(title: "  인증번호 확인")
                mainButton.addTarget(self, action: #selector(mainButtonTappedWhenManager), for: .touchUpInside)
            } else {
                mainButton = CustomButton(title: "", isBold: true, isFill: false, fontSize: 20)
                mainButton.setImage(UIImage(named: "allowedSymbol"), for: .normal)
                mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
                mainButton.fillOut(title: "  인증번호 확인")
                mainButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
                mainButton.isEnabled = false
            }
            
            addSubview(mainButton)
            mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
            
        } else {
            
            if didAttend {
                addSubview(afterStudyView)
                afterStudyView.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
            } else {
                
                if attendable {
                    mainButton.addTarget(self, action: #selector(mainButtonTappedWhenNotManager), for: .touchUpInside)
                    mainButton.setImage(UIImage(named: "allowedSymbol")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                    mainButton.fillIn(title: "  출석하기")
                    mainButton.addTarget(self, action: #selector(mainButtonTappedWhenNotManager), for: .touchUpInside)
                } else {
                    mainButton.setImage(UIImage(named: "allowedSymbol"), for: .normal)
                    mainButton.configureBorder(color: .ppsGray2, width: 1, radius: 25)
                    mainButton.fillOut(title: "  출석하기")
                    mainButton.setTitleColor(UIColor.appColor(.ppsGray2), for: .normal)
                    mainButton.isEnabled = false
                }
                
                addSubview(mainButton)
                mainButton.anchor(top: topAnchor, topConstant: 20, bottom: bottomAnchor, leading: leadingAnchor, leadingConstant: 20, trailing: trailingAnchor, trailingConstant: 20)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func mainButtonTappedWhenManager() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ValidationNumberCheckingPopViewController") as! ValidationNumberCheckingPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatable.present(vc: vc)
    }
    
    @objc private func mainButtonTappedWhenNotManager() {
        let storyboard = UIStoryboard(name: "MainPopOverViewControllers", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ValidationNumberFillingInPopViewController") as! ValidationNumberFillingInPopViewController
        
        vc.preferredContentSize = CGSize(width: 286, height: 247)
        
        navigatable.present(vc: vc)
    }
    
    func blink(_ innerView: UIView, _ label1: UILabel, _ label2: UILabel? = nil, _ label3: UILabel? = nil) {
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
}
