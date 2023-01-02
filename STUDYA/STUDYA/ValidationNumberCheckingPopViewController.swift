//
//  ValidationNumberCheckingPopViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/18.
//

import UIKit

final class ValidationNumberCheckingPopViewController: UIViewController {
    
    internal var didAttend = false {
        didSet {
            attendButton.setTitle("출석 완료", for: .normal)
            attendButton.setTitleColor(.appColor(.ppsGray2), for: .normal)
            attendButton.configureBorder(color: .ppsGray2, width: 1, radius: 20)
            attendButton.backgroundColor = .systemBackground
            attendButton.isEnabled = false
        }
    }
    internal var checkCode: Int? {
        didSet {
            guard let checkCode = checkCode else { return }
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
        didAttend = true
    }
    
    private func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
