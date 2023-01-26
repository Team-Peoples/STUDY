//
//  AttendanceManagerModeView.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/18.
//

import UIKit

final class AttendanceManagerModeView: UIView {
    
    internal var studyID: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: (Navigatable & SwitchSyncable & BottomSheetAddable)?
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var leftCell: AttendanceModificationCollectionViewCell = {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceModificationCollectionViewCell.identifier, for: IndexPath(item: 0, section: 0)) as? AttendanceModificationCollectionViewCell else { return AttendanceModificationCollectionViewCell() }
        
        cell.delegate = delegate
        if let studyID = studyID {
            cell.viewModel = AttendancesModificationViewModel(studyID: studyID)
        }
        
        return cell
    }()
    private lazy var rightCell: AttendanceOverallCheckCollectionViewCell = {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendanceOverallCheckCollectionViewCell.identifier, for: IndexPath(item: 1, section: 0)) as? AttendanceOverallCheckCollectionViewCell else { return AttendanceOverallCheckCollectionViewCell() }
        
        cell.delegate = delegate
        
        return cell
    }()
    
    @IBOutlet weak var leftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCenterXConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(AttendanceModificationCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceModificationCollectionViewCell.identifier)
        collectionView.register(AttendanceOverallCheckCollectionViewCell.self, forCellWithReuseIdentifier: AttendanceOverallCheckCollectionViewCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    
    @IBAction private func leftButtonTapped(_ sender: UIButton) {
        leftCenterXConstraint.priority = .required
        rightCenterXConstraint.priority = .defaultHigh
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: [.centeredHorizontally], animated: true)
        leftCell.tableViewReload()
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.leftLabel.textColor = UIColor.appColor(.ppsBlack)
            self.rightLabel.textColor = UIColor.appColor(.ppsGray2)
        }
    }
    @IBAction private func rightButtonTapped(_ sender: UIButton) {
        leftCenterXConstraint.priority = .defaultHigh
        rightCenterXConstraint.priority = .required
        
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.centeredHorizontally], animated: true)
        rightCell.tableViewReload()
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.leftLabel.textColor = UIColor.appColor(.ppsGray2)
            self.rightLabel.textColor = UIColor.appColor(.ppsBlack)
        }
    }
}

extension AttendanceManagerModeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0: return leftCell
        case 1: return rightCell
        default: break
        }
        
        return UICollectionViewCell()
    }
}

extension AttendanceManagerModeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
