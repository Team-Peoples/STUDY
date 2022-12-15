//
//  StudyGeneralRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/01.
//

import UIKit

struct GeneralStudyRuleViewModel {
    // model: generalRule
    
    var generalRule: GeneralStudyRule
    var lateness: Lateness {
        return generalRule.lateness ?? Lateness(time: nil, count: nil, fine: nil)
    }
    var absence: Absence {
        return generalRule.absence ?? Absence(time: nil, fine: nil)
    }
    var deposit: Int? {
        return generalRule.deposit
    }
    var excommunication: Excommunication {
        return generalRule.excommunication ?? Excommunication(lateness: nil, absence: nil)
    }
    
    init() {
        generalRule = GeneralStudyRule(lateness: nil, absence: nil, deposit: nil, excommunication: nil)
    }
    
    func configure(vc: StudyGeneralRuleAttendanceTableViewController) {
        vc.latenessRuleTimeField.text = lateness.time == nil ? "--" : String(lateness.time!)
        vc.absenceRuleTimeField.text = absence.time == nil ? "--" : String(absence.time!)
        vc.perLateMinuteField.text = lateness.count == nil ? "--" : String(lateness.count!)
        vc.latenessFineTextField.text = lateness.fine == nil ? nil : Formatter.formatIntoDecimal(number: lateness.fine!)
        vc.absenceFineTextField.text = absence.fine == nil ? nil : Formatter.formatIntoDecimal(number: absence.fine!)
        vc.depositTextField.text = deposit == nil ? nil : Formatter.formatIntoDecimal(number: deposit!)
        
        let isFieldsEnabled: Bool = lateness.time != nil || absence.time != nil ? true : false
        
        vc.fineAndDepositFieldsAreEnabled(isFieldsEnabled)
//        isfieldsenabled에 따라 혹시모를 moneyrelatedfields의 필드의 값을 다 삭제시켜주는 작업 해줘야하나?
    }
    
    func configure(cell: ExcommunicationRuleCollectionViewCell) {
        cell.lateNumberField.text = excommunication.lateness == nil ? "--" : String(excommunication.lateness!)
        cell.absenceNumberField.text = excommunication.absence == nil ? "--" : String(excommunication.absence!)
    }
}

final class StudyGeneralRuleViewController: UIViewController {
    
    var doneButtonDidTapped: (GeneralStudyRule) -> () = { generalRule in }
    var viewDidUpdated: (UICollectionView) -> () = { collectionView in }
    var generalRuleViewModel = GeneralStudyRuleViewModel()
    var task: Task?
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var underBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: BrandButton!
    
    @IBOutlet weak var leftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCenterXConstraint: NSLayoutConstraint!
    
    private let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudyGeneralRuleAttendanceTableViewController") as! StudyGeneralRuleAttendanceTableViewController
    private lazy var excommunicationCell = collectionView.dequeueReusableCell(withReuseIdentifier: ExcommunicationRuleCollectionViewCell.identifier, for: IndexPath(item: 1, section: 0)) as! ExcommunicationRuleCollectionViewCell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        if task == .editing {
            doneButton.isHidden = true
        } else if task == .creating {
            doneButton.isHidden = false
        }
        
        collectionView.register(AttendanceRuleCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceRuleCollectionViewCell.identifier)
        collectionView.register(ExcommunicationRuleCollectionViewCell.self, forCellWithReuseIdentifier: ExcommunicationRuleCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        //vc의 generalRule에 할당
        vc.generalRule = generalRuleViewModel.generalRule
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        underBar.layer.cornerRadius = 3
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        leftCenterXConstraint.priority = .required
        rightCenterXConstraint.priority = .defaultHigh

        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: [.centeredHorizontally], animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.leftLabel.textColor = UIColor.appColor(.ppsBlack)
            self.rightLabel.textColor = UIColor.appColor(.ppsGray2)
        }
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        leftCenterXConstraint.priority = .defaultHigh
        rightCenterXConstraint.priority = .required
        
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: [.centeredHorizontally], animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.leftLabel.textColor = UIColor.appColor(.ppsGray2)
            self.rightLabel.textColor = UIColor.appColor(.ppsBlack)
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        let generalRule = vc.generalRule
        let lateness = generalRule.lateness
        let absence = generalRule.absence
        let deposit = generalRule.deposit
        
        print(generalRule, "sefsefsefsef")
        
        generalRuleViewModel.generalRule.lateness = lateness
        generalRuleViewModel.generalRule.absence = absence
        generalRuleViewModel.generalRule.deposit = deposit
        generalRuleViewModel.generalRule.excommunication = Excommunication(lateness: Int(excommunicationCell.lateNumberField.text!), absence: Int(excommunicationCell.absenceNumberField.text!))
       
        doneButtonDidTapped(generalRuleViewModel.generalRule)
        dismiss(animated: true)
    }
}

extension StudyGeneralRuleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceRuleCollectionViewCell.identifier, for: indexPath) as! AttendanceRuleCollectionViewCell
            
            cell.addSubview(vc.view)
            vc.view.snp.makeConstraints { make in
                make.edges.equalTo(cell)
            }
            vc.bottomConstraintItem = cell.safeAreaLayoutGuide.snp.bottom
            generalRuleViewModel.configure(vc: vc)

            return cell
            
        case 1:
            generalRuleViewModel.configure(cell: excommunicationCell)
            
            return excommunicationCell
            
        default: break
        }
        
        return UICollectionViewCell()
    }
}

extension StudyGeneralRuleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
