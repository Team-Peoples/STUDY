//
//  AttendanceModificationCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendancesModificationViewModel {
    var studyID: Int
    
    var allUsersAttendacneForADay: Observable<AllUsersAttendacneForADay>?
    var alignment = Observable(LeftButtonAlignment.name)
    lazy var selectedTime = Observable(times?.value.first ?? "??")
    var selectedDate = Observable(Date().convertToDashedString())
    var times: Observable<[Time]>?
    var attendancesForATime: Observable<[SingleUserAnAttendanceInformation]>?
    var error: Observable<PeoplesError>?
    
    init(studyID: Int) {
        self.studyID = studyID
    }
    
    func getAllMembersAttendanceOn(date: dashedDate) {
        Network.shared.getAllMembersAttendanceOn(date, studyID: studyID) { result in
            switch result {
            case .success(let allUserAttendancesForADay):
                guard let firstTime = self.times?.value.first, let attendancesForATime = allUserAttendancesForADay[firstTime] else { return }
                
                self.times = Observable(allUserAttendancesForADay.map { $0.key })
                self.selectedTime = Observable(firstTime)
                self.attendancesForATime = Observable(attendancesForATime)
                
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
        }
    }
    internal var delegate: (BottomSheetAddable & Navigatable)! {
        didSet {
            print("델리게이트")
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
    
    private func setBinding() {
        viewModel?.selectedDate.bind({ dashedDate in
            self.viewModel?.getAllMembersAttendanceOn(date: dashedDate)
            self.headerView.configureRightButtonTitle(dashedDate)
//            self.viewModel?.info?.bind({ allUsersAttendacneForADay in
//                allUsersAttendacneForADay[dashedDate]
//            })
        })
        viewModel?.attendancesForATime?.bind({ allUsersAnAttendanceInformationArray in
            self.tableView.reloadData()
        })
    }
}

extension AttendanceModificationCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let attendancesForATime = viewModel?.attendancesForATime else { return 0 }
        return attendancesForATime.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualInfoTableViewCell.identifier, for: indexPath) as? AttendanceIndividualInfoTableViewCell else {
            return AttendanceIndividualInfoTableViewCell()
        }
        cell.anUserAttendanceInformation = viewModel?.attendancesForATime?.value[indexPath.row]
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
        
//        bottomVC에 데이터 넣어주기
        bottomVC.viewType = .individualUpdate
        
        delegate.presentBottomSheet(vc: bottomVC, detent: bottomVC.viewType.detent, prefersGrabberVisible: false)
    }
}

enum LeftButtonAlignment: String {
    case name = "이름순"
    case attendance = "출석순"
}
