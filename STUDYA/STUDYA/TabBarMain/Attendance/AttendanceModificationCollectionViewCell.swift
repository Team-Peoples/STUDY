//
//  AttendanceModificationCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendancesModificationViewModel {
    var studyID: Int
    
    var allUsersAttendancesForADay: AllUsersAttendanceForADay?
    var times: [Time] = []
    
    var attendancesForATime: Observable<[SingleUserAnAttendanceInformation]> = Observable([])
    
    var alignment = Observable(LeftButtonAlignment.name)
    lazy var selectedTime = Observable(times.first ?? "")
    var selectedDate = Observable(DateFormatter.dashedDateFormatter.string(from: Date()))
    
    var error: Observable<PeoplesError>?
    
    init(studyID: Int) {
        self.studyID = studyID
    }
    
    func getAllMembersAttendanceOn(date: DashedDate) {
        Network.shared.getAllMembersAttendanceOn(date, studyID: studyID) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let allUsersAttendancesForADay):
                
                weakSelf.allUsersAttendancesForADay = allUsersAttendancesForADay
                weakSelf.times = allUsersAttendancesForADay.map { $0.key }
                
                if let firstTime = weakSelf.times.first, let attendancesForATime = allUsersAttendancesForADay[firstTime] {
                    weakSelf.selectedTime = Observable(firstTime)
                    weakSelf.attendancesForATime = Observable(attendancesForATime)
                } else {
                    weakSelf.selectedTime = Observable("")
                    weakSelf.attendancesForATime = Observable([])
                }
                
            case .failure(let error):
                weakSelf.error = Observable(error)
            }
        }
    }
    
    func updateAllMembersAttendance() {
        Network.shared.getAllMembersAttendanceOn(selectedDate.value, studyID: studyID) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let allUsersAttendancesForADay):
                weakSelf.allUsersAttendancesForADay = allUsersAttendancesForADay
                
                if !allUsersAttendancesForADay.isEmpty, weakSelf.times.contains(weakSelf.selectedTime.value) {
                    weakSelf.attendancesForATime = Observable(allUsersAttendancesForADay[weakSelf.selectedTime.value]!)
                } else {
                    weakSelf.selectedTime = Observable("")
                    weakSelf.attendancesForATime = Observable([])
                }
                
            case .failure(let error):
                weakSelf.error = Observable(error)
            }
        }
    }
    
    func updateAttendance(_ attendanceInfo: SingleUserAnAttendanceInformation, completion: @escaping () -> Void) {
        Network.shared.updateAttendanceInformation(attendanceInfo) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let isSuccess):
                guard isSuccess else { return }
                
                weakSelf.updateAllMembersAttendance()
                completion()
                
            case .failure(let error):
                weakSelf.error = Observable(error)
            }
        }
    }
}

final class AttendanceModificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceModificationCollectionViewCell"
    
    internal var viewModel: AttendancesModificationViewModel?
    internal var delegate: (BottomSheetAddable & Navigatable)? {
        didSet {
            headerView.navigatableBottomSheetableDelegate = delegate
        }
    }
    private lazy var headerView: AttendanceModificationHeaderView = {
        
        let nib = UINib(nibName: AttendanceModificationHeaderView.identifier, bundle: nil)
        let v = nib.instantiate(withOwner: self).first as! AttendanceModificationHeaderView
        
        return v
    }()
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.dataSource = self
        t.delegate = self

        t.register(AttendanceIndividualInfoTableViewCell.self, forCellReuseIdentifier: AttendanceIndividualInfoTableViewCell.identifier)
        t.separatorStyle = .none
        
        return t
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
    
    internal func configureCellWith(studyID: ID) {
        viewModel = AttendancesModificationViewModel(studyID: studyID)
        
        guard let viewModel = viewModel else { return }
        
        setBinding()
        viewModel.getAllMembersAttendanceOn(date: DateFormatter.dashedDateFormatter.string(from: Date()))
        headerView.configureViewWith(viewModel: viewModel)
    }
    
    private func setBinding() {
        guard let viewModel = viewModel else { return }
        
        viewModel.selectedDate.bind({ dashedDate in
            self.headerView.configureRightButtonTitle(dashedDate)
        })
        viewModel.attendancesForATime.bind({ allUsersAnAttendanceInformationArray in
            self.tableView.reloadData()
        })
    }
}

extension AttendanceModificationCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let attendancesForATime = viewModel?.attendancesForATime else {
            return 0
        }
        
        let numberOfMembers = attendancesForATime.value.count
//        NotificationCenter.default.post(name: .attendanceManagerTableViewsReloaded, object: delegate, userInfo: ["numberOfMembers" : numberOfMembers])
        
        return numberOfMembers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualInfoTableViewCell.identifier, for: indexPath) as? AttendanceIndividualInfoTableViewCell else {
            return AttendanceIndividualInfoTableViewCell()
        }
        cell.anUserAttendanceInformation = viewModel?.attendancesForATime.value[indexPath.row]
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
        
//        bottomVC.viewModel = viewModel
        bottomVC.indexPath = indexPath
        bottomVC.viewType = .individualUpdate
        
        guard let delegate = delegate else { return }
        
        delegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
}

enum LeftButtonAlignment: String {
    case name = "이름순"
    case attendance = "출석순"
}
