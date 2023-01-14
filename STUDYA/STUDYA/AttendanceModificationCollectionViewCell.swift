//
//  AttendanceModificationCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendancesModificationViewModel {
    var studyID: Int
    var alignment: Observable<LeftButtonAlignment> = Observable(.name)
    lazy var time: Observable<Time> = Observable(times?.value.first ?? "??")
    var times: Observable<[Time]>?
    var attendancesForATime: Observable<[[SingleUserAnAttendanceInformation]]>?
    var error: Observable<PeoplesError>?
    
    init(studyID: Int) {
        self.studyID = studyID
    }
    
    func getAllMembersAttendanceOn() {
        Network.shared.getAllMembersAttendanceOn(Date().convertToDashedString(), studyID: studyID) { result in
            switch result {
            case .success(let allUserAttendancesForADay):
                self.times = Observable(allUserAttendancesForADay.map { $0.key })
                self.attendancesForATime = Observable(allUserAttendancesForADay.map { $0.value })
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
}

final class AttendanceModificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceModificationCollectionViewCell"
    
    internal var viewModel: AttendancesModificationViewModel? {
        didSet {
            headerView.viewModel = viewModel
            setBinding()
        }
    }
    internal var delegate: (BottomSheetAddable & Navigatable)! {
        didSet {
            print("델리게이트")
            headerView.navigatableBottomSheetableDelegate = delegate
        }
    }
    
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.dataSource = self
        t.delegate = self

        t.register(AttendanceIndividualInfoTableViewCell.self, forCellReuseIdentifier: AttendanceIndividualInfoTableViewCell.identifier)
        t.separatorStyle = .none
        
        return t
    }()
    private lazy var headerView: AttendanceModificationHeaderView = {
        
        let nib = UINib(nibName: AttendanceModificationHeaderView.identifier, bundle: nil)
        let v = nib.instantiate(withOwner: self).first as! AttendanceModificationHeaderView
        
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
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBinding() {
        viewModel?.alignment.bind({ leftButtonAlignment in
            self.headerView.configureAlignment(leftButtonAlignment)
        })
        viewModel?.time.bind { time in
            self.headerView.configureTime(time)
        }
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
}

extension AttendanceModificationCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bottomVC = AttendanceBottomViewController()
        
        bottomVC.viewType = .individualUpdate
        
        delegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
}

enum LeftButtonAlignment: String {
    case name = "이름순"
    case attendance = "출석순"
}
