//
//  StudyGeneralRuleAttendanceTableViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/05.
//

import UIKit
import SnapKit

// 따로 테이블 뷰로 만들어서 사용하려했지만 그렇게 할경우 MakingDetailStudyRuleViewController가 collectionView와 tableView를 모두 관리해야하므로 vc를 분리하는게 더 나아 보여서 이렇게 만들었음.

struct AttendacneRuleViewModel {
    
}

class StudyGeneralRuleAttendanceTableViewController: UITableViewController {
    // MARK: - Properties
    @IBOutlet weak var lateRuleTimeField: RoundedNumberField!
    @IBOutlet weak var absenceRuleTimeField: RoundedNumberField!
    @IBOutlet weak var perLateMinuteField: RoundedNumberField!
    @IBOutlet weak var latePenaltyTextField: UITextField!
    @IBOutlet weak var absentPenaltyTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var penaltyDimmingView: UIView!
    @IBOutlet weak var depositDimmingView: UIView!
    lazy var toastMessage = ToastMessage(message: "먼저 지각 규칙을 입력해주세요.", messageColor: .whiteLabel, messageSize: 12, image: "alert")
    
    private var keyboardFrameHeight: CGFloat = 0
    var bottomConst: ConstraintItem?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizers()
        
        setDelegate()
        setNotification()
        
        configureViews()
        configure(latePenaltyTextField)
        configure(absentPenaltyTextField)
        configure(depositTextField)
        
        disableMoneyRelatedFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(toastMessage)
        
        toastMessage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view.frame.width - 14)
            make.height.equalTo(42)
            make.bottom.equalTo(bottomConst!).offset(-keyboardFrameHeight + 100)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure
    
    func configureViews() {
    }
    
    // MARK: - Actions
    
    private func setDelegate() {
        lateRuleTimeField.delegate = self
        absenceRuleTimeField.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addTapGestureRecognizers() {
        penaltyDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTapped)))
        depositDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTapped)))
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.backgroundColor = .appColor(.background)
        textField.font = .boldSystemFont(ofSize: 20)
        textField.textColor = .appColor(.ppsGray1)
        textField.placeholder = "0"
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        textField.textAlignment = .right
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 42 / 2
        textField.keyboardType = .numberPad
    }
    
    internal func enableMoneyRelatedFields() {
        depositDimmingView.isHidden = true
        penaltyDimmingView.isHidden = true
        perLateMinuteField.isEnabled = true
        latePenaltyTextField.isEnabled = true
        absentPenaltyTextField.isEnabled = true
        depositTextField.isEnabled = true
    }
    
    internal func disableMoneyRelatedFields() {
        depositDimmingView.isHidden = false
        penaltyDimmingView.isHidden = false
        perLateMinuteField.isEnabled = false
        latePenaltyTextField.isEnabled = false
        absentPenaltyTextField.isEnabled = false
        depositTextField.isEnabled = false
    }
    
    @objc func dimmingViewDidTapped() {
        penaltyDimmingView.isUserInteractionEnabled = false
        depositDimmingView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            if keyboardFrameHeight == 0 {
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(self.bottomConst!).offset(-100) }
            } else {
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(self.bottomConst!).offset(-keyboardFrameHeight-10)
                }
            }
            
            view.layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.toastMessage.alpha = 0
            } completion: {[self] _ in
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(self.bottomConst!).offset(100)
                }
                toastMessage.alpha = 0.9
                penaltyDimmingView.isUserInteractionEnabled = true
                depositDimmingView.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        keyboardFrameHeight = keyboardSize.height
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        keyboardFrameHeight = 0
    }
}

// MARK: - UITableViewDataSource

extension StudyGeneralRuleAttendanceTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 10
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10))
            footerView.backgroundColor = .appColor(.background)
            return footerView
        } else {
            return nil
        }
    }
}
// MARK: - UITextFieldDelegate

extension StudyGeneralRuleAttendanceTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if lateRuleTimeField?.text != "--" || absenceRuleTimeField.text != "--" {
            
            enableMoneyRelatedFields()
            
        } else {
            
            disableMoneyRelatedFields()
            
            perLateMinuteField.text = "--"
            depositTextField.text = "0"
            latePenaltyTextField.text = "0"
            absentPenaltyTextField.text = "0"
        }
        
        if textField == latePenaltyTextField || textField == absentPenaltyTextField || textField == depositTextField {
            if let text = textField.text, let intText = Int(text) {
                textField.text = Formatter.formatIntoDecimal(number: intText)
            }
        }
    }
}
