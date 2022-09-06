//
//  AttendanceRuleTableViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/09/05.
//

import UIKit
import SnapKit

// 따로 테이블 뷰로 만들어서 사용하려했지만 그렇게 할경우 MakingDetailStudyRuleViewController가 collectionView와 tableView를 모두 관리해야하므로 vc를 분리하는게 더 나아 보여서 이렇게 만들었음.

class AttendanceRuleTableViewController: UITableViewController {
    // MARK: - Properties
    
    @IBOutlet weak var lateMinuteTextField: RoundedNumberField!
    @IBOutlet weak var absentMinuteTextField: RoundedNumberField!
    @IBOutlet weak var perLateMinuteTextField: RoundedNumberField!
    @IBOutlet weak var latePenaltyTextField: UITextField!
    @IBOutlet weak var absentPenaltyTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!

    @IBOutlet weak var penaltyDimmingView: UIView!
    
    @IBOutlet weak var depositDimmingView: UIView!
    
    private var keyboardFrameHeight: CGFloat = 0
    
    lazy var toastMessage: UIView = {
        let v = UIView(frame: CGRect(x: (self.view.frame.width - 340) / 2, y: self.view.frame.height - keyboardFrameHeight - 42 - 7, width: 340, height: 42))
        let imageView = UIImageView(image: UIImage(named: "emailCheck"))
        let label = UILabel()
        
        v.backgroundColor = .appColor(.ppsBlack)
        v.layer.cornerRadius = 5
        
        label.text = "먼저 지각 규칙을 입력해주세요."
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        
        v.addSubview(imageView)
        v.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(v).inset(7)
            make.centerY.equalTo(v)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalTo(v)
        }
    
        return v
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizers()
        lateMinuteTextField.delegate = self
        absentMinuteTextField.delegate = self
        
        setLatePenaltyTextField()
        setAbsentPenaltyTextField()
        setDepositTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UITableViewDataSource
    
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
    
    // MARK: - Actions
    
    private func addTapGestureRecognizers() {
        penaltyDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTapped)))
        depositDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTapped)))
    }
    
    private func setLatePenaltyTextField() {
        latePenaltyTextField.delegate = self
        latePenaltyTextField.backgroundColor = .appColor(.background)
        latePenaltyTextField.font = .boldSystemFont(ofSize: 20)
        latePenaltyTextField.textColor = .appColor(.ppsGray1)
        latePenaltyTextField.placeholder = "0"
        latePenaltyTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        latePenaltyTextField.rightViewMode = .always
        latePenaltyTextField.textAlignment = .right
        latePenaltyTextField.clipsToBounds = true
        latePenaltyTextField.layer.cornerRadius = 42 / 2
    }
    
    private func setAbsentPenaltyTextField() {
        absentPenaltyTextField.delegate = self
        absentPenaltyTextField.backgroundColor = .appColor(.background)
        absentPenaltyTextField.font = .boldSystemFont(ofSize: 20)
        absentPenaltyTextField.textColor = .appColor(.ppsGray1)
        absentPenaltyTextField.placeholder = "0"
        absentPenaltyTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        absentPenaltyTextField.rightViewMode = .always
        absentPenaltyTextField.textAlignment = .right
        absentPenaltyTextField.clipsToBounds = true
        absentPenaltyTextField.layer.cornerRadius = 42 / 2
    }
    
    private func setDepositTextField() {
        depositTextField.delegate = self
        depositTextField.backgroundColor = .appColor(.background)
        depositTextField.font = .boldSystemFont(ofSize: 20)
        depositTextField.textColor = .appColor(.ppsGray1)
        depositTextField.placeholder = "0"
        depositTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        depositTextField.rightViewMode = .always
        depositTextField.textAlignment = .right
        depositTextField.clipsToBounds = true
        depositTextField.layer.cornerRadius = 42 / 2
    }
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        print(#function)
    }
    
    @objc func dimmingViewDidTapped() {
        penaltyDimmingView.isUserInteractionEnabled = false
        depositDimmingView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseInOut, animations: { [self] in
           
            view.addSubview(self.toastMessage)
            toastMessage.alpha = 0
        }, completion: { [self] _ in
            toastMessage.removeFromSuperview()
            
            toastMessage.alpha = 1
            penaltyDimmingView.isUserInteractionEnabled = true
            depositDimmingView.isUserInteractionEnabled = true
        })
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

extension AttendanceRuleTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let lateMinuteText = lateMinuteTextField.text, let absentMinuteText = absentMinuteTextField.text else { return }
        if lateMinuteText != "--" && absentMinuteText != "--" {
            depositDimmingView.isHidden = true
            penaltyDimmingView.isHidden = true
        } else {
            depositDimmingView.isHidden = false
            penaltyDimmingView.isHidden = false
            
            perLateMinuteTextField.text = "--"
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
