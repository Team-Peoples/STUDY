//
//  StudyScheduleCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit

class StudyScheduleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StudyScheduleCollectionViewCell"
   
    var studyScheduleAtSelectedDate = [StudySchedule]() {
        didSet {
            checkScheduleIsEmpty()
            scheduleTableView.reloadData()
        }
    }
   
    lazy var studyScheduleEmptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "일정이 없어요 😴"
        return lbl
    }()
    
    private let scheduleTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        
        tableView.register(StudyScheduleTableViewCell.self, forCellReuseIdentifier: StudyScheduleTableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudyScheduleEmptyLabelConstraints), name: .bottomSheetSizeChanged, object: nil)
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func updateStudyScheduleEmptyLabelConstraints(_ notification: Notification) {
        let bottomSheetDisplayedPercentage = notification.userInfo?["percentage"] as? CGFloat
        let bottomSheetExpanded = bottomSheetDisplayedPercentage! == 100.0
        if bottomSheetExpanded {
            if studyScheduleAtSelectedDate.isEmpty {
                UIView.animate(withDuration: 0.1) {
                    self.studyScheduleEmptyLabel.snp.remakeConstraints { make in
                        make.center.equalTo(self.scheduleTableView)
                    }
                    self.studyScheduleEmptyLabel.layoutIfNeeded()
                }
            }
        } else {
            if studyScheduleAtSelectedDate.isEmpty {
                UIView.animate(withDuration: 0.1) {
                    self.studyScheduleEmptyLabel.snp.remakeConstraints { make in
                        make.centerX.equalTo(self.scheduleTableView)
                        make.top.equalTo(self.scheduleTableView).inset(80)
                    }
                    self.studyScheduleEmptyLabel.layoutIfNeeded()
                }
            }
        }
    }
    
    func reloadTableView() {
       
        scheduleTableView.reloadData()
    }
    
    func checkScheduleIsEmpty() {

        if studyScheduleAtSelectedDate.isEmpty {
            scheduleTableView.addSubview(studyScheduleEmptyLabel)
            studyScheduleEmptyLabel.snp.makeConstraints { make in
                make.centerX.equalTo(scheduleTableView)
                make.top.equalTo(scheduleTableView).inset(80)
            }
        } else {
            studyScheduleEmptyLabel.removeFromSuperview()
        }
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        self.contentView.addSubview(scheduleTableView)
        scheduleTableView.backgroundColor = .appColor(.background)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        scheduleTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
}

extension StudyScheduleCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studyScheduleAtSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudyScheduleTableViewCell.identifier, for: indexPath) as! StudyScheduleTableViewCell
        
        let studySchedules = studyScheduleAtSelectedDate[indexPath.row]
        cell.configure(schedule: studySchedules, kind: .personal)
        
        return cell
    }
}

extension StudyScheduleCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
