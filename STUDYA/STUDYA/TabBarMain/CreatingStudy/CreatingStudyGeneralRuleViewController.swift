//
//  CreatingStudyGeneralRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/01.
//

import UIKit

final class CreatingStudyGeneralRuleViewController: UIViewController {
    
    var doneButtonDidTapped: (GeneralStudyRule) -> () = { generalRule in }
    var generalRuleViewModel = GeneralRuleViewModel()
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var underBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: BrandButton!
    
    @IBOutlet weak var leftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(CreatingAttendanceRuleCollectionViewCell.self, forCellWithReuseIdentifier: CreatingAttendanceRuleCollectionViewCell.identifier)
        collectionView.register(CreatingExcommunicationRuleCollectionViewCell.self, forCellWithReuseIdentifier: CreatingExcommunicationRuleCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
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
        // domb: 두 개의 컬렉션뷰셀을 전환할 때 하나의 셀은 nil이 되어 doneButtonDidTapped Action에서 다른 하나의 셀에 담긴 generalRule을 밖에 가져가지 못한다.
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CreatingAttendanceRuleCollectionViewCell {
            generalRuleViewModel.generalRule.lateness = cell.lateness ?? Lateness()
            generalRuleViewModel.generalRule.absence = cell.absence ?? Absence()
            generalRuleViewModel.generalRule.deposit = cell.deposit
        }
        
        if let excommunicationCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CreatingExcommunicationRuleCollectionViewCell {
            generalRuleViewModel.generalRule.excommunication = Excommunication(lateness: excommunicationCell.lateNumberField.text?.toInt(), absence: excommunicationCell.absenceNumberField.text?.toInt())
        }
        doneButtonDidTapped(generalRuleViewModel.generalRule)
        dismiss(animated: true)
    }
}

extension CreatingStudyGeneralRuleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatingAttendanceRuleCollectionViewCell.identifier, for: indexPath) as! CreatingAttendanceRuleCollectionViewCell
            
            generalRuleViewModel.configure(cell)
            
            return cell
            
        case 1:
            
            guard let excommunicationCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatingExcommunicationRuleCollectionViewCell.identifier, for: IndexPath(item: 1, section: 0)) as? CreatingExcommunicationRuleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            generalRuleViewModel.configure(cell: excommunicationCell)
            
            return excommunicationCell
            
        default: break
        }
        
        return UICollectionViewCell()
    }
}

extension CreatingStudyGeneralRuleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
