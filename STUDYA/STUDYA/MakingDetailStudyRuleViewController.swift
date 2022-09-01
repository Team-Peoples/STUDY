//
//  MakingDetailStudyRuleViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/09/01.
//

import UIKit

class MakingDetailStudyRuleViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var underBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var leftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        
        collectionView.register(AttendanceRuleCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceRuleCollectionViewCell.identifier)
        collectionView.register(ExcommunicationRuleCollectionViewCell.self, forCellWithReuseIdentifier: ExcommunicationRuleCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        underBar.layer.cornerRadius = 3
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
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
}

extension MakingDetailStudyRuleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceRuleCollectionViewCell.identifier, for: indexPath) as! AttendanceRuleCollectionViewCell
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExcommunicationRuleCollectionViewCell.identifier, for: indexPath) as! ExcommunicationRuleCollectionViewCell
            return cell
            
        default: break
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension MakingDetailStudyRuleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size)
        return collectionView.frame.size
    }
}
