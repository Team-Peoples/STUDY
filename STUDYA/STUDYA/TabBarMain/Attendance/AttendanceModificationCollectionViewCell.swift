//
//  AttendanceModificationCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit

final class AttendancesModificationViewModel {
    let studyID: Int
    
    var allUsersAttendancesForADay: AllUsersAttendanceForADay?
    var times: [Time] = []
    var attendancesForATime: [SingleUserAnAttendanceInformation] = []
    
    var alignment = Observable(LeftButtonAlignment.name)
    lazy var selectedTime = Observable(times.first ?? "")
    var selectedDate = Observable(DateFormatter.shortenDottedDateFormatter.string(from: Date()))
    var reloadTableView = Observable(false)
    
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
                // to ehd: 이부분에서 break point잡아서 보면 allUsersAttendancesForADay에 "hh:mm"형식의 key는 있지만 0 values
                weakSelf.times = allUsersAttendancesForADay.map { $0.key }.sorted()
                
                if let firstTime = weakSelf.times.first, let attendancesForATime = allUsersAttendancesForADay[firstTime] {
                    
                    weakSelf.selectedTime.value = firstTime
                    weakSelf.attendancesForATime = attendancesForATime
                    // to ehd: 이부분에서 break point잡아서 보면 attendancesForATime: 0 values
                } else {
                    weakSelf.selectedTime.value = ""
                    weakSelf.attendancesForATime = []
                }
                
                weakSelf.reloadTableView.value = true
                
            case .failure(let error):
                weakSelf.error?.value = error
            }
        }
    }
    
    func updateAllMembersAttendance() {
        let dashedSelectedDate = selectedDate.value.convertShortenDottedDateToDashedDate()

        Network.shared.getAllMembersAttendanceOn(dashedSelectedDate, studyID: studyID) { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case .success(let allUsersAttendancesForADay):
                weakSelf.allUsersAttendancesForADay = allUsersAttendancesForADay

                if !allUsersAttendancesForADay.isEmpty, weakSelf.times.contains(weakSelf.selectedTime.value) {
                    weakSelf.attendancesForATime = allUsersAttendancesForADay[weakSelf.selectedTime.value]!
                } else {
                    weakSelf.selectedTime.value = ""
                    weakSelf.attendancesForATime = []
                }
                weakSelf.reloadTableView.value = true

            case .failure(let error):
                weakSelf.error?.value = error
            }
        }
    }
    
    func updateAttendance(_ attendanceInfo: SingleUserAnAttendanceInformationForPut, completion: @escaping () -> ()) {
        Network.shared.updateAttendanceInformation(attendanceInfo) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let isSuccess):
                guard isSuccess else { return }
                
                weakSelf.updateAllMembersAttendance()
                completion()
                
            case .failure(let error):
                weakSelf.error?.value = error
            }
        }
    }
    
    func updateAttendancesData(at time: Time, by alignment: LeftButtonAlignment) {
        sortAttendanceForATimeFromAttendanceForADay(at: time)
        alignAttendancesForATime(by: alignment)
        reloadTableView.value = true
    }
    
    func alignAttendancesForATime(by alignment: LeftButtonAlignment) {
        if alignment == .name {
            attendancesForATime.sort { (first, second) -> Bool in
                if first.nickName == second.nickName {
                    if AttendanceSeperator(inputString: first.attendanceStatus).attendance.priority == AttendanceSeperator(inputString: second.attendanceStatus).attendance.priority {
                        return first.userID > second.userID
                    } else {
                        return AttendanceSeperator(inputString: first.attendanceStatus).attendance.priority > AttendanceSeperator(inputString: second.attendanceStatus).attendance.priority
                    }
                } else {
                    return first.nickName > second.nickName
                }
            }
        } else {
            attendancesForATime.sort { (lhs, rhs) -> Bool in
                
                if AttendanceSeperator(inputString: lhs.attendanceStatus).attendance.priority == AttendanceSeperator(inputString: rhs.attendanceStatus).attendance.priority {
                    if lhs.nickName == rhs.nickName {
                        return lhs.userID > rhs.userID
                    } else {
                        return lhs.nickName > rhs.nickName
                    }
                } else {
                    return AttendanceSeperator(inputString: lhs.attendanceStatus).attendance.priority > AttendanceSeperator(inputString: rhs.attendanceStatus).attendance.priority
                }
            }
        }
        
        self.alignment.value = alignment
    }
    
    func sortAttendanceForATimeFromAttendanceForADay(at time: Time) {
        guard let allUsersAttendancesForADay = allUsersAttendancesForADay else { return }
        
        selectedTime.value = time
        attendancesForATime = allUsersAttendancesForADay[time]!
    }
}

final class AttendanceModificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceModificationCollectionViewCell"
    
    private var viewModel: AttendancesModificationViewModel?
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
    private lazy var noAttendanceLabel = CustomLabel(title: "출결이 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func reloadTableView() {
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
        guard let viewModel = viewModel, let delegate = delegate else { return }
        
        viewModel.reloadTableView.bind({ _ in
            self.tableView.reloadData()
        })
        viewModel.error?.bind({ error in
            UIAlertController.handleCommonErros(presenter: delegate, error: error)
        })
    }
    
    private func configureViews() {
        contentView.backgroundColor = .white
        headerView.backgroundColor = .white
        tableView.backgroundColor = .white
        
        noAttendanceLabel.isHidden = true
        
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
        
        tableView.addSubview(noAttendanceLabel)
        noAttendanceLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(tableView)
        }
    }
}

extension AttendanceModificationCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let attendancesForATime = viewModel?.attendancesForATime else {
            return 0
        }
        
        let numberOfMembers = attendancesForATime.count
        
        if numberOfMembers == 0 {
            noAttendanceLabel.isHidden = false
        } else {
            noAttendanceLabel.isHidden = true
        }
        
        return numberOfMembers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualInfoTableViewCell.identifier, for: indexPath) as? AttendanceIndividualInfoTableViewCell,
              let viewModel = viewModel else {
            return AttendanceIndividualInfoTableViewCell()
        }
        
        cell.configureCell(with: viewModel.attendancesForATime[indexPath.row])
        
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
        guard let delegate = delegate, let viewModel = viewModel else { return }
        let bottomVC = AttendanceBottomIndividualUpdateViewController(doneButtonTitle: "완료")
        
        bottomVC.configure(with: viewModel.attendancesForATime[indexPath.row], viewModel: viewModel)
        
        delegate.presentBottomSheet(vc: bottomVC, detent: 316, prefersGrabberVisible: false)
    }
}

enum LeftButtonAlignment: String {
    case name = "이름순"
    case attendance = "출석순"
}
