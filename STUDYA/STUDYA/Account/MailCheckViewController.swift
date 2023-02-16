//
//  MailCheckViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/20.
//

import UIKit
import SnapKit

final class MailCheckViewController: UIViewController {
 
    private var nickName = KeyChain.read(key: Const.tempNickname)
    private var email = KeyChain.read(key: Const.tempUserId)
    
    private lazy var helloLabel = CustomLabel(title: "반가워요\n\(nickName ?? "회원")님!😀", tintColor: .ppsBlack, size: 30, isBold: true)
    private lazy var announceLabel1 = CustomLabel(title: "\(email ?? "메일")로\n인증 안내를 보내드렸어요.", tintColor: .ppsBlack, size: 18)
    private let mailImageView = UIImageView(image: UIImage(named: "mailCheck"))
    private let announceLabel2 = CustomLabel(title: "인증 버튼을 누르면\n가입이 완료돼요.", tintColor: .ppsBlack, size: 18)
    private let retryButton = BrandButton(title: "이메일이 안 왔어요!", isBold: true, isFill: true, fontSize: 20, height: 50)
    private let announceLabel3 = CustomLabel(title: "메일이 오지 않을 경우, 스팸메일함을 확인해주세요.", tintColor: .ppsGray1, size: 12)
    private lazy var alertView = UIView(frame: .zero)
    private lazy var alertLabel = CustomLabel(title: "인증 메일을 다시 보내드렸어요.", tintColor: .whiteLabel, size: 12, isBold: true)
    private lazy var alertImage = UIImageView(image: UIImage(named: "emailCheck"))
    private var bottomConst: Constraint?
    
    
    
    private let checkEmailCertificationButton = BrandButton(title: "인증 완료", isBold: true, isFill: true, fontSize: 20, height: 50)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        retryButton.addTarget(self, action: #selector(resendEmailButtonTapped), for: .touchUpInside)
        checkEmailCertificationButton.addTarget(self, action: #selector(checkEmailCertificationButtonTapped), for: .touchUpInside)
        
        addSubviews()
        setConstraints()
        setAlertView()
    }
    
    @objc private func checkEmailCertificationButtonTapped() {
//        여기서 temp 값들 다 삭제
        Network.shared.checkIfEmailCertificated { result in
            switch result {
            case .success(let isCertificated):
                
                if isCertificated {
                    
                    if let _ = KeyChain.read(key: Const.tempNickname),
                       let _ = KeyChain.read(key: Const.userId),
                       let _ = KeyChain.read(key: Const.tempPassword),
                       let _ = KeyChain.read(key: Const.tempPasswordCheck) {
                        KeyChain.delete(key: Const.tempNickname)
                        KeyChain.delete(key: Const.tempUserId)
                        KeyChain.delete(key: Const.tempPassword)
                        KeyChain.delete(key: Const.tempPasswordCheck)
                    }
                    
                    UserDefaults.standard.set(true, forKey: Const.isLoggedin)
                    KeyChain.create(key: Const.isEmailCertificated, value: "1")
                    NotificationCenter.default.post(name: .authStateDidChange, object: nil)
                } else {
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(message: "이메일 인증을 완료해 주세요.")
                        self.present(alert, animated: true)
                    }
                }
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }   
        }
    }
    
    @objc private func resendEmailButtonTapped() {
        Network.shared.resendAuthEmail { result in
            switch result {
            case .success(let isResended):
                if isResended {
                    DispatchQueue.main.async {
                        self.animate()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    var alert = SimpleAlert(message: "")
                    
                    switch error {
                        
                    case .serverError:
                        alert = SimpleAlert(message: "인증 메일 발송 실패. 관리자에게 문의하세요.")
                        self.present(alert, animated: true)
                    case .decodingError:
                        alert = SimpleAlert(message: Const.unknownErrorMessage + " code = 1")
                    case .unauthorizedUser:
                        alert = SimpleAlert(buttonTitle: Const.OK, message: "인증되지 않은 사용자입니다. 로그인 후 사용해주세요.", completion: { finished in
                            AppController.shared.deleteUserInformationAndLogout()
                        })
                    case .tokenExpired:
                        alert = SimpleAlert(buttonTitle: Const.OK, message: "로그인이 만료되었습니다. 다시 로그인해주세요.", completion: { finished in
                            AppController.shared.deleteUserInformationAndLogout()
                        })
                    case .unknownError(let errorCode):
                        guard let errorCode = errorCode else { return }
                        alert = SimpleAlert(message: Const.unknownErrorMessage + " code = \(errorCode)")
                    default:
                        alert = SimpleAlert(message: Const.unknownErrorMessage)
                    
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(helloLabel)
        view.addSubview(announceLabel1)
        view.addSubview(mailImageView)
        view.addSubview(announceLabel2)
        view.addSubview(checkEmailCertificationButton)
        view.addSubview(retryButton)
        view.addSubview(announceLabel3)
    }
    
    private func setConstraints() {
        helloLabel.anchor(top: view.topAnchor, topConstant: 126, leading: view.leadingAnchor, leadingConstant: 20)
        announceLabel1.anchor(top: helloLabel.bottomAnchor, topConstant: 27, leading: view.leadingAnchor, leadingConstant: 23)
        mailImageView.centerXY(inView: view, yConstant: 10)
        announceLabel2.anchor(top: mailImageView.bottomAnchor, topConstant: 27)
        announceLabel2.centerX(inView: view)
        checkEmailCertificationButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(100)
            make.bottom.equalTo(view.snp.bottom).inset(300)
        }
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
