//
//  StudyInfoViewController.swift
//  STUDYA
//
//  Created by 서동운 on 11/9/22.
//

import UIKit
import SnapKit

class StudyInfoViewController: UIViewController {
    
    @IBOutlet weak var studyCategoryBackgroundView: UIView!
    @IBOutlet weak var studyCategoryLabel: UILabel!
    @IBOutlet weak var studyInfoBackgroundView: UIView!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var studyTypeLabel: UILabel!
    @IBOutlet weak var studyIntroductionLabel: UILabel!
    @IBOutlet weak var studyInfoEditButton: UIButton!
    
    /// 스터디 선택정보
    @IBOutlet weak var studyGeneralRuleBackgroundView: UIView!
    @IBOutlet weak var attendanceRuleLabel: UILabel!
    @IBOutlet weak var excommunicationRuleLabel: UILabel!
    @IBOutlet weak var studyGeneralRuleEditButton: UIButton!
    
    @IBOutlet weak var freeRuleTitleLabel: UILabel!
    @IBOutlet weak var freeRuleTextView: UITextView!
    @IBOutlet weak var studyFreeRuleEditButton: UIButton!
    
    @IBOutlet weak var attendanceRuleContentsHeight: NSLayoutConstraint!
    @IBOutlet weak var excommunocationRuleContentsHeight: NSLayoutConstraint!
    lazy var toastMessage = ToastMessage(message: "초대 링크가 복사되었습니다.", messageColor: .whiteLabel, messageSize: 12, image: "copy-check")
    private let masterSwitch = BrandSwitch()
    
    private var keyboardFrameHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
      configureMasterSwitch()
        
        studyInfoBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: 24)
        studyCategoryBackgroundView.configureBorder(color: .keyColor3, width: 1, radius: self.studyCategoryBackgroundView.frame.height / 2)

        view.addSubview(toastMessage)
        
        toastMessage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view.frame.width - 14)
            make.height.equalTo(42)
            make.bottom.equalTo(view.snp.bottom).offset(-keyboardFrameHeight + 40)
        }
    }
    @IBAction func linkTouched(_ sender: UIButton) {
        
        UIPasteboard.general.string = sender.titleLabel?.text
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
//            if keyboardFrameHeight == 0 {
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(view.snp.bottom).offset(-100)
                }
//            } else {
//                toastMessage.snp.updateConstraints { make in
//                    make.bottom.equalTo(self.bottomConst!).offset(-keyboardFrameHeight-10)
//                }
//            }
            sender.isUserInteractionEnabled = false
            view.layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.toastMessage.alpha = 0
            } completion: {[self] _ in
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(view.snp.bottom).offset(40)
                }
                toastMessage.alpha = 0.9
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func toggleMaster(_ sender: BrandSwitch) {
        
        studyInfoEditButton.isHidden = !sender.isOn
        studyGeneralRuleEditButton.isHidden = !sender.isOn
        studyFreeRuleEditButton.isHidden = !sender.isOn
    }
    
    @objc func doneButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func studyInfoEditButtonDidTapped(_ sender: Any) {
      
        let vc = UINavigationController(rootViewController: StudyBasicInfoEditViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func studyGeneralRuleEditButtonDidTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudyGeneralRuleViewController") as! StudyGeneralRuleViewController
    
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func studyFreeRuleEditButtonEditButtonDidTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudyFreeRuleViewController") as! StudyFreeRuleViewController
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func configureMasterSwitch() {
        
        masterSwitch.addTarget(self, action: #selector(toggleMaster(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
    }
}
