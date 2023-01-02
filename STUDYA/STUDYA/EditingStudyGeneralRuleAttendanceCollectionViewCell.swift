//
//  EditingStudyGeneralRuleAttendanceCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

class EditingStudyGeneralRuleAttendanceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
  
    static let identifier = "EditingStudyGeneralRuleAttendanceCollectionViewCell"
    
    weak var delegate: EditingStudyGeneralRuleViewController?
    
    private var generalRuleAttendanceTableView = GeneralRuleAttendanceTableView()
    
    lazy var fineDimmingViewIsHidden: (LatenessRuleTimeIsNotNil, AbsenceRuleTimeIsNotNil) = (false, false) {
        didSet {
            
            switch fineDimmingViewIsHidden {
            case (false, false):
               
                let cell = generalRuleAttendanceTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditingStudyGeneralRuleAttendanceFineTableViewCell
                cell?.fineDimmingView.isHidden = false
                resetData(in: cell)
            default:
               
                let cell = generalRuleAttendanceTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditingStudyGeneralRuleAttendanceFineTableViewCell
                cell?.fineDimmingView.isHidden = true
            }
        }
    }
    
    lazy var toastMessage = ToastMessage(message: "먼저 지각 규칙을 입력해주세요.", messageColor: .whiteLabel, messageSize: 12, image: "alert")
    
    private var keyboardHeight: CGFloat = 0
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNotification()
        enableTapGesture()
        
        generalRuleAttendanceTableView.dataSource = self
        generalRuleAttendanceTableView.delegate = self
        configureViews()
        setConstaints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func keyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        keyboardHeight = keyboardSize.height
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

        generalRuleAttendanceTableView.contentInset = inset
    }
    
    @objc func keyboardDisappear(_ notification: NSNotification) {
        keyboardHeight = 0
        generalRuleAttendanceTableView.endEditing(true)
        generalRuleAttendanceTableView.contentInset = .zero
    }
    
    @objc func dimmingViewDidTapped() {
        
        generalRuleAttendanceTableView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            toastMessage.snp.updateConstraints { make in
                make.bottom.equalTo(contentView).offset(-keyboardHeight-60)
            }
            contentView.layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) {
                self.toastMessage.alpha = 0
            } completion: {[self] _ in
                toastMessage.snp.updateConstraints { make in
                    make.bottom.equalTo(contentView).offset(100)
                }
                toastMessage.alpha = 0.9
                generalRuleAttendanceTableView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func enableTapGesture() {
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDisappear))
        
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        contentView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configure
    
    private func configureViews() {
        contentView.addSubview(generalRuleAttendanceTableView)
        contentView.addSubview(toastMessage)
    }
    // MARK: - Setting Constraints
    
    private func setConstaints() {
        
        generalRuleAttendanceTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView.frame.width - 14)
            make.height.equalTo(42)
            make.bottom.equalTo(contentView).offset(100)
        }
    }
}

extension EditingStudyGeneralRuleAttendanceCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    fileprivate func resetData(in cell: EditingStudyGeneralRuleAttendanceFineTableViewCell?) {
        cell?.perLateMinuteField.text = "--"
        cell?.latenessFineField.text = "0"
        cell?.absenceFineField.text = "0"
        
        delegate?.study?.generalRule?.lateness.count = nil
        delegate?.study?.generalRule?.lateness.fine = nil
        delegate?.study?.generalRule?.absence.fine = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditingStudyGeneralRuleAttendanceTimeTableViewCell.identifier, for: indexPath) as? EditingStudyGeneralRuleAttendanceTimeTableViewCell else { return UITableViewCell() }
        
            cell.latenessRuleTimeField.text = delegate?.study?.generalRule?.lateness.time?.toString() ?? "--"
            cell.absenceRuleTimeField.text = delegate?.study?.generalRule?.absence.time?.toString()
            ?? "--"
            cell.latenessRuleTimeFieldAction = { [self] latenessRuleTime in
                delegate?.study?.generalRule?.lateness.time = latenessRuleTime
                fineDimmingViewIsHidden.0 = latenessRuleTime != nil
            }
            cell.absenceRuleTimeFieldAction = { [self] absenceRuleTime in
                delegate?.study?.generalRule?.absence.time = absenceRuleTime
                fineDimmingViewIsHidden.1 = absenceRuleTime != nil
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditingStudyGeneralRuleAttendanceFineTableViewCell.identifier, for: indexPath) as? EditingStudyGeneralRuleAttendanceFineTableViewCell else { return UITableViewCell() }
            
            cell.perLateMinuteField.text = delegate?.study?.generalRule?.lateness.count?.toString()
            ?? "--"
            cell.latenessFineField.text = Formatter.formatIntoDecimal(number: delegate?.study?.generalRule?.lateness.fine ?? 0)
            cell.absenceFineField.text = Formatter.formatIntoDecimal(number: delegate?.study?.generalRule?.absence.fine ?? 0)
            
            cell.perLateMinuteFieldAction = { [self] perLateMinute in
                delegate?.study?.generalRule?.lateness.count = perLateMinute
            }
            cell.latenessFineFieldAction = { [self] latenessFine in
                delegate?.study?.generalRule?.lateness.fine = latenessFine
            }
            cell.absenceFineFieldAction = { [self] absenceFine in
                delegate?.study?.generalRule?.absence.fine = absenceFine
            }
            
            if delegate?.study?.generalRule?.lateness.time == nil && delegate?.study?.generalRule?.absence.time == nil {
                cell.fineDimmingView.isHidden = false
            } else {
                cell.fineDimmingView.isHidden = true
            }
            
            cell.fineDimmingViewAddTapGesture(target: self, action: #selector(dimmingViewDidTapped))
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditingStudyGeneralRuleDepositTableViewCell.identifier, for: indexPath) as? EditingStudyGeneralRuleDepositTableViewCell else { return UITableViewCell() }
            
            cell.depositTextField.text = Formatter.formatIntoDecimal(number: delegate?.study?.generalRule?.deposit ?? 0)
            
            cell.depositTextFieldAction = { [self] deposit in
                delegate?.study?.generalRule?.deposit = deposit
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            return UIView()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 10
        } else {
            return 0
        }
    }
}

typealias LatenessRuleTimeIsNotNil = Bool
typealias AbsenceRuleTimeIsNotNil = Bool
