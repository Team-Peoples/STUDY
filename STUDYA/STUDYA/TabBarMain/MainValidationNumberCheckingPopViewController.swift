//
//  MainValidationNumberCheckingPopViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/18.
//

import UIKit

final class MainValidationNumberCheckingPopViewController: UIViewController {
    
    static let identifier = "MainValidationNumberCheckingPopViewController"
    
    internal var didAttend: Bool? {
        didSet {
//            thirdCEll에서 넘어올 때 네트워킹에서 받기도 하고 여기서 출석버튼 눌러서 받기도함.
            if let didAttend = didAttend, didAttend {
                attendButton.setTitle("출석 완료", for: .normal)
                attendButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
                attendButton.configureBorder(color: .ppsGray2, width: 1, radius: 20)
                attendButton.backgroundColor = .systemBackground
                attendButton.isEnabled = false
            }
        }
    }
    internal var checkCode: Int? {
        didSet {
            guard let checkCode = checkCode else { return }
            validationNumberLabel.text = String(checkCode)
        }
    }
    internal var scheduleID: Int? {
        didSet {
            getCertificationCode()
        }
    }
    
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
                self.didAttend = true
                NotificationCenter.default.post(name: .attendanceInformationChanged, object: nil)
            case .failure(let error):
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
        }
    }
    
    private func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
