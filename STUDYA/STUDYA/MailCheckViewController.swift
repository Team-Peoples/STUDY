//
//  MailCheckViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/20.
//

import UIKit
import SnapKit

class MailCheckViewController: UIViewController {
 
    var nickName: String?
    var email: String?
    
    private lazy var helloLabel = CustomLabel(title: "반가워요\n\(nickName ?? "회원")님!😀", tintColor: .ppsBlack, size: 30, isBold: true, isNecessaryTitle: false)
    private lazy var announceLabel1 = CustomLabel(title: "\(email ?? "메일")로\n인증 안내를 보내드렸어요.", tintColor: .ppsBlack, size: 18)
    private let mailImageView = UIImageView(image: UIImage(named: "mailCheck"))
    private let announceLabel2 = CustomLabel(title: "인증 버튼을 누르면\n가입이 완료돼요.", tintColor: .ppsBlack, size: 18)
    private let retryButton = CustomButton(title: "이메일이 안 왔어요!", isBold: true, isFill: true, size: 20, height: 50)
    private let announceLabel3 = CustomLabel(title: "메일이 오지 않을 경우, 스팸메일함을 확인해주세요.", tintColor: .ppsGray1, size: 12)
    private lazy var alertView = UIView(frame: .zero)
    private lazy var alertLabel = CustomLabel(title: "인증 메일을 다시 보내드렸어요.", tintColor: .whiteLabel, size: 12, isBold: true, isNecessaryTitle: false)
    private lazy var alertImage = UIImageView(image: UIImage(named: "emailCheck"))
    private var bottomConst: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        retryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubviews()
        setConstraints()
        setAlertView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        비밀번호 없이 사용자의 이메일이 인증되었는지 확인할 수 있는 api
    }
    
    @objc private func buttonTapped() {
        Network.shared.resendEmail { error in
            switch error {
            case nil:
                self.animate()
            default:
                DispatchQueue.main.async {
                    let alert = SimpleAlert(message: "알 수 없는 에러. 나중에 다시 시도해주세요.")
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(helloLabel)
        view.addSubview(announceLabel1)
        view.addSubview(mailImageView)
        view.addSubview(announceLabel2)
        view.addSubview(retryButton)
        view.addSubview(announceLabel3)
    }
    
    private func setConstraints() {
        helloLabel.anchor(top: view.topAnchor, topConstant: 126, leading: view.leadingAnchor, leadingConstant: 20)
        announceLabel1.anchor(top: helloLabel.bottomAnchor, topConstant: 27, leading: view.leadingAnchor, leadingConstant: 23)
        mailImageView.centerXY(inView: view, yConstant: 10)
        announceLabel2.anchor(top: mailImageView.bottomAnchor, topConstant: 27)
        announceLabel2.centerX(inView: view)
        retryButton.anchor(bottom: announceLabel3.topAnchor, bottomConstant: 6, leading: view.leadingAnchor, leadingConstant: 54, trailing: view.trailingAnchor, trailingConstant: 54)
        announceLabel3.anchor(bottom: view.bottomAnchor, bottomConstant: 90)
        announceLabel3.centerX(inView: view)
    }
    
    
    private func setAlertView() {
        alertView.backgroundColor = UIColor(red: 53/255, green: 45/255, blue: 72/255, alpha: 0.9)
        alertView.layer.cornerRadius = 5
        
        view.addSubview(alertView)
        alertView.addSubview(alertLabel)
        alertView.addSubview(alertImage)
        
        alertView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            self.bottomConst = make.top.equalTo(view.snp.bottom).constraint
            make.height.equalTo(42)
        }

        alertImage.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).offset(8)
            make.bottom.equalTo(alertView.snp.bottom).offset(-8)
            make.leading.equalTo(alertView).offset(10)
        }
        
        alertLabel.snp.makeConstraints { make in
            make.leading.equalTo(alertImage.snp.trailing).offset(10)
        }
        alertLabel.centerY(inView: alertView)
    }
    
    private func animate() {
        self.retryButton.isUserInteractionEnabled = false
        self.bottomConst?.update(offset: -100)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.alertView.alpha = 0
            } completion: { _ in
                self.bottomConst?.update(offset: 0)
                self.alertView.alpha = 0.9
                self.retryButton.isUserInteractionEnabled = true
            }
        }

    }
}
