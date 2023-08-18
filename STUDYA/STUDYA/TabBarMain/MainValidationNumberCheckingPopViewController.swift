//
//  MainValidationNumberCheckingPopViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/18.
//

import UIKit

final class MainValidationNumberCheckingPopViewController: UIViewController {
    
    static let identifier = "MainValidationNumberCheckingPopViewController"
    
    internal var didAttendForButtonStatus: Bool? {
        didSet {
            guard let didAttend = didAttendForButtonStatus, didAttend else { return }
            disableAttendButton()
        }
    }
    internal var checkCode: Int?
    internal var scheduleID: Int? { didSet { getCertificationCode() } }
    
    private var customTransitioningDelegate = TransitioningDelegate()
    
    internal var getDidAttend = {}
        
    @IBOutlet weak var validationNumberLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDidAttend()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func attendButtonTapped(_ sender: Any) {
        attend()
    }
    
    private func getCertificationCode() {
        guard let scheduleID = scheduleID else { return }
        Network.shared.getAttendanceCertificationCode(scheduleID: scheduleID) { result in
            switch result {
            case .success(let code):
                self.checkCode = code
                self.validationNumberLabel.text = String(code)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func attend() {
        guard let scheduleID = scheduleID, let checkCode = checkCode else { return }
        
        Network.shared.attend(in: scheduleID, with: checkCode) { result in
            switch result {
            case .success:
                self.didAttendForButtonStatus = true
                NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil)
            case .failure(let error):
                self.handleAttending(error)
            }
        }
    }
    
    private func disableAttendButton() {
        attendButton.setTitle("출석 완료", for: .normal)
        attendButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
        attendButton.configureBorder(color: .ppsGray2, width: 1, radius: 20)
        attendButton.backgroundColor = .white
        attendButton.isEnabled = false
    }
    
    private func handleAttending(_ error: PeoplesError) {
        switch error {
            
        case .userNotFound:
            let alert = SimpleAlert(message: "잘못된 접근입니다. 다시 시도해주세요.")
            self.present(alert, animated: true)
            
        case .wrongAttendanceCode:
            let alert = SimpleAlert(message: "서버 에러. 인증코드 불일치")
            self.present(alert, animated: true)
            
        default:
            UIAlertController.handleCommonErros(presenter: self, error: error)
        }
    }
    
    private func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
