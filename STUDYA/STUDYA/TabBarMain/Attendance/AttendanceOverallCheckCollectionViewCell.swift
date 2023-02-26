//
//  AttendanceOverallCheckCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/20.
//

import UIKit

final class AttendanceOverallCheckCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceOverallCheckCollectionViewCell"
    
    weak var delegate: (BottomSheetAddable & Navigatable & SwitchSyncable)? {
        didSet {
            headerView.navigatableBottomSheetableDelegate = delegate
        }
    }
    
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.dataSource = self
        t.delegate = self

        t.register(AttendanceIndividualOverallInfoTableViewCell.self, forCellReuseIdentifier: AttendanceIndividualOverallInfoTableViewCell.identifier)
        t.separatorStyle = .none
        
        return t
    }()
    private lazy var headerView: AttendanceOverallCheckHeaderView = {
        
        let nib = UINib(nibName: AttendanceOverallCheckHeaderView.identifier, bundle: nil)
        let v = nib.instantiate(withOwner: self).first as! AttendanceOverallCheckHeaderView
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(headerView)
        contentView.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(contentView)
            make.height.equalTo(53)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func tableViewReload() {
        tableView.reloadData()
    }
}

extension AttendanceOverallCheckCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualOverallInfoTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        136
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        136
    }
}

extension AttendanceOverallCheckCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AttendancePersonalVC = AttendancePersonalViewController()
        delegate?.syncSwitchWith(nextVC: AttendancePersonalVC)
        delegate?.push(vc: AttendancePersonalVC)
    }
}
