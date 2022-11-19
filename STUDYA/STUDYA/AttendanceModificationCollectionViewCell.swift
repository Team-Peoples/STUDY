//
//  AttendanceModificationCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendanceModificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceModificationCollectionViewCell"
    
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.dataSource = self
        t.delegate = self
        t.register(AttendanceModificationHeaderView.nib(), forHeaderFooterViewReuseIdentifier: AttendanceModificationHeaderView.identifier)
        t.register(AttendanceIndividualInfoTableViewCell.self, forCellReuseIdentifier: AttendanceIndividualInfoTableViewCell.identifier)
        t.separatorStyle = .none
        
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        contentView.addSubview(tableView)
        tableView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AttendanceModificationCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualInfoTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: AttendanceModificationHeaderView.identifier)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        56
    }
}

extension AttendanceModificationCollectionViewCell: UITableViewDelegate {
    
}
