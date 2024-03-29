//
//  MainValidationNumberFillingInPopViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/16.
//

import UIKit

final class MainValidationNumberFillingInPopViewController: UIViewController {
    
    static let identifier = "MainValidationNumberFillingInPopViewController"
    
    internal var scheduleID: ID?
    
    private var customTransitioningDelegate = TransitioningDelegate()
    
    @IBOutlet weak var firstField: RoundedCornersField!
    @IBOutlet weak var secondField: RoundedCornersField!
    @IBOutlet weak var thirdField: RoundedCornersField!
    @IBOutlet weak var fourthField: RoundedCornersField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var validationLabel: UILabel!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstField.delegate = self
        secondField.delegate = self
        thirdField.delegate = self
        fourthField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func attendWithCheckNumbers() {
        guard let scheduleID = scheduleID else { return }
        let validationNumber = returnEnteredCheckNumbers()
        
        Network.shared.attend(in: scheduleID, with: validationNumber) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil)
                self.dismiss(animated: true)
            case .failure(let error):
                self.handle(error: error)
            }
        }
    }
    
    private func returnEnteredCheckNumbers() -> Int {
        guard let t1 = firstField.text, let t2 = secondField.text,
              let t3 = thirdField.text, let t4 = fourthField.text,
              let validationNumber = Int(t1 + t2 + t3 + t4) else { return 0 }
        
        return validationNumber
    }
    
    private func handle(error: PeoplesError) {
        switch error {
        case .userNotFound:
            let alert = SimpleAlert(message: "스터디 멤버만 출석체크 할 수 있습니다.")
            self.present(alert, animated: true)
            
        case .wrongAttendanceCode:
            HapticManager.shared.hapticNotification(type: .error)
            
            validationLabel.isHidden = false
            
            firstField.text = ""
            secondField.text = ""
            thirdField.text = ""
            fourthField.text = ""
        default:
            UIAlertController.handleCommonErros(presenter: self, error: error)
        }
    }
}

extension MainValidationNumberFillingInPopViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)

        if finalText.count == 0 {
            return true
        } else if finalText.count == 1 {
            guard finalText.checkOnlyNumbers() else { return false }
            
            switch textField {
            case firstField:
                textField.text = finalText
                secondField.becomeFirstResponder()
            case secondField:
                textField.text = finalText
                thirdField.becomeFirstResponder()
            case thirdField:
                textField.text = finalText
                fourthField.becomeFirstResponder()
            case fourthField:
                textField.text = finalText
                view.endEditing(true)
            default: break
            }
            return true
        } else {
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if firstField.text != "" && secondField.text != "" && thirdField.text != "" && fourthField.text != "" {
            attendWithCheckNumbers()
        }
    }
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: 286, height: 247)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        
        return CGRect(origin: origin, size: size)
    }
    
    private lazy var dimmingView: UIView = {
        let dimmingView = UIView(frame: .zero)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.addGestureRecognizer(recognizer)
        dimmingView.backgroundColor = .black
        
        return dimmingView
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        dimmingView.alpha = 0
        containerView?.addSubview(dimmingView)
        
        dimmingView.snp.makeConstraints { make in
            make.edges.equalTo(containerView!)
        }
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.6
        }, completion: { _ in
            self.dimmingView.alpha = 0.6
        })
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.isHidden = true
        })
    }
    
    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true)
    }
}
