//
//  ValidationNumberCheckingPopViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/18.
//

import UIKit

final class ValidationNumberCheckingPopViewController: UIViewController {
    
    static let identifier = "ValidationNumberCheckingPopViewController"
    
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
    internal var certificationCode: Int? {
        didSet {
            guard let checkCode = certificationCode else { return }
            validationNumberLabel.text = String(checkCode)
        }
    }
    
    private var customTransitioningDelegate = TransitioningDelegate()
    
    @IBOutlet weak var validationNumberLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validationNumberLabel.text = "7395"
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func attendButtonTapped(_ sender: Any) {
//        🛑in에 scheduleID 받아와야
        guard let certificationCode = certificationCode else { return }
        Network.shared.attend(in: 1, with: certificationCode) { result in
            switch result {
            case .success:
                self.didAttend = true
            case .failure(let error):
                switch error {
                case .unknownMember:
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(buttonTitle: "확인", message: "더이상 이 스터디의 멤버가 아닙니다.") { finished in
//                            🛑completion에 메인화면 리로드 넣기
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.present(alert, animated: true)
                    }
                case .wrongAttendanceCode:
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(message: "오류가 발생했습니다. 다시 시도해주세요.")
                        self.present(alert, animated: true)
                    }
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
        
        didAttend = true
    }
    
    private func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
