//
//  CreatingStudyGeneralRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/01.
//

import UIKit

final class CreatingStudyGeneralRuleViewController: UIViewController {
    
    static let identifier = "CreatingStudyGeneralRuleViewController"
    
    var doneButtonDidTapped: (GeneralStudyRule) -> () = { generalRule in }
    let generalRuleViewModel = GeneralRuleViewModel()
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var underBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: BrandButton!
    
    @IBOutlet weak var leftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell.self, forCellWithReuseIdentifier: CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell.identifier)
        collectionView.register(CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell.self, forCellWithReuseIdentifier: CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell.identifier)
        
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

        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell {
            
            let generalRule = cell.generalRuleViewModel?.generalRule
            
            self.generalRuleViewModel.generalRule.absence = generalRule?.absence ?? Absence()
            self.generalRuleViewModel.generalRule.lateness = generalRule?.lateness ?? Lateness()
            self.generalRuleViewModel.generalRule.deposit = generalRule?.deposit ?? 0
        }
        
        if let excommunicationCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell {
            
            let generalRule = excommunicationCell.generalRuleViewModel?.generalRule
            
            generalRuleViewModel.generalRule.excommunication.lateness = generalRule?.excommunication.lateness
            generalRuleViewModel.generalRule.excommunication.absence = generalRule?.excommunication.absence
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
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell.identifier, for: indexPath) as! CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell
            
            cell.generalRuleViewModel = generalRuleViewModel
            
            return cell
        case 1:
            
            guard let excommunicationCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell.identifier, for: IndexPath(item: 1, section: 0)) as? CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            excommunicationCell.generalRuleViewModel = generalRuleViewModel
            
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
