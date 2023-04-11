//
//  AttendanceOverallCheckCollectionViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/20.
//

import UIKit

final class AttendanceOverallCheckViewModel {
    let studyID: ID
    
    var studyStartDate: Date?
    
//    var precedingDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
//    var followingDate = Date()
    var allMemebersAttendanceStatistics = [UserAttendanceStatistics]()
    
    var alignment = Observable(LeftButtonAlignment.name)
//    lazy var selectedPeriods = Observable("\(DateFormatter.shortenDottedDateFormatter.string(from: precedingDate))~\(DateFormatter.shortenDottedDateFormatter.string(from: followingDate))")
    var reloadTable = Observable(false)
    var error = Observable(PeoplesError.noError)
    
    init(studyID: ID) {
        self.studyID = studyID
    }
    
    func getStartDateOfStudy() {
        Network.shared.getAllParticipatedStudies { result in
            switch result {
            case .success(let studyEndToEndInformations):
                let studyEndToEndInformation = studyEndToEndInformations.filter{ $0.studyID == self.studyID}.first
                self.studyStartDate = studyEndToEndInformation?.start
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getUserAttendanceOverallFromEndToEnd() {
        guard let studyStartDate = studyStartDate else { return }
//        let dashedStudyStartDate = DateFormatter.dashedDateFormatter.string(from: studyStartDate)
//        let dashedToday = DateFormatter.dashedDateFormatter.string(from: Date())
        
//        🛑전체 누적 조회 기간 동안의 통계를 받아오고 처리하기
        Network.shared.getAllMembersAttendaneStatisticsBetween(studyID: studyID) { result in
            switch result {
            case .success(let allMemebersAttendanceStatistics):
                self.allMemebersAttendanceStatistics = allMemebersAttendanceStatistics
                self.sortStatistics()
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }

    func getAllMembersAttendaneStatisticsBetween(studyID: ID) {
        Network.shared.getAllMembersAttendaneStatisticsBetween(studyID: studyID) { result in
            switch result {
            case .success(let allMemebersAttendanceStatistics):
                self.allMemebersAttendanceStatistics = allMemebersAttendanceStatistics
                self.sortStatistics()
                
//                🛑api 나온 후 이거랑 비슷한 작업 해줘야.
//                self.precedingDate = studyStartDate
//                self.followingDate = Date()
//
//                self.selectedPeriods.value = "\(DateFormatter.shortenDottedDateFormatter.string(from: self.precedingDate))~\(DateFormatter.shortenDottedDateFormatter.string(from: self.followingDate))"
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func toggleAlginment() {
        alignment.value = alignment.value == .name ? .attendance : .name
        sortStatistics()
        reloadTable.value = true
    }
    
    func sortStatistics() {
        alignment.value == .name ? sortStatisticsInOrderOfName() : sortStatisticsInOrderOfAttendance()
    }
    
    func sortStatisticsInOrderOfName() {
        allMemebersAttendanceStatistics.sort { lhs, rhs in
            if lhs.nickName == rhs.nickName {
                return lhs.userID < rhs.userID
            } else {
                return lhs.nickName < rhs.nickName
            }
        }
    }
    
    func sortStatisticsInOrderOfAttendance() {
        allMemebersAttendanceStatistics.sort { member1, member2 in
            if member1.attendedCount != member2.attendedCount {
                return member1.attendedCount > member2.attendedCount
            } else if member1.lateCount != member2.lateCount {
                return member1.lateCount > member2.lateCount
            } else if member1.absentCount != member2.absentCount {
                return member1.absentCount > member2.absentCount
            } else if member1.allowedCount != member2.allowedCount {
                return member1.allowedCount > member2.allowedCount
            } else if member1.nickName != member2.nickName {
                return member1.nickName > member2.nickName
            } else {
                return member1.userID > member2.userID
            }
        }
    }
}

final class AttendanceOverallCheckCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AttendanceOverallCheckCollectionViewCell"
    
    private var viewModel: AttendanceOverallCheckViewModel?
    
    weak var delegate: (BottomSheetAddable & Navigatable & Managable)?
    
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
        
        contentView.backgroundColor = .white
        headerView.backgroundColor = .white
        tableView.backgroundColor = .white
        
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
    
    internal func configureCellWith(studyID: ID) {
        viewModel = AttendanceOverallCheckViewModel(studyID: studyID)
        
        guard let viewModel = viewModel else { return }
        viewModel.getAllMembersAttendaneStatisticsBetween(studyID: studyID)
        // to ehd: 이부분에서 break point잡아서 보면 allMembersAttendanceStatistics에 0 values
        headerView.toggleAlignment = viewModel.toggleAlginment
        setBinding()
    }
    
    private func setBinding() {
        guard let viewModel = viewModel, let delegate = delegate else { return }
        viewModel.alignment.bind { [weak self] alignment in
            guard let self = self else { return }
            
            objc_sync_enter(self)
            self.headerView.toggleSortyingTypeLabel(alignmet: alignment)
            objc_sync_exit(self)
        }
        
        viewModel.reloadTable.bind { _ in
            self.tableView.reloadData()
        }
        viewModel.error.bind { error in
            UIAlertController.handleCommonErros(presenter: delegate, error: error)
        }
    }
}

extension AttendanceOverallCheckCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.allMemebersAttendanceStatistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceIndividualOverallInfoTableViewCell.identifier, for: indexPath) as? AttendanceIndividualOverallInfoTableViewCell,
              let viewModel = viewModel else { return AttendanceIndividualOverallInfoTableViewCell() }
        
        cell.configureCell(with: viewModel.allMemebersAttendanceStatistics[indexPath.row])
        
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
        guard let viewModel = viewModel else { return }
        let aMemberAttendanceStats = viewModel.allMemebersAttendanceStatistics[indexPath.row]
        
        let AttendancePersonalVC = AttendancePersonalViewController()
        
        delegate?.syncManager(with: AttendancePersonalVC)
        
        AttendancePersonalVC.configureViewControllerWith(studyID: viewModel.studyID, stats: aMemberAttendanceStats)
        AttendancePersonalVC.title = delegate?.title
        
        delegate?.push(vc: AttendancePersonalVC)
    }
}
